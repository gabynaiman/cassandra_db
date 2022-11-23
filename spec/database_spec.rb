require 'minitest_helper'

describe CassandraDB::Database do

  let(:db) { CassandraDB.connect }

  it 'Keyspace' do
    assert_equal :system, db.keyspace
  end

  it 'Keyspaces' do
    assert_equal [:system, :system_traces], db.keyspaces
  end

  it 'Use keyspace' do
    db.use_keyspace :system_traces
    assert_equal :system_traces, db.keyspace
  end

  it 'Tables' do
    db = CassandraDB.connect keyspace: :system_traces
    assert_equal [:events, :sessions], db.tables
  end

  it 'Create and drop keyspace' do
    db.create_keyspace :test_keyspace

    assert_includes db.keyspaces, :test_keyspace

    db.drop_keyspace :test_keyspace

    refute_includes db.keyspaces, :test_keyspace
  end

  it 'Inspect' do
    assert_equal '#<CassandraDB::Database: options={} keyspace=:system>', db.inspect
  end

end