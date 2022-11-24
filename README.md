# CassandraDB

[![Gem Version](https://badge.fury.io/rb/cassandra_db.svg)](https://rubygems.org/gems/cassandra_db)
[![CI](https://github.com/gabynaiman/cassandra_db/actions/workflows/ci.yml/badge.svg)](https://github.com/gabynaiman/cassandra_db/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/gabynaiman/cassandra_db/badge.svg?branch=master)](https://coveralls.io/r/gabynaiman/cassandra_db?branch=master)
[![Code Climate](https://codeclimate.com/github/gabynaiman/cassandra_db.svg)](https://codeclimate.com/github/gabynaiman/cassandra_db)

Cassandra DB adapter inspired on Sequel

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cassandra_db'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cassandra_db

## Usage

### Connect
```ruby
db = CassandraDB.connect hosts: ['localhost'], port: 9042, keyspace: 'system'
```

### Metadata
```ruby
db.keyspace # => :system

db.keyspaces # => [:system, :system_traces]

db.tables # => Array of table names in current keyspace
```

### Change keyspace
```ruby
db.use_keyspace 'my_keyspace'
db.keyspace # => :my_keyspace
```

### Create and drop keyspaces
```ruby
replication_opts = {
  class: 'SimpleStrategy',
  replication_factor: 1
}
db.create_keyspace :my_keyspace, replication: replication_opts, durable_writes: true

db.drop_keyspace :my_keyspace
```

### Queries
```ruby
dataset = db[table_name] # => CassandraDB::Dataset
dataset = db[table_name].where(field: 'value') # => CassandraDB::Dataset
```

### Dataset/Enumerable methods
```ruby
dataset.count
dataset.each
dataset.map
dataset.all
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabynaiman/cassandra_db.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

