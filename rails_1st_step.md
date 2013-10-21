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


## 検索機能を追加

model

```
# app/models/search_form.rb
class SearchForm
  include ActiveModel::Model

  attr_accessor :q
end
```

```
# app/models/dailyreport.rb
class Dailyreport < ActiveRecord::Base
  scope :find_content, ->(q) { where 'contents like ?', "%#{q}%" }
end
```

view

```
# app/views/dailyreports/index.html.erb
<%= form_for @search_form, url: dailyreports_path, html: {method: :get} do |f| %>
  <%= f.search_field :q %>
  <%= f.submit 'search' %>
<% end %>
```

controller

```
# app/controllers/dailyreports_controller.rb
def index
  # @dailyreports = Dailyreport.all
  @search_form = SearchForm.new params[:search_form]
  @dailyreports = Dailyreport.all
  if @search_form.q.present?
    @dailyreports = @dailyreports.find_content @search_form.q
  end
end
```
