param(
    [string[]]$Experiment = @(),
    [string]$Ghdl = 'ghdl',
    [switch]$Wave,
    [switch]$CompileOnly
)

$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$groups = Get-Content -LiteralPath (Join-Path $taskRoot 'tests/experiments.json') -Raw | ConvertFrom-Json
if ($Experiment.Count -gt 0) {
    foreach ($requested in $Experiment) {
        if ($requested -notin $groups.name) { throw "Unknown experiment: $requested" }
    }
    $groups = @($groups | Where-Object { $_.name -in $Experiment })
}

function Invoke-Ghdl {
    param([string[]]$GhdlArgs)
    & $Ghdl @GhdlArgs
    if ($LASTEXITCODE -ne 0) { throw "GHDL failed: $($GhdlArgs -join ' ')" }
}

$passed = 0
foreach ($group in $groups) {
    $taskBuild = Join-Path $taskRoot ('.build/' + $group.name)
    New-Item -ItemType Directory -Force -Path $taskBuild | Out-Null
    Push-Location -LiteralPath $taskBuild
    try {
        Write-Host "Testing $($group.name)"
        # Dependencies are analyzed in manifest order; incompatible entity versions stay isolated.
        foreach ($source in $group.sources) {
            Invoke-Ghdl @('-a', '--std=93', (Join-Path $taskRoot $source))
        }
        foreach ($top in $group.tops) { Invoke-Ghdl @('-e', '--std=93', $top) }
        Invoke-Ghdl @('-a', '--std=93', (Join-Path $taskRoot 'tests/tb_pkg.vhd'))
        foreach ($bench in $group.benches) {
            Invoke-Ghdl @('-a', '--std=93', (Join-Path $taskRoot ('tests/' + $bench + '.vhd')))
            Invoke-Ghdl @('-e', '--std=93', $bench)
            if ($CompileOnly) { continue }
            $runArgs = @('-r', '--std=93', $bench, '--assert-level=error', '--stop-delta=10000')
            if ($Wave) { $runArgs += ('--wave=' + $bench + '.ghw') }
            $taskOutput = & $Ghdl @runArgs 2>&1
            $taskExit = $LASTEXITCODE
            $taskOutput | ForEach-Object { Write-Host $_ }
            if ($taskExit -eq -1 -and -not $taskOutput) {
                throw "GHDL could not launch $bench. This workstation can block LLVM-generated executables through Windows Application Control; run tools/test-questa.ps1 for simulation or use -CompileOnly for GHDL analysis/elaboration."
            }
            if ($taskExit -ne 0 -or -not ($taskOutput -match ('PASS: ' + $bench))) {
                throw "Simulation failed or did not reach its completion assertion: $bench"
            }
            $passed++
        }
    }
    finally { Pop-Location }
}
if ($CompileOnly) { Write-Host "GHDL analysis and elaboration passed for $($groups.Count) experiment groups." }
else { Write-Host "$passed testbenches passed across $($groups.Count) experiment groups." }
