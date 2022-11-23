require 'minitest_helper'

describe CassandraDB::Dataset do

  let(:db) { CassandraDB.connect }

  let(:dataset) { db[:schema_keyspaces] }

  it 'Count' do
    assert_equal 2, dataset.count
  end

  it 'Map' do
    assert_equal ['system', 'system_traces'], dataset.map { |r| r['keyspace_name'] }.sort
  end

  it 'Where' do
    assert_equal ['system'], dataset.where(keyspace_name: 'system').map { |r| r['keyspace_name'] }
  end

  it 'Inspect' do
    assert_equal '#<CassandraDB::Dataset: SELECT * FROM schema_keyspaces, {:arguments=>{}}>', dataset.inspect
  end

end