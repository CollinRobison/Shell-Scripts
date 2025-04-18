## Simple Aliases

alias cls="clear" 

alias gitgonefeature="git branch | grep -v "master" | grep -v "main" | xargs git branch -D"

## Terminal Games

alias brickbreak="$(dirname "${BASH_SOURCE[0]}")/brick_breaker.sh"
alias flap="$(dirname "${BASH_SOURCE[0]}")/flappy.sh"

## Functions

function gitcode () {
    # This is a command that will update a local repo to origin and then open it up in VS Code.

    if [ -z "$1" ]; then 
        echo "Please specify project path."
        return 1 
    fi

    # Convert to absolute path
    full_path=$(realpath "$1")

    # Check if there are any changes locally not pushed 
    status=$(git -C "$full_path" status 2>&1)
    exit_code=$?

    # Check if git status failed
    if [ $exit_code -ne 0 ]; then
        echo "Error running git status: $status"
        return $exit_code
    fi

    # decide whether to do a git pull and open vs code
    if [[ "$status" == *'Changes not staged for commit'* ]]; then
        code -- "$full_path"
    elif [[ "$status" == *'branch is up to date'* ]]; then
        git -C "$full_path" pull && code -- "$full_path"
    else
        echo "there was an error"
    fi
}



function list-alias() {
    # function to list all of my git aliases and the definitions of what they do. 
    printf "
    Aliases and Functions:
    ---------------------
    cls = Clear the terminal screen.
    gitcode = Pull current git branch to match remote and then open VS Code for a project. 
    gitgonefeature = Remove all git branches except main and master. 
    
    Terminal Games:
    -------------
    brickbreak = play the brick breaker game in the terminal.
    flap = Run the flappy bird game in the terminal.
    "
}

alias alias-list="list-alias"