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
$ PROJECT_NAME=rails_1st_step
$ bundle exec rails new $PROJECT_NAME --skip-bundle

# ./vendor/bundleのrailsをアンインストール
$ rm -rf Gemfile Gemfile.lock .bundle vendor/bundle

# Railsプロジェクト内にgemをインストール
$ cd $PROJECT_NAME
$ bundle install --path vendor/bundle

# 今後gemを追加したいときは、Railsプロジェクト内のGemfileに書いて、
# $ bundle install --path vendor/bundle
# $ bundle exec xxx
```


## サンプルアプリケーションの作成

サンプルとして、日報(dailyreports)をデータベースにCRUD(Create, Read, Update, Delete)するアプリケーションを作成。

```
# scaffoldでアプリケーションのひな形を作成
$ bundle exec rails generate scaffold dailyreport title contents created_at:datetime
$ bundle exec rake db:migrate

# テスト実行
$ bundle exec rake

# 開発サーバ起動
$ bundle exec rails s

# `localhost:3000/dailyreports`にアクセスすると、dailyreportsのトップページが表示される。
```
