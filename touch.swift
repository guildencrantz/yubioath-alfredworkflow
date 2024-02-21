#!/usr/bin/swift
//
//  main.swift
//  cli
//
//  Created by Matt Henkel on 2/20/24.
//

import Darwin
import Foundation

func alert(proc: Process) async {
    proc.launchPath = "/usr/bin/osascript"
    proc.arguments = [
        "-e",
        "display dialog \"Press yubikey button\" buttons {\"Cancel\"}"
    ]
    proc.launch()
    proc.waitUntilExit()
    fputs("alert exited\n", stderr)
}

func ykman(proc: Process, query: String = "") async -> String {
    var serialFlag = ""
    if let YK_SERIAL = ProcessInfo.processInfo.environment["YK_SERIAL"] {
        serialFlag = "-d \(YK_SERIAL)"
    }

    let cmd = "/usr/local/bin/ykman \(serialFlag) oath accounts code \(query)"
    fputs("\(cmd)\n", stderr)

    proc.launchPath = "/usr/bin/env"
    proc.arguments = [
        "zsh",
        "-c",
        cmd
    ]

    let pipe = Pipe()
    proc.standardOutput = pipe

    proc.launch()
    proc.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let out = String(data: data, encoding: String.Encoding.utf8) ?? ""
    return out.components(separatedBy: .whitespacesAndNewlines).compactMap { $0.isEmpty ? nil : $0 }[1]
    fputs("ykman exited\n", stderr)
}

let query = CommandLine.arguments[1...].joined(separator: " ")

let semaphore = DispatchSemaphore(value: 0)

let ykman = Process()
Task {
    let code = await ykman(proc: ykman, query: query)
    print(code)
    semaphore.signal()
}

let alert = Process()
Task {
    await alert(proc: alert)
    semaphore.signal()
}

semaphore.wait()

if alert.isRunning {
    alert.terminate()
} else if ykman.isRunning {
    ykman.terminate()
}
