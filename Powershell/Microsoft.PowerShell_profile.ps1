

## functions
function gitgonefeature {
    # Ensure the current directory is a git repository
    if (-not (Test-Path .git)) {
        Write-Host "Error: Not a git repository." -ForegroundColor Red
        return
    }

    # Get all branches except "master" and "main"
    $branches = git branch | ForEach-Object { $_.Trim() } | Where-Object { $_ -notmatch '^(master|main)$' }

    # Delete the branches
    foreach ($branch in $branches) {
        git branch -D $branch
        Write-Host "Deleted branch: $branch" -ForegroundColor Green
    }
}

# Function to update a local git repository to match origin and open it in VS Code
function gitcode {
    param (
        [string]$Path
    )

    # Check if the path is provided
    if (-not $Path) {
        Write-Host "Please specify project path." -ForegroundColor Red
        return
    }

    # Convert to absolute path
    $fullPath = Resolve-Path -Path $Path

    # Check if the path is a git repository
    if (-not (Test-Path "$fullPath\.git")) {
        Write-Host "Error: Not a git repository." -ForegroundColor Red
        return
    }

    # Get git status
    $status = git -C $fullPath status 2>&1
    $exitCode = $LASTEXITCODE

    # Check if git status failed
    if ($exitCode -ne 0) {
        Write-Host "Error running git status: $status" -ForegroundColor Red
        return
    }

    # Decide whether to do a git pull and open VS Code
    if ($status -match 'Changes not staged for commit') {
        code $fullPath
    } elseif ($status -match 'branch is up to date') {
        git -C $fullPath pull | Out-Null
        code $fullPath
    } else {
        Write-Host "There was an error." -ForegroundColor Red
    }
}

function list-alias {
    Write-Host @"
    gitgonefeature = Remove all git branches except main and master.
    gitcode = Pull current git branch to match remote and then open VS Code for a project.
"@ -ForegroundColor Green
}

# Create an alias for the list-alias function
Set-Alias alias-list list-alias

## other script files

. "$PSScriptRoot\Setup-AutoComplete.ps1"