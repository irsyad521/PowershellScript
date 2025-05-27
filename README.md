# Invoke-FileHunter

PowerShell tool untuk hunting file konfigurasi dan file yang mengandung kata kunci sensitif seperti password, secret, key, dan lainnya.

---

## Cara Pakai

1. Buka PowerShell dengan hak akses Administrator.

2. Jalankan perintah berikut untuk langsung load dan menjalankan script:

```powershell
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/irsyad521/PowershellScript/refs/heads/main/Invoke-FileHunter.ps1')
Invoke-FileHunter -Path "C:\" -OutputLog "C:\Users\Public\Documents\ScanResults.txt"
