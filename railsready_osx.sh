#!/bin/bash
#
# Rails Ready - get ready for Rails
# Written by Gordon Diggs | gordon@diggs.me | gordondiggs.com
# Released under the MIT License
#

msg_prefix="*****"

gtfo_now() {
  echo "$msg_prefix Exiting now..."
  exit 1
}
 
# capture exit signal
trap gtfo_now SIGINT

echo "$msg_prefix Creating install dir..."
cd && mkdir -p $HOME/railsready && cd $HOME/railsready

# Install homebrew
echo "$msg_prefix Installing Homebrew..."
ruby -e "$(curl -fsSLk https://gist.github.com/raw/323731/install_homebrew.rb)"

# Reload terminal so that we can use the brew command
touch $HOME/.bash_profile
source $HOME/.bash_profile

# Define which packages we're going to install
packages=("wget" "git" "postgresql" "imagemagick" "readline" "most")

# Install the packages defined above
for package in "${packages[@]}"
do
	echo "$msg_prefix Installing $package..."
  brew install $package
done

# Install git bash completion
echo "$msg_prefix Installing Git Bash Completion..."
curl https://github.com/git/git/raw/master/contrib/completion/git-completion.bash >> ~/.git-completion.bash
echo "source ~/.git-completion.bash" >> $HOME/.bash_profile

# Configure postgres
echo "$msg_prefix Configuring Postgresql..."
postgres_version=`psql --version | grep -o [0-9].[0-9].[0-9]`
initdb /usr/local/var/postgres
cp /usr/local/Cellar/postgresql/$postgres_version/org.postgresql.postgres.plist ~/Library/LaunchAgents
launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

# Install RVM
echo "$msg_prefix Installing RVM..."
bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.' >> $HOME/.bash_profile
source $HOME/.rvm/scripts/rvm

# Install Ruby
echo "$msg_prefix Installing Ruby 1.9.2..."
rvm install 1.9.2
rvm --default use 1.9.2

# Reload the terminal so we can use gem
source $HOME/.bash_profile

# Install some gems
echo "$msg_prefix Installing gems..."
gem install rails bundler passenger

echo "$msg_prefix Done! Enjoy!"
