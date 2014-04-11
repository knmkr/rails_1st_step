#!/usr/bin/env bash

WORK_DIR=.create_new_rails_project

PROJECT_NAME=$1
if [ "$2" = "" ]; then RAILS_VERSION="4.0.3"; else RAILS_VERSION=$2 ; fi  # Rails version

if [ $# -eq 0 -o $# -gt 2 ]; then echo "USAGE: $0 PROJECT_NAME"; exit 1; fi
if [ -d $PROJECT_NAME ]; then echo "'$PROJECT_NAME' directory already exists"; exit 1; fi
if [ -d $WORK_DIR ]; then echo "'$WORK_DIR' directory already exists"; exit 1; fi

mkdir $WORK_DIR
cd $WORK_DIR

# Install Bundler in global Ruby environment if not installed.
is_bundle_installed=$(echo `bundle -v` | awk '/Bundler version/ {print "installed"}')

if [ $is_bundle_installed != "installed" ]; then
    echo "Bundler not installed"
    rbenv exec gem install bundler
    rbenv rehash
fi

# Install Rails in ./vendor/bundle/ temporarily (uninstall later), to create a new Rails project.
cat << EOS > Gemfile
source "http://rubygems.org"
gem "rails", "$RAILS_VERSION"
EOS

bundle install --path vendor/bundle

# Create a new Rails project.
bundle exec rails new $PROJECT_NAME --skip-bundle --skip-test-unit

# Add .gitignore
curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/Rails.gitignore

# Uninstall Rails in ./vendor/bundle/
rm -rf Gemfile Gemfile.lock .bundle vendor/bundle

# Install gems in Rails project.
cd $PROJECT_NAME
bundle install --path vendor/bundle

cd ../../
mv $WORK_DIR/$PROJECT_NAME .
rm -rf $WORK_DIR

echo "done"
