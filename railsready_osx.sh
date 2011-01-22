#!/bin/bash
#
# Rails Ready - get ready for Rails
# Written by Gordon Diggs | gordon@diggs.me | gordondiggs.com
# Released under the MIT License
#

echo "Creating install dir..."
cd && mkdir -p $HOME/railsready/src && cd $HOME/railsready && touch install.log

# Install homebrew
echo "Installing Homebrew..."
ruby -e "$(curl -fsSLk https://gist.github.com/raw/323731/install_homebrew.rb)" >> install.log

# Reload terminal so that we can use the brew command
source $HOME/.bash_profile

# Define which packages we're going to install
packages=("wget" "git" "postgresql" "imagemagick" "readline" "most")

# Install the packages defined above
for package in "${packages[@]}"
do
	echo "Installing $package..."
  brew install $package >> install.log
done

# Install RVM
echo "Installing RVM..."
bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head ) >> install.log
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.' >> ~/.bash_profile
source $HOME/.rvm/scripts/rvm

# Install Ruby
echo "Installing Ruby 1.9.2..."
rvm install 1.9.2 >> install.log
rvm --default use 1.9.2 >> install.log

# Reload the terminal so we can use gem
source ~/.bash_profile

# Install some gems
echo "Installing gems..."
gem install rails bundler passenger >> install.log

echo "Done! Enjoy!"
