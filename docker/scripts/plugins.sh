#!/bin/bash
# 1/ Download wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# 2/ Make it executable
chmod +x wp-cli.phar
# 3/ Move it into /usr/local/bin/wp
mv wp-cli.phar /usr/local/bin/wp
# Check whether the installation worked
wp --info