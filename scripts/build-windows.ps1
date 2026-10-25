[CmdletBinding()]
param(
    [string]$VisualStudioPath,
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'

try {
    $vswhereCommand = Get-Command vswhere.exe -ErrorAction SilentlyContinue
    $vswhere = if ($vswhereCommand) { $vswhereCommand.Source } else {
        Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    }
    if (-not (Test-Path -LiteralPath $vswhere)) {
        throw 'vswhere.exe was not found. Install the Visual Studio Installer or add vswhere.exe to PATH.'
    }

    $installationsJson = & $vswhere -products '*' -prerelease -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -format json
    if ($LASTEXITCODE -ne 0) { throw "vswhere failed with exit code $LASTEXITCODE." }
    $installations = @($installationsJson -join "`n" | ConvertFrom-Json)
    if ($VisualStudioPath) {
        $requestedPath = (Resolve-Path -LiteralPath $VisualStudioPath).Path.TrimEnd('\', '/')
        $installation = $installations | Where-Object {
            $_.installationPath.TrimEnd('\', '/') -eq $requestedPath
        } | Select-Object -First 1
    } else {
        $installation = $installations | Sort-Object { [version]$_.installationVersion } -Descending | Select-Object -First 1
    }
    if (-not $installation) {
        throw 'No matching Visual Studio installation with the C++ x64/x86 tools component was found. Check -VisualStudioPath and installed components (Build Tools and prerelease are accepted).'
    }

    $devShell = Join-Path $installation.installationPath 'Common7\Tools\Launch-VsDevShell.ps1'
    if (-not (Test-Path -LiteralPath $devShell)) { throw "Developer PowerShell script not found: $devShell" }
    & $devShell -Arch amd64 -HostArch amd64 -SkipAutomaticLocation

    foreach ($tool in @('cmake.exe', 'ctest.exe', 'ninja.exe', 'cl.exe')) {
        $command = Get-Command $tool -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $command) { throw "Required tool $tool was not found after MSVC initialization. Install it or add it to PATH." }
        Write-Output "$tool=$($command.Source)"
    }
    if ([string]::IsNullOrWhiteSpace($env:INCLUDE)) { throw 'MSVC initialization left INCLUDE empty.' }
    $headerFound = @($env:INCLUDE -split ';' | Where-Object {
        $_ -and (Test-Path -LiteralPath (Join-Path $_ 'cstddef'))
    }).Count -gt 0
    if (-not $headerFound) { throw 'cstddef was not found in any INCLUDE directory after MSVC initialization.' }
    Write-Output 'INCLUDE check passed: cstddef found.'

    $sourceDirectory = Split-Path -Parent $PSScriptRoot
    $buildDirectory = Join-Path $sourceDirectory 'build\windows-msvc'
    & cmake.exe -S $sourceDirectory -B $buildDirectory -G Ninja '-DCMAKE_BUILD_TYPE=Debug' '-DCMAKE_CXX_COMPILER=cl.exe' '-DBUILD_TESTING=ON'
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    $buildArguments = @('--build', $buildDirectory, '--config', 'Debug')
    if ($Clean) { $buildArguments += '--clean-first' }
    & cmake.exe @buildArguments
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    & ctest.exe --test-dir $buildDirectory -C Debug --output-on-failure
    exit $LASTEXITCODE
} catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
