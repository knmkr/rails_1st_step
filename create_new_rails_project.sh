#!/usr/bin/env bash

PROJECT_NAME=$1

if [ $# -ne 1 ]; then echo "USAGE: $0 PROJECT_NAME"; exit 1; fi
if [ -d $PROJECT_NAME ]; then echo "'$PROJECT_NAME' directory already exists"; exit 1; fi
if [ -d work ]; then echo "'work' directory already exists"; exit 1; fi

mkdir work
cd work

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
gem "rails", "4.0.3"
EOS

bundle install --path vendor/bundle

# Create a new Rails project.
bundle exec rails new $PROJECT_NAME --skip-bundle --skip-test-unit

# Uninstall Rails in ./vendor/bundle/
rm -rf Gemfile Gemfile.lock .bundle vendor/bundle

# Install gems in Rails project.
cd $PROJECT_NAME
bundle install --path vendor/bundle

cd ../../
mv work/$PROJECT_NAME .
rm -rf work

echo "done"
