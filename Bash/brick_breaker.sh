#!/usr/bin/env bash

# Terminal-based Brick Breaker Game

## I didn't create this, it was a copilot prompt. 

declare -A bricks
declare -A board

# Bash version check for associative arrays (Bash 4+ required)
if ((BASH_VERSINFO[0] < 4)); then
  echo "This game requires Bash version 4 or higher (for associative arrays)."
  echo "On macOS, install Bash 5+ with: brew install bash"
  exit 1
fi

# Initialize game variables
rows=20
cols=40
ball_x=$((cols / 2))
ball_y=$((rows - 2))
ball_dx=1
ball_dy=-1
paddle_x=$((cols / 2 - 2))
paddle_width=5
score=0
lives=3

declare -A bricks
declare -A board

# Function to initialize the game board
initialize_board() {
  for ((i=0; i<rows; i++)); do
    for ((j=0; j<cols; j++)); do
      board[$i,$j]=" "
    done
  done

  # Add bricks
  for ((i=1; i<=5; i++)); do
    for ((j=5; j<cols-5; j+=2)); do
      bricks[$i,$j]="B"
      board[$i,$j]="B"
    done
  done

  # Add paddle
  for ((i=0; i<paddle_width; i++)); do
    board[$((rows-1)),$((paddle_x+i))]="="
  done

  # Add ball
  board[$ball_y,$ball_x]="O"
}

# Function to clear the screen (portable)
clear_screen() {
  if command -v tput >/dev/null 2>&1; then
    tput reset
  else
    clear
  fi
}

# Function to draw the game board
draw_board() {
  clear_screen
  echo "Score: $score Lives: $lives"
  for ((i=0; i<rows; i++)); do
    for ((j=0; j<cols; j++)); do
      echo -n "${board[$i,$j]}"
    done
    echo
  done
}

# Adjusting the paddle movement to make it more responsive
move_paddle() {
  local direction=$1
  if [[ $direction == "left" && $paddle_x -gt 0 ]]; then
    for ((i=0; i<2; i++)); do # Move paddle faster to the left
      if [[ $paddle_x -gt 0 ]]; then
        board[$((rows-1)),$((paddle_x+paddle_width-1))]=" "
        ((paddle_x--))
        board[$((rows-1)),$paddle_x]="="
      fi
    done
  elif [[ $direction == "right" && $((paddle_x+paddle_width)) -lt $cols ]]; then
    for ((i=0; i<2; i++)); do # Move paddle faster to the right
      if [[ $((paddle_x+paddle_width)) -lt $cols ]]; then
        board[$((rows-1)),$paddle_x]=" "
        ((paddle_x++))
        board[$((rows-1)),$((paddle_x+paddle_width-1))]="="
      fi
    done
  fi
}

# Function to move the ball
move_ball() {
  local new_x=$((ball_x + ball_dx))
  local new_y=$((ball_y + ball_dy))

  # Check for collisions with walls
  if [[ $new_x -le 0 || $new_x -ge $((cols-1)) ]]; then
    ball_dx=$((ball_dx * -1))
  fi
  if [[ $new_y -le 0 ]]; then
    ball_dy=$((ball_dy * -1))
  fi

  # Check for collisions with paddle
  if [[ $new_y -eq $((rows-1)) && $new_x -ge $paddle_x && $new_x -lt $((paddle_x + paddle_width)) ]]; then
    ball_dy=$((ball_dy * -1))
  fi

  # Check for collisions with bricks
  if [[ ${bricks[$new_y,$new_x]} == "B" ]]; then
    ball_dy=$((ball_dy * -1))
    bricks[$new_y,$new_x]=" "
    board[$new_y,$new_x]=" "
    ((score++))
  fi

  # Check if ball falls below paddle
  if [[ $new_y -ge $rows ]]; then
    ((lives--))
    if [[ $lives -le 0 ]]; then
      echo "Game Over! Final Score: $score"
      exit
    fi
    ball_x=$((cols / 2))
    ball_y=$((rows - 2))
    ball_dx=1
    ball_dy=-1
    return
  fi

  # Update ball position
  board[$ball_y,$ball_x]=" "
  ball_x=$new_x
  ball_y=$new_y
  board[$ball_y,$ball_x]="O"
}

# Main game loop
initialize_board
while true; do
  draw_board

  # Read player input
  # Portable read: -t expects seconds (float on macOS, int on Git Bash)
  input=""
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: -t accepts float
    read -t 0.05 -n 1 input  # Faster ball: shorter delay
  else
    # Linux/WSL/Git Bash: -t accepts int (0.1 may not work, fallback to 1)
    read -t 0.5 -n 1 input  # Faster ball: shorter delay
  fi
  case $input in
    a) move_paddle "left" ;;
    d) move_paddle "right" ;;
    q) echo "Game Quit! Final Score: $score"; exit ;;
  esac

  # Move the ball
  move_ball

done