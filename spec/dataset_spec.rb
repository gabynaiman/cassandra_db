require 'minitest_helper'

describe CassandraDB::Dataset do

  let(:db) { CassandraDB.connect }

  let(:dataset) { db[:countries] }

  let(:argentina) { {'id' => 1, 'code' => 'AR', 'name' => 'Argentina'} }

  let(:brasil) { {'id' => 2, 'code' => 'BR', 'name' => 'Brasil'} }

  let(:uruguay) { {'id' => 3, 'code' => 'UY', 'name' => 'Uruguay'} }

  before do
    db.create_keyspace :test_keyspace
    db.use_keyspace :test_keyspace

    db.execute %Q{
      CREATE TABLE countries (
        id bigint PRIMARY KEY,
        code text,
        name text
      );
    }
  end

  after do
    db.drop_keyspace :test_keyspace
  end

  it 'Insert' do
    assert_empty dataset.all

    dataset.insert argentina
    dataset.insert brasil

    assert_equal_contents [argentina, brasil], dataset.all
  end

  describe 'Where' do

    before do
      dataset.insert argentina
      dataset.insert brasil
      dataset.insert uruguay
    end

    it 'Filter by single value' do
      countries = dataset.where(id: argentina['id']).all

      assert_equal [argentina], countries
    end

    it 'Filter by multiple values' do
      countries = dataset.where(id: [argentina['id'], uruguay['id']]).all

      assert_equal_contents [argentina, uruguay], countries
    end

  end

  it 'Update' do
    dataset.insert argentina
    dataset.insert uruguay

    dataset.where(id: argentina['id']).update(name: 'Republica Argentina')

    updated_argentina = argentina.merge('name' => 'Republica Argentina')

    assert_equal_contents [updated_argentina, uruguay], dataset.all
  end

  it 'Delete' do
    dataset.insert brasil
    dataset.insert uruguay

    assert_equal 2, dataset.count

    dataset.where(id: uruguay['id']).delete

    assert_equal [brasil], dataset.all
  end

  it 'Enumerable (Map)' do
    dataset.insert argentina
    dataset.insert brasil

    assert_equal_contents ['AR', 'BR'], dataset.map { |r| r['code'] }
  end

  it 'Inspect' do
    assert_equal '#<CassandraDB::Dataset: SELECT * FROM countries {:arguments=>{}}>', dataset.inspect
  end

end