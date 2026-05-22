# Flutter SDK installation script for Windows
# Run in PowerShell as Administrator

$flutterVersion = "3.29.3"
$installPath = "$env:USERPROFILE\flutter"
$zipPath = "$env:TEMP\flutter.zip"

Write-Host "=== Flutter SDK 安装脚本 ===" -ForegroundColor Green

# Step 1: Download
Write-Host "[1/4] 下载 Flutter SDK $flutterVersion..."
$url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_$flutterVersion-stable.zip"
Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing

# Step 2: Extract
Write-Host "[2/4] 解压到 $installPath..."
Expand-Archive -Path $zipPath -DestinationPath (Split-Path $installPath) -Force
Remove-Item $zipPath

# Step 3: Add to PATH
Write-Host "[3/4] 添加到系统 PATH..."
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installPath\bin*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$installPath\bin", "User")
    $env:Path = "$env:Path;$installPath\bin"
}

# Step 4: Verify
Write-Host "[4/4] 验证安装..."
flutter doctor
Write-Host "=== 完成！重启终端后生效 ===" -ForegroundColor Green
