# User authentication with Rails4

デフォルトでGemfileに書かれている`bcrypt-ruby`を利用すると、認証機能つきのモデルがつくれる。

## Setup

Gemfileのbcrypt-rubyの行のコメントアウトを解除して、

```
# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'
```

gemをインストール

```
$ bundle install --path vendor/bundle
```


## Model

まずはscaffoldでuserをつくる。このとき、**モデルに`password_digest:string`というカラムをつける。**

```
$ bundle exec rails generate scaffold user email password_digest:string
```

作成された**Userモデル(app/models/user.rb)に、`has_secure_password`をセット**

```
class User < ActiveRecord::Base
  has_secure_password
end
```

新規ユーザを登録してみる。`password`と`password_confirmation`をセットすると、`password_digest`がセットされる。

```
$ bundle exec rails console
> @user = User.new
> @user.email = 'knmkr@knmkr.info'
> @user.password = 'pass'
> @user.password_confirmation = 'pass'
> @user.save
(0.5ms)  BEGIN
SQL (15.6ms)  INSERT INTO "users" ("created_at", "email", "password_digest", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["created_at", Fri, 25 Oct 2013 11:45:52 JST +09:00], ["email", "knmkr@knmkr.info"], ["password_digest", "$2a$1..."], ["updated_at", Fri, 25 Oct 2013 11:45:52 JST +09:00]]
(1.6ms)  COMMIT
=> true
```

ユーザの検索。(find_byは、検索条件を指定して最初の1件を取得)

```
> u = User.find_by(email: 'knmkr@knmkr.info')
> u.password
=> nil
> u.password_digest
=> "$2a$1...."
```

このユーザで認証（ログイン処理）するには`.authenticate('password')`をする

```
> u.authenticate('123')
=> false
> u.authenticate('pass')
=> #<User id: 1, name: nil, email: "knmkr@knmkr.info", created_at: "2013-10-25 02:45:52", password_digest: "$2a$1...", updated_at: "2013-10-25 02:45:52"
```
