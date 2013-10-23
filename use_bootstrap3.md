# Use Bootstrap3 with Rails4

## Setup

* Download Bootstrap v3.0.0 from http://getbootstrap.com/

* unzip, then copy to Rails project

```
unzip /path_to_downloads/bootstrap-3.0.0.zip
cp /path_to_downloads/bootstrap-3.0.0/dist/css/bootstrap.css /path_to_rails_project/vendor/assets/stylesheets/
cp /path_to_downloads/bootstrap-3.0.0/dist/js/bootstrap.js /path_to_rails_project/vendor/assets/javascripts/
```

* Set app/assets to load bootstrap in vendor/assets

app/assets/stylesheets/application.css

```
  * compiled file, but it's generally better to create a new file per style scope.
  *
  *= require_self
+ *= require bootstrap.css
  *= require_tree .
  */
```

app/assets/javascripts/application.js

```
 //= require jquery
 //= require jquery_ujs
 //= require turbolinks
+//= require bootstrap.js
 //= require_tree .
```


## Example

* For example, create welcome view

```
$ bundle exec rails generate controller welcome index
```

* Edit app/views/welcome/index.html.erb

```
<div class="container">
    <h1>Welcome</h1>
</div>
```

* Launch development server (`$ bundle exec rails s`) and access `http://localhost:3000/`

* You will get webpage with bootstrap3

```
<!DOCTYPE html>
<html>
<head>
<title>Market</title>
<link data-turbolinks-track="true" href="/assets/application.css?body=1" media="all" rel="stylesheet" />
<link data-turbolinks-track="true" href="/assets/bootstrap.css?body=1" media="all" rel="stylesheet" />
<link data-turbolinks-track="true" href="/assets/testing_service.css?body=1" media="all" rel="stylesheet" />
<link data-turbolinks-track="true" href="/assets/welcome.css?body=1" media="all" rel="stylesheet" />
<script data-turbolinks-track="true" src="/assets/jquery.js?body=1"></script>
<script data-turbolinks-track="true" src="/assets/jquery_ujs.js?body=1"></script>
<script data-turbolinks-track="true" src="/assets/turbolinks.js?body=1"></script>
<script data-turbolinks-track="true" src="/assets/bootstrap.js?body=1"></script>
<script data-turbolinks-track="true" src="/assets/testing_service.js?body=1"></script>
<script data-turbolinks-track="true" src="/assets/welcome.js?body=1"></script>
<script data-turbolinks-track="true" src="/assets/application.js?body=1"></script>
<meta content="authenticity_token" name="csrf-param" />
<meta content="mDvoOaYEryyklYWr1g+mH3Qndw3BfEdbdkUgjJODQYE=" name="csrf-token" />
</head>
<body>

<div class="container">

<h1>Welcome</h1>

</div><!-- /.container -->


</body>
</html>
```