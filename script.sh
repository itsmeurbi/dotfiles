#!/bin/bash

echo "Checking for command line tools..."
if ! xcode-select -p &> /dev/null
then
  echo "Installing command line tools..."
  xcode-select --install
fi

echo "Installing Brew..."
if ! command -v brew &> /dev/null
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> "$HOME/.zprofile"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing Oh-My-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh-My-zsh already installed."
fi

echo "Installing zsh aliases..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/config_files/zsh_aliases" "$HOME/.zsh_aliases"
if ! grep -q '\.zsh_aliases' "$HOME/.zshrc" 2>/dev/null; then
  echo '' >> "$HOME/.zshrc"
  echo '# Load custom aliases' >> "$HOME/.zshrc"
  echo '[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"' >> "$HOME/.zshrc"
fi

echo "Updating all dependencies..."
brew upgrade

echo "Cleaning up..."
brew cleanup

echo "Installing rbenv..."
if ! command -v rbenv &> /dev/null
then
  brew install rbenv
fi

echo "Installing nvm..."
if ! command -v nvm &> /dev/null
then
  brew install nvm
  mkdir -p "$HOME/.nvm"
  NVM_PREFIX=$(brew --prefix nvm)
  echo "export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"$NVM_PREFIX/nvm.sh\" ] && \. \"$NVM_PREFIX/nvm.sh\"  # This loads nvm
[ -s \"$NVM_PREFIX/etc/bash_completion.d/nvm\" ] && \. \"$NVM_PREFIX/etc/bash_completion.d/nvm\"  # This loads nvm bash_completion" >> "$HOME/.zshrc"
fi

echo "Installing node..."
if ! command -v node &> /dev/null
then
  brew install node
fi

echo "Installing yarn..."
if ! command -v yarn &> /dev/null
then
  npm install --global yarn
fi

echo "Installing redis..."
if ! command -v redis-server &> /dev/null
then
  brew install redis
  echo "Setting redis auto-start"
  ln -sfv "$(brew --prefix redis)"/*.plist "$HOME/Library/LaunchAgents"
fi

echo "Installing heroku cli..."
if ! command -v heroku &> /dev/null
then
  brew tap heroku/brew && brew install heroku
fi

echo "Installing gpg..."
if ! command -v gpg &> /dev/null
then
  brew install gnupg
fi

if [ ! -d "/Applications/Postgres.app" ]
then
  echo "Installing Postgres App..."
  brew install --cask postgres-unofficial
fi

if [ ! -d "/Applications/TablePlus.app" ]
then
  echo "Installing TablePlus..."
  brew install --cask tableplus
fi

if [ ! -d "/Applications/Google Chrome.app" ]
then
  echo "Installing Chrome..."
  brew install --cask google-chrome
fi

if [ ! -d "/Applications/iTerm.app" ]
then
  echo "Installing iTerm2..."
  brew install --cask iterm2
fi

if [ ! -d "/Applications/Visual Studio Code.app" ]
then
  echo "Installing VSCode..."
  brew install --cask visual-studio-code
fi

if [ ! -d "/Applications/Cursor.app" ]
then
  echo "Installing Cursor..."
  brew install --cask cursor
fi

echo "Copying VSCode config file..."
mkdir -p "$HOME/Library/Application Support/Code/User"
cp config_files/vs_code_settings.json "$HOME/Library/Application Support/Code/User/settings.json"

if [ ! -d "/Applications/Docker.app" ]
then
  echo "Installing Docker..."
  brew install --cask docker
fi


if [ ! -d "/Applications/Slack.app" ]
then
  echo "Installing Slack..."
  brew install --cask slack
fi