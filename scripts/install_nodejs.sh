curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh

sudo -E bash nodesource_setup.sh

sudo apt-get install -y nodejs

node -v

rm -f nodesource_setup.sh