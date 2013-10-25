# User authentication with Rails4

## Model

`password_digest:string`カラムをつけて、`has_secure_password`を設定すると、認証機能つきのモデルがつくれる。

まずはscaffoldでuserをつくる

```
$ bundle exec rails generate scaffold user email password_digest:string
```

app/models/user.rbに、`has_secure_password`をセット

```
class User < ActiveRecord::Base
  has_secure_password
end
```

新規ユーザを登録してみる。`password`と`password_confirmation`をセットすると、`password_digest`がセットされる。

```
$ bundle exec rails console
> @user = User.new
> @user.email = 'knmkr@knmkr.com'
> @user.password = 'pass'
> @user.password_confirmation = 'pass'
> @user.save
(0.5ms)  BEGIN
SQL (15.6ms)  INSERT INTO "users" ("created_at", "email", "password_digest", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["created_at", Fri, 25 Oct 2013 11:45:52 JST +09:00], ["email", "knmkr@knmkr.com"], ["password_digest", "$2a$1..."], ["updated_at", Fri, 25 Oct 2013 11:45:52 JST +09:00]]
(1.6ms)  COMMIT
=> true
```

id=1のユーザを探してみる

```
> u = User.find(1)
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
=> #<User id: 1, name: nil, email: "knmkr@email.com", created_at: "2013-10-25 02:45:52", password_digest: "$2a$1...", updated_at: "2013-10-25 02:45:52"
```
