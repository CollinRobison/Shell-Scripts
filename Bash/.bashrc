if [ -z "$SHELL_SCRIPTS_ROOT" ]; then
  echo "Error: SHELL_SCRIPTS_ROOT environment variable is not set. Please set it to the absolute path of your Shell-Scripts folder."
  return 1
fi
## Simple Aliases


# Cross-platform clear alias
alias cls="clear"

alias gitgonefeature="git branch | grep -v 'master' | grep -v 'main' | xargs git branch -D"

## Terminal Games


# Cross-shell (Bash/Zsh) brickbreak and flap functions
find_bash5() {
  if [ -x "/opt/homebrew/bin/bash" ]; then
    echo "/opt/homebrew/bin/bash"
  elif [ -x "/usr/local/bin/bash" ]; then
    echo "/usr/local/bin/bash"
  elif [ -n "$WINDIR" ]; then
    # On Windows, prefer the current bash if version >= 3
    bash_path="$(command -v bash)"
    bash_ver_full="$($bash_path --version 2>/dev/null | head -n1)"
    # Try to extract version as X.Y or X
    bash_ver_num="$(echo "$bash_ver_full" | grep -oE '[0-9]+(\.[0-9]+)?' | head -n1)"
    if [[ "$bash_ver_num" =~ ^([3-9]|[1-9][0-9])(\.[0-9]+)?$ ]]; then
      echo "$bash_path"
    fi
  elif command -v bash >/dev/null 2>&1; then
    # On other systems, require Bash 4+
    bash_path="$(command -v bash)"
    bash_ver_full="$($bash_path --version 2>/dev/null | head -n1)"
    bash_ver_num="$(echo "$bash_ver_full" | grep -oE '[0-9]+(\.[0-9]+)?' | head -n1)"
    if [[ "$bash_ver_num" =~ ^([4-9]|[1-9][0-9])(\.[0-9]+)?$ ]]; then
      echo "$bash_path"
    fi
  fi
}

brickbreak() {
  local bash5
  bash5="$(find_bash5)"
  if [ -z "$bash5" ]; then
    echo "Error: Bash 4+ is required to run brick_breaker.sh. Please install Bash 5+ (brew install bash on macOS)."
    return 1
  fi
  "$bash5" "$SHELL_SCRIPTS_ROOT/Bash/brick_breaker.sh"
}

flap() {
  local bash5
  bash5="$(find_bash5)"
  if [ -z "$bash5" ]; then
    echo "Error: Bash 4+ is required to run flappy.sh. Please install Bash 5+ (brew install bash on macOS)."
    return 1
  fi
  "$bash5" "$SHELL_SCRIPTS_ROOT/Bash/flappy.sh"
}
## Functions


# Portable realpath fallback for Windows Git Bash
realpath_portable() {
    if command -v realpath >/dev/null 2>&1; then
        realpath "$1"
    else
        # Fallback for Windows Git Bash
        python -c "import os,sys; print(os.path.abspath(sys.argv[1]))" "$1"
    fi
}

function gitcode () {
    # This is a command that will update a local repo to origin and then open it up in VS Code.

    if [ -z "$1" ]; then 
        echo "Please specify project path."
        return 1 
    fi

    # Convert to absolute path (cross-platform)
    full_path=$(realpath_portable "$1")

    # Check if there are any changes locally not pushed 
    git_status=$(git -C "$full_path" status 2>&1)
    exit_code=$?

    # Check if git status failed
    if [ $exit_code -ne 0 ]; then
        echo "Error running git status: $git_status"
        return $exit_code
    fi

    # decide whether to do a git pull and open vs code
    if [[ "$git_status" == *'Changes not staged for commit'* ]]; then
        code -- "$full_path"
    elif [[ "$git_status" == *'branch is up to date'* ]]; then
        git -C "$full_path" pull && code -- "$full_path"
    else
        echo "there was an error"
    fi
}




function list-alias() {
    # function to list all of my git aliases and the definitions of what they do. 
    printf "\nAliases and Functions:\n---------------------\ncls = Clear the terminal screen.\ngitcode = Pull current git branch to match remote and then open VS Code for a project. \ngitgonefeature = Remove all git branches except main and master. \n\nTerminal Games:\n-------------\nbrickbreak = play the brick breaker game in the terminal.\nflap = Run the flappy bird game in the terminal.\n"
}

alias alias-list="list-alias"