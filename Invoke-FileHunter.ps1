function Invoke-FileHunter {
    param(
        [string]$Path = "C:\",
        [string[]]$Extensions = @("*.xml", "*.ini", "*.config", "*.txt", "*.ps1", "*.json", "*.log", "*.bat"),
        [string[]]$Keywords = @("password", "Password", "pwd", "credential", "secret"),
        [string]$OutputLog = "C:\Users\Public\Documents\FileHunterResults.txt"
    )

    $results = @()

    Write-Host "[*] Starting scan in $Path ..." -ForegroundColor Cyan

    foreach ($ext in $Extensions) {
        try {
            Get-ChildItem -Path $Path -Include $ext -Recurse -ErrorAction SilentlyContinue -Force |
            ForEach-Object {
                $file = $_.FullName
                foreach ($kw in $Keywords) {
                    $matches = Select-String -Path $file -Pattern $kw -SimpleMatch -ErrorAction SilentlyContinue
                    if ($matches) {
                        $results += $file
                        break  # Stop checking other keywords once a match is found
                    }
                }
            }
        }
        catch {
            Write-Warning "[-] Error accessing path or files: $_"
        }
    }

    if ($results.Count -gt 0) {
        $results | Sort-Object -Unique | Out-File -FilePath $OutputLog -Encoding UTF8
        Write-Host "[+] Scan complete. Found $($results.Count) matches. Results saved to $OutputLog" -ForegroundColor Green
    } else {
        Write-Host "[-] No files containing specified keywords found." -ForegroundColor Yellow
    }
}
