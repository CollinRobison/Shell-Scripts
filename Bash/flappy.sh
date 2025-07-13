#!/bin/bash

## I didn't create this, it was a copilot prompt. 

# Terminal dimensions
ROWS=20
COLS=40

# Bird position
bird_row=$((ROWS / 2))
bird_col=5

# Pipe position and gap
pipe_col=$COLS
pipe_gap=5
pipe_top=$((RANDOM % (ROWS - pipe_gap - 2) + 1))

# Game variables
gravity=1
bird_velocity=0
score=0
game_over=0

# Draw the game screen
draw_screen() {
    clear
    for ((row = 0; row <= ROWS; row++)); do
        for ((col = 0; col <= COLS; col++)); do
            if ((row == 0 || row == ROWS)); then
                # Draw top and bottom borders
                echo -n "#"
            elif ((col == bird_col && row == bird_row)); then
                # Draw the bird
                echo -n "O"
            elif ((col == pipe_col && (row < pipe_top || row > pipe_top + pipe_gap))); then
                # Draw the pipe
                echo -n "|"
            else
                # Empty space
                echo -n " "
            fi
        done
        echo
    done
    echo "Score: $score"
}

# Check for collisions
check_collision() {
    if ((bird_row <= 0 || bird_row >= ROWS)); then
        game_over=1
    elif ((bird_col == pipe_col && (bird_row < pipe_top || bird_row > pipe_top + pipe_gap))); then
        game_over=1
    fi
}

# Main game loop
while ((game_over == 0)); do
    # Draw the screen
    draw_screen

    # Check for collisions
    check_collision
    if ((game_over == 1)); then
        echo "Game Over! Final Score: $score"
        break
    fi

    # Move the bird
    bird_velocity=$((bird_velocity + gravity))
    bird_row=$((bird_row + bird_velocity))

    # Move the pipe
    pipe_col=$((pipe_col - 1))
    if ((pipe_col < 0)); then
        pipe_col=$COLS
        pipe_top=$((RANDOM % (ROWS - pipe_gap - 2) + 1))
        score=$((score + 1))
    fi

    # Handle user input
    read -t 0.1 -n 1 input
    if [[ $input == "x" ]]; then
        bird_velocity=-2
    fi
done