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


## Controller

scaffoldですでにほぼCRUDできるようになっているが、入力が`password`と`password_confirmation`で、保存されるのが`password_digest`という部分を修正する必要がある。

確認のためそのままでテストを走らせるとcreateの部分でfailする

```
$ bundle exec rake
# Running tests:

.F.......

Finished tests in 0.277830s, 32.3939 tests/s, 46.7912 assertions/s.

  1) Failure:
  UsersControllerTest#test_should_create_user [/path_to_app/app_name/test/controllers/users_controller_test.rb:20]:
  "User.count" didn't change by 1.
  Expected: 3
    Actual: 2
```

test/controllers/users_controller_test.rbのなかで、リクエスト時に渡すパラメータをpasswordとpassword_confirmationに変更

```
test "should create user" do
  assert_difference('User.count') do
    # post :create, user: { email: @user.email, password_digest: @user.password_digest }
    post :create, user: { email: @user.email, password: @user.password_digest, password_confirmation: @user.password_digest }
  end

  assert_redirected_to user_path(assigns(:user))
end
```

app/controllers/users_controller.rbの、Strong Parametersのホワイトリストもpasswordとpassword_confirmationに変更

```
# Never trust parameters from the scary internet, only allow the white list through.
def user_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end
```

これでテストがパスする。

```
$ bundle exec rake
# Running tests:

.........

Finished tests in 0.242502s, 37.1131 tests/s, 61.8552 assertions/s.
```


## View

`<%= render 'form' %>`のままだと、password_digestを入力するフォームになってしまうので修正する。

app/views/users/new.html.erbとapp/views/users/edit.html.erbの`<%= render 'form' %>`を次のように変更

```
<div class="form">
  <%= form_for @user do |f| %>
  <div class="username">
    <%= f.label :email %>
    <%= f.text_field :email %>
  </div>
  <div class="password">
    <%= f.label :password %>
    <%= f.password_field :password %>
  </div>
  <div class="password_confirmation">
    <%= f.label :password_confirmation %>
    <%= f.password_field :password_confirmation %>
  </div>
  <div class="submit">
    <%= f.submit %>
  </div>
  <% end %>
</div>
```

これで`http://localhost:3000/users`からUserモデルをCRUDできるようになる。
