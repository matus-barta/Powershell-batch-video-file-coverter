# Powershell Video File converter

Powershell script for batch conversion for supported ffmpeg files

- **Usage:** video-converter.ps1 `-format` `source folder` `destination folder`

#### Available formats

- `-cineform`
- `-hevc` - using nvenc

_TODO: SW encoding and h264?, bitrate options?_

Script is using 7zip module. [How to install here.](https://stackoverflow.com/a/61995405)
