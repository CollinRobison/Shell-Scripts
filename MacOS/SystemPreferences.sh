echo "Setting up System Preferences..."

# do not open previous previewed files (e.g. PDFs) when opening a new one
defaults write com.apple.Preview ApplePersistenceIgnoreState YES

echo "Don't show previous files in Preview setup complete."

# show Library folder
chflags nohidden ~/Library

echo "Show Library folder setup complete."

# show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

echo "Show hidden files setup complete."

# show path bar
defaults write com.apple.finder ShowPathbar -bool true

echo "Show path bar setup complete."

# show status bar
defaults write com.apple.finder ShowStatusBar -bool true

echo "Show status bar setup complete."

# enable key repeating 

defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false              # For VS Code
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false      # For VS Code Insider
defaults write com.vscodium ApplePressAndHoldEnabled -bool false                      # For VS Codium
defaults write com.microsoft.VSCodeExploration ApplePressAndHoldEnabled -bool false   # For VS Codium Exploration users
defaults write com.exafunction.windsurf ApplePressAndHoldEnabled -bool false          # For Windsurf
defaults delete -g ApplePressAndHoldEnabled                                         # If necessary, reset global default

echo "Key repeating settings complete for VS Code."

killall Finder;
