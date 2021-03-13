#Requires -Module 7Zip4PowerShell

$ffmpeg = ".\ffmpeg-git-full\bin\ffmpeg.exe"

if (!($args.Count -gt 1) -and ($args.Count -lt 3)) {
    Write-Error "Incorrect amount ($($args.Count)) of arguments... closing"
    Exit 1
}

$src = $args[0]
$dst = $args[1]

if (!((Test-Path $src) -and (Test-Path $dst))) {
    Write-Error "$src or $dst does not exist!"
    Exit 1
}

if (!((Get-Item $src) -is [System.IO.DirectoryInfo] -and (Get-Item $dst) -is [System.IO.DirectoryInfo])) {
    Write-Error "$src or $dst is no directory!"
    Exit 1
}

if (!(Test-Path "ffmpeg-git-full")) {
    Write-Host ">>> Missing ffmpeg... downloading"
    Invoke-WebRequest https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z -OutFile "$env:TMP\ffmpeg-git-full.7z"
    
    Write-Host ">>> Expanding file"
    Expand-7Zip -ArchiveFileName "$env:TMP\ffmpeg-git-full.7z" -TargetPath "./"
    Get-ChildItem -Filter "ffmpeg-*" | Rename-Item -NewName "ffmpeg-git-full"

    Write-Host ">>> Cleaning temp files"
    Remove-Item "$env:TMP\ffmpeg-git-full.7z"
}

function Invoke-FFMPEG {
    param (
        $FileName
    )
    
    Write-Host "Converting" $FileName

    #info how to use cineform https://github.com/paulpacifico/shutter-encoder/blob/master/src/functions/video/CineForm.java
    Start-Process -FilePath $ffmpeg -ArgumentList "-n -i `"$src\$FileName`" -c:v cfhd -quality film1 -pix_fmt yuv422p10 -c:a copy `"$dst\$FileName`"" -Wait
}


#bin\ffmpeg.exe -i "source" -c:v dnxhd -profile:v dnxhr_hq -c:a copy "destination"

Get-ChildItem -Path $src | Where-Object { $_ -is [System.IO.FileInfo] } | ForEach-Object { Invoke-FFMPEG $_.Name }
