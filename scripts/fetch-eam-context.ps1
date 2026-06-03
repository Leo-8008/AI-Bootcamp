param(
    [Parameter(ParameterSetName = 'TaskType', Mandatory = $true)]
    [ValidateSet('adr', 'standard', 'exception', 'principle', 'software-eval', 'tool-eval', 'blueprint', 'overview')]
    [string]$TaskType,

    [Parameter(ParameterSetName = 'IntentText', Mandatory = $true)]
    [string]$IntentText
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$alwaysPageId = '78481720'
$overviewPageId = '434382050'
$standardProcessPageId = '357834693'

$taskTypeToPages = @{
    'adr' = @('378448646')
    'standard' = @('134849433', $standardProcessPageId)
    'exception' = @('369698720')
    'principle' = @('264221812')
    'software-eval' = @('395517931')
    'tool-eval' = @('331163651')
    'blueprint' = @('729905979')
    'overview' = @($overviewPageId)
}

function Test-AnyPattern {
    param(
        [string]$Text,
        [string[]]$Patterns
    )

    foreach ($pattern in $Patterns) {
        if ($Text -match $pattern) {
            return $true
        }
    }

    return $false
}

function Resolve-TaskTypeFromIntent {
    param([string]$Text)

    $normalized = $Text.ToLowerInvariant()

    $signals = @{
        adr = @(
            '\badr\b',
            'architecture decision',
            'architekturentscheidung',
            '\bdecision\b',
            '\bdecide\b',
            '\bentschei(d|dung)\b',
            '\bentscheiden\b',
            'should we',
            'sollten wir',
            '\bchoose\b',
            '\bchoice\b',
            '\boption\b'
        )
        standard = @(
            '\bstandard\b',
            'standardize',
            'standardise',
            'standardisierung',
            'standardisieren',
            'guideline',
            'vorgabe',
            'policy'
        )
        exception = @(
            '\bexception\b',
            'deviation',
            '\bwaiver\b',
            'temporary deviation',
            '\bausnahme\b',
            'abweichung'
        )
        principle = @(
            '\bprinciple\b',
            '\bprinzip\b',
            'grundsatz',
            'leitprinzip'
        )
        softwareEval = @(
            'software evaluation',
            'software eval',
            'software selection',
            'select software',
            'produktauswahl',
            'softwareauswahl',
            'vendor selection'
        )
        toolEval = @(
            'tool evaluation',
            'tool eval',
            'tool selection',
            'select a tool',
            'tooling decision',
            'werkzeug',
            'werkzeugauswahl'
        )
        blueprint = @(
            '\bblueprint\b',
            'solution blueprint',
            'arc42',
            'target architecture',
            'architecture overview',
            'lösungsentwurf',
            'zielarchitektur'
        )
    }

    $hasAdr = Test-AnyPattern -Text $normalized -Patterns $signals.adr
    $hasStandard = Test-AnyPattern -Text $normalized -Patterns $signals.standard

    if ($hasAdr -and $hasStandard) {
        return 'adr-or-standard'
    }

    if ($hasStandard) { return 'standard' }
    if ($hasAdr) { return 'adr' }
    if (Test-AnyPattern -Text $normalized -Patterns $signals.exception) { return 'exception' }
    if (Test-AnyPattern -Text $normalized -Patterns $signals.principle) { return 'principle' }
    if (Test-AnyPattern -Text $normalized -Patterns $signals.softwareEval) { return 'software-eval' }
    if (Test-AnyPattern -Text $normalized -Patterns $signals.toolEval) { return 'tool-eval' }
    if (Test-AnyPattern -Text $normalized -Patterns $signals.blueprint) { return 'blueprint' }

    return 'unknown'
}

function Resolve-Route {
    param(
        [string]$ResolvedTaskType
    )

    switch ($ResolvedTaskType) {
        'adr-or-standard' {
            return @{
                taskType = 'adr-or-standard'
                pageIds = @($alwaysPageId, '378448646', '134849433', $standardProcessPageId)
                nextAction = 'Ask one clarifying question to choose between ADR and Standard, or let solution-design-assistant-copilot ask it.'
            }
        }
        'unknown' {
            return @{
                taskType = 'unknown'
                pageIds = @($alwaysPageId, $overviewPageId)
                nextAction = 'Ask one clarifying question about the desired EAM artifact type before invoking solution-design-assistant-copilot.'
            }
        }
        default {
            return @{
                taskType = $ResolvedTaskType
                pageIds = @($alwaysPageId) + $taskTypeToPages[$ResolvedTaskType]
                nextAction = 'Invoke solution-design-assistant-copilot with this bundle.'
            }
        }
    }
}

function Get-ConfluenceCliPath {
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        throw 'Node.js is required but was not found on PATH.'
    }

    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        throw 'npm is required but was not found on PATH.'
    }

    if ($env:APPDATA) {
        $defaultCliPath = Join-Path $env:APPDATA 'npm\node_modules\confluence-cli\bin\confluence.js'
        if (Test-Path $defaultCliPath) {
            return $defaultCliPath
        }
    }

    $npmCommand = Get-Command npm.cmd -ErrorAction SilentlyContinue
    if (-not $npmCommand) {
        $npmCommand = Get-Command npm -ErrorAction SilentlyContinue
    }

    $npmRoot = (& $npmCommand.Source --silent root -g | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($npmRoot)) {
        throw 'Could not resolve npm global root.'
    }

    $cliPath = Join-Path $npmRoot 'confluence-cli\bin\confluence.js'
    if (-not (Test-Path $cliPath)) {
        throw "confluence-cli was not found at $cliPath. Install it with: npm install -g confluence-cli"
    }

    return $cliPath
}

function Get-ConfluencePageContent {
    param(
        [string]$CliPath,
        [string]$PageId
    )

    $content = (& node $CliPath read $PageId --format markdown 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to fetch Confluence page $PageId.`n$content"
    }

    if ([string]::IsNullOrWhiteSpace($content)) {
        throw "Confluence page $PageId returned no content."
    }

    return $content
}

$resolvedTaskType = if ($PSCmdlet.ParameterSetName -eq 'TaskType') { $TaskType } else { Resolve-TaskTypeFromIntent -Text $IntentText }
$route = Resolve-Route -ResolvedTaskType $resolvedTaskType
$cliPath = Get-ConfluenceCliPath

$fetchedPages = foreach ($pageId in $route.pageIds) {
    [pscustomobject]@{
        PageId = $pageId
        Content = Get-ConfluencePageContent -CliPath $cliPath -PageId $pageId
    }
}

$inputMode = if ($PSCmdlet.ParameterSetName -eq 'TaskType') { 'explicit-task-type' } else { 'intent-text' }
$displayIntent = if ($PSCmdlet.ParameterSetName -eq 'TaskType') { "(explicit task type: $TaskType)" } else { $IntentText.Trim() }

$output = New-Object System.Collections.Generic.List[string]
$output.Add("<!-- EAM-ROUTING: taskType=$($route.taskType) -->")
$output.Add("<!-- EAM-ROUTING: pageIds=$([string]::Join(',', $route.pageIds)) -->")
$output.Add('# EAM Context Bundle')
$output.Add('')
$output.Add('## Routing Summary')
$output.Add("- Input mode: $inputMode")
$output.Add("- Intent text: $displayIntent")
$output.Add("- Routed task type: $($route.taskType)")
$output.Add("- Suggested next action: $($route.nextAction)")
$output.Add("- Confluence page IDs: $([string]::Join(', ', $route.pageIds))")
$output.Add('')

$index = 1
foreach ($page in $fetchedPages) {
    $output.Add("--- Document ${index}: Confluence page $($page.PageId) ---")
    $output.Add($page.Content)
    $output.Add('')
    $index++
}

$output
