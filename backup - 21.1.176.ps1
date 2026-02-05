$source = "C:\Users\elaina15\Desktop\neoforge - 21.1.176\world"
$backup = "D:\OneDrive\backup - 21.1.176"


if (!(Test-Path $backup)) {
	New-Item -ItemType Directory -Path $backup
}
$timestamp = Get-Date -Format "(yyyy-MM-dd_HH-mm)"
$dest = Join-Path $backup "world $timestamp"

$uriSource = $source -replace "\\", "/"
$uriBackup = $backup -replace "\\", "/"
$uriDest = $dest -replace "\\", "/"

$linkSource = "$([char]27)]8;;$uriSource$([char]27)\$source$([char]27)]8;;$([char]27)\"
$linkBackup = "$([char]27)]8;;$uriBackup$([char]27)\$backup$([char]27)]8;;$([char]27)\"

$linkDestName = Split-Path $dest -Leaf
$linkDest = "$([char]27)]8;;$uriDest$([char]27)\$linkDestName$([char]27)]8;;$([char]27)\"

Write-Host $linkSource -NoNewLine -ForegroundColor Cyan; Write-Host "のバックアップを開始します..."
Write-Host "保存先: " -NoNewLine; Write-Host $linkBackup -ForegroundColor Cyan
try {
	Copy-Item -Path $source -Destination $dest -Recurse -Force -ErrorAction Stop

	Write-Host "Success!" -ForegroundColor Green
	Write-Host $linkDest -NoNewLine -ForegroundColor Cyan; Write-Host "として保存されました！"
}
catch {
	Write-Host "!Error: バックアップに失敗しました。" -ForegroundColor Red
	Write-Host $_.Exception.Message -ForegroundColor Red

	if (Test-Path $dest) {
		try {
			remove-Item -Path $dest -Recurse -Force -ErrorAction Stop
			Write-Host "Success!"-ForegroundColor Green
			Write-Host "残骸ファイル$($linkDestName)を削除しました。"
		}
		catch {
			Write-Host "!Warning: 残骸の削除に失敗しました、手動で削除してください。" -ForegroundColor Yellow
			Write-Host $_.Exception.Message -ForegroundColor Yellow

			Write-Host "`r2s..." -NoNewLine
			Start-Sleep -s 1
			Write-Host "`r1s..." -NoNewLine
			Start-Sleep -s 1
			Write-Host `r$linkDest -ForegroundColor Cyan
			explorer.exe /select,"$dest"
		}
	}
}