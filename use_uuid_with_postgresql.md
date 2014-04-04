# Use UUID with PostgreSQL on Rails4

## PostgreSQL

Install PostgreSQL.

Edit Gemfile

	- gem 'sqlite3'
	+ gem 'pg'

Install gem
	
	$ bundle install --path vendor/bundle
	
Edit config/database.yml

	development:
	  adapter: postgresql
	  database: myapp
	  username: myname
	  host: localhost

## Database schema

Generate new migration and model

	$ bundle exec rails generate migration enable_uuid_ossp_extension
	$ bundle exec rails generate model reader email
	
Edit db/migrate/***_enable_uuid_ossp_extension.rb
	
	  def change
	  +  enable_extension 'uuid-ossp'
	  end

Edit db/migrate/***_create_readers.rb

	  def change
  	  -  create_table :readers do |t|
	  +  create_table :readers, id: :uuid do |t|

Run

	$ bundle exec rake db:create
	$ bundle exec rake db:migrate

Check database schema

	$ psql myapp

	myapp=# \d readers
                             Table "public.readers"
	   Column   |            Type             |              Modifiers
	------------+-----------------------------+-------------------------------------
	 id         | uuid                        | not null default uuid_generate_v4()
	 email      | character varying(255)      |
	 created_at | timestamp without time zone |
	 updated_at | timestamp without time zone |
	Indexes:
	    "readers_pkey" PRIMARY KEY, btree (id)

Check active-record in Rails

	$ bundle exec rails c
	
	irb> Reader
	=> Reader(id: uuid, email: string, created_at: datetime, updated_at: datetime)

	irb> Reader.create(email:"knmkr@knmkr.com")
	   (0.2ms)  BEGIN
	  SQL (7.4ms)  INSERT INTO "readers" ("created_at", "email", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["created_at", Wed, 06 Nov 2013 05:35:33 UTC +00:00], ["email", "knmkr@knmkr.com"], ["updated_at", Wed, 06 Nov 2013 05:35:33 UTC +00:00]]
	   (0.4ms)  COMMIT
	=> #<Reader id: "8f3cf8e9-4eea-4d70-8a5a-4d4b12b845f2", email: "knmkr@knmkr.com", created_at: "2013-11-06 05:35:33", updated_at: "2013-11-06 05:35:33">


References: 

* [Use UUIDs in Rails 4 with PostgreSQL](//rny.io/rails/postgresql/2013/07/27/use-uuids-in-rails-4-with-postgresql.html)
* [Using UUID as a Primary Key on Postgres and Rails 4](//www.gingerbeard.me/2013/05/28/rails-using-uuid-as-a-primary-key-on-postgres-and-rails-4/)

	
	
	
	
	
