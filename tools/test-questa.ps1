param([string[]]$Experiment = @())

$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$groups = Get-Content -LiteralPath (Join-Path $taskRoot 'tests/experiments.json') -Raw | ConvertFrom-Json
if ($Experiment.Count -gt 0) {
    foreach ($requested in $Experiment) {
        if ($requested -notin $groups.name) { throw "Unknown experiment: $requested" }
    }
    $groups = @($groups | Where-Object { $_.name -in $Experiment })
}
$passed = 0
foreach ($group in $groups) {
    $taskBuild = Join-Path $taskRoot ('.build/questa_' + $group.name)
    New-Item -ItemType Directory -Force -Path $taskBuild | Out-Null
    Push-Location -LiteralPath $taskBuild
    try {
        Write-Host "Testing $($group.name) with Questa"
        if (-not (Test-Path -LiteralPath 'work')) {
            & vlib work
            if ($LASTEXITCODE -ne 0) { throw 'vlib failed' }
        }
        $taskSources = @($group.sources | ForEach-Object { Join-Path $taskRoot $_ })
        $taskSources += Join-Path $taskRoot 'tests/tb_pkg.vhd'
        $taskSources += @($group.benches | ForEach-Object { Join-Path $taskRoot ('tests/' + $_ + '.vhd') })
        $taskCompile = & vcom -93 @taskSources 2>&1
        $taskCompile | Set-Content -LiteralPath 'compile.log'
        if ($LASTEXITCODE -ne 0) { $taskCompile | Write-Host; throw "vcom failed for $($group.name)" }
        $taskDo = @('onerror {quit -code 1 -f}', 'onbreak {quit -code 1 -f}')
        foreach ($bench in $group.benches) {
            $taskDo += "vsim -t 1ps work.$bench"
            $taskDo += 'set BreakOnAssertion 2'
            $taskDo += 'run -all'
            $taskDo += 'quit -sim'
        }
        $taskDo += 'quit -code 0 -f'
        $taskDo | Set-Content -LiteralPath 'run.do'
        $taskOutput = & vsim -c -do run.do 2>&1
        $taskExit = $LASTEXITCODE
        $taskOutput | Set-Content -LiteralPath 'simulation.log'
        if ($taskExit -ne 0) { $taskOutput | Write-Host; throw "Questa failed for $($group.name)" }
        foreach ($bench in $group.benches) {
            if (-not ($taskOutput -match ('PASS: ' + $bench))) { $taskOutput | Write-Host; throw "Incomplete test: $bench" }
            $taskOutput | Where-Object { $_ -match ('PASS: ' + $bench) } | Write-Host
            $passed++
        }
    }
    finally { Pop-Location }
}
Write-Host "$passed testbenches passed across $($groups.Count) experiment groups with Questa."
