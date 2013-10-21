# Rails First Step

動作確認したときの環境: MacOSXで、`ruby 2.0`が`rbenv`でインストール済み。


## Railsのローカルインストール

なるべくrubyのグローバル環境にgemをインストールしたくないので、
`bundler`を使ってrailsをプロジェクト内にローカルインストールする。

```
# `bundler`のみ、rubyグローバル環境にインストール
$ rbenv exec gem install bundler
$ rbenv rehash

# Railsプロジェクトを作成するため、いったんrailsを./vendor/bundle/にインストール。(後でアンインストール)
$ cat << EOS > Gemfile
source "http://rubygems.org"
gem "rails", "4.0.0"
EOS
$ bundle install --path vendor/bundle

# Railsプロジェクト作成
$ RAILS_PROJECT_NAME=rails_1st_step
$ bundle exec rails new $RAILS_PROJECT_NAME --skip-bundle

# ./vendor/bundleのrailsをアンインストール
$ rm -rf Gemfile Gemfile.lock .bundle vendor/bundle

# Railsプロジェクト内にgemをインストール
$ cd rails_1st_step
$ bundle install --path vendor/bundle

# 今後gemを追加したいときは、Railsプロジェクト内のGemfileに書いて、
# $ bundle install --path vendor/bundle
# $ bundle exec xxx
```


##
