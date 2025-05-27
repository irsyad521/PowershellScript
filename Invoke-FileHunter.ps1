function Invoke-FileHunter {
    param(
        [string]$Path = "C:\",
        [string[]]$Extensions = @("*.xml", "*.ini", "*.config", "*.txt", "*.ps1", "*.json", "*.log", "*.bat"),
        [string[]]$SensitiveFiles = @("*.kdbx", "*.sql"),
        [string[]]$Keywords = @("password", "Password", "pwd", "credential", "secret"),
        [string]$OutputLog = "C:\Users\Public\Documents\FileHunterResults.txt"
    )

    $results = @()
    $sensitiveHits = @()

    Write-Host "[*] Starting scan in $Path ..." -ForegroundColor Cyan

    # Scan regular extensions for keyword matches
    foreach ($ext in $Extensions) {
        try {
            Get-ChildItem -Path $Path -Include $ext -Recurse -ErrorAction SilentlyContinue -Force |
            ForEach-Object {
                $file = $_.FullName
                foreach ($kw in $Keywords) {
                    $matches = Select-String -Path $file -Pattern $kw -SimpleMatch -ErrorAction SilentlyContinue
                    if ($matches) {
                        $results += $file
                        break
                    }
                }
            }
        }
        catch {
            Write-Warning "[-] Error accessing files with extension $ext : $_"
        }
    }

    # Cari file sensitif berdasar ekstensi walau tanpa keyword
    foreach ($sensitive in $SensitiveFiles) {
        try {
            Get-ChildItem -Path $Path -Include $sensitive -Recurse -ErrorAction SilentlyContinue -Force |
            ForEach-Object {
                $sensitiveHits += $_.FullName
            }
        }
        catch {
            Write-Warning "[-] Error accessing sensitive file types ($sensitive): $_"
        }
    }

    # Gabungkan dan simpan hasil
    $finalResults = ($results + $sensitiveHits) | Sort-Object -Unique
    if ($finalResults.Count -gt 0) {
        $finalResults | Out-File -FilePath $OutputLog -Encoding UTF8
        Write-Host "[+] Scan complete. Found $($finalResults.Count) matching or sensitive files. Results saved to $OutputLog" -ForegroundColor Green
    } else {
        Write-Host "[-] No matching or sensitive files found." -ForegroundColor Yellow
    }
}
