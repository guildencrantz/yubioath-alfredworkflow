# yubioath-alfredworkflow

This workflow uses the [ykman](https://developers.yubico.com/yubioath-desktop/) cli application to lookup OATH tokens and pass them into the currently selected active window (recommended installation via `brew install ykman`).

Right now this workflow only works if you've executed `ykman oath remember-password` to save your PIN to disk.
