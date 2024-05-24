#!/usr/bin/swift

import Darwin
import Foundation

struct Items : Codable {
    let items: [Item]
}

struct Item : Codable {
    let arg: String
    let title: String
    let subtitle: String
}

let nameAndCode = #/(.+?)  +(.+)$/#

func ykman(serial: String = "", query: String = "") async -> [Item] {
    let proc = Process()
    proc.launchPath = "/usr/local/bin/ykman"
    proc.arguments = ["oath", "accounts", "code"]
    if !serial.isEmpty {
        proc.arguments?.insert("-d", at: 0)
        proc.arguments?.insert(serial, at: 1)
    }

    let pipe = Pipe()
    proc.standardOutput = pipe

    proc.launch()
    proc.waitUntilExit()


    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let codes = String(data: data, encoding: String.Encoding.utf8) ?? ""


    var items = [Item]()
    codes.components(separatedBy: .newlines).forEach { line in
        if let match = try? nameAndCode.firstMatch(in: line) {
            let title = String(match.1)
            if !query.isEmpty && !title.contains(query) {
                return
            }

            var arg = String(match.2)
            var subtitle = ""
            if (match.2 == "[Requires Touch]" ) {
                arg = title
                subtitle = "Requires Touch"
            }
            items.append(Item(
                arg: arg,
                title: title,
                subtitle: subtitle
            ))
        }
    }

    return items
}

let query = CommandLine.arguments.dropFirst().joined(separator: " ")
fputs("query: '\(query)'\n", stderr)

var serials = [""]
if let YK_SERIAL = ProcessInfo.processInfo.environment["YK_SERIAL"] {
    fputs("YK_SERIAL: '\(YK_SERIAL)'\n", stderr)
    serials = YK_SERIAL.components(separatedBy: ",")
} // TODO: else `ykman list` and parse?

let result = await withTaskGroup(of: [Item].self, returning: [Item].self) { group in
    for serial in serials {
        group.addTask {
            return await ykman(serial: serial, query: query)
        }
    }
    var result = [Item]()
    for await items in group {
        result.append(contentsOf: items)
    }
    return result
}

let items = Items(items: result)
if let retData = try? JSONEncoder().encode(Items(items: result)) {
    if let ret = String(data: retData, encoding: .utf8) {
        print(ret)
    }
}
