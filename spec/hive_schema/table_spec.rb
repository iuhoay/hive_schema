RSpec.describe HiveSchema::Table do
  it "can be initialized" do
    table = HiveSchema::Table.new("db_test", "users")
    expect(table.name).to eq("users")
    expect(table.columns).to eq([])
  end

  it "can add column" do
    table = HiveSchema::Table.new("db_test", "users")
    table.add_column("id", :bigint, "id")
    expect(table.columns.size).to eq(1)
    expect(table.columns.first.name).to eq("id")
    expect(table.columns.first.type).to eq(:bigint)
    expect(table.columns.first.comment).to eq("id")
  end

  it "can be converted to string" do
    table = HiveSchema::Table.new("db_test", "users")
    table.add_column("id", :bigint, "id")
    expect(table.to_s).to eq(<<~SQL)
      CREATE TABLE IF NOT EXISTS `db_test.users` (
        `id` bigint COMMENT 'id'
      )
      COMMENT 'users'
      ROW FORMAT DELIMITED FIELDS
      TERMINATED BY '\\t'
      STORED AS TEXTFILE;
    SQL
  end

  it "can be converted to string with stored_as" do
    table = HiveSchema::Table.new("db_test", "users")
    table.add_column("id", :bigint, "id")
    table.stored_as = "ORC"
    expect(table.to_s).to eq(<<~SQL)
      CREATE TABLE IF NOT EXISTS `db_test.users` (
        `id` bigint COMMENT 'id'
      )
      COMMENT 'users'
      ROW FORMAT DELIMITED FIELDS
      TERMINATED BY '\\t'
      STORED AS ORC;
    SQL
  end

  it "can be converted to string with location" do
    table = HiveSchema::Table.new("db_test", "users")
    table.add_column("id", :bigint, "id")
    table.location = "hdfs://bucket/path/to/table"
    expect(table.to_s).to eq(<<~SQL)
      CREATE TABLE IF NOT EXISTS `db_test.users` (
        `id` bigint COMMENT 'id'
      )
      COMMENT 'users'
      ROW FORMAT DELIMITED FIELDS
      TERMINATED BY '\\t'
      STORED AS TEXTFILE
      LOCATION 'hdfs://bucket/path/to/table';
    SQL
  end

  it "can be converted to string with single partition column" do
    table = HiveSchema::Table.new("db_test", "users")
    table.add_column("id", :bigint, "id")
    table.add_partition_column("ds", :string, "partition comment")
    expect(table.to_s).to eq(<<~SQL)
      CREATE TABLE IF NOT EXISTS `db_test.users` (
        `id` bigint COMMENT 'id'
      )
      COMMENT 'users'
      PARTITIONED BY (`ds` string COMMENT 'partition comment')
      ROW FORMAT DELIMITED FIELDS
      TERMINATED BY '\\t'
      STORED AS TEXTFILE;
    SQL
  end

  it "can be converted to string with multiple partition columns" do
    table = HiveSchema::Table.new("db_test", "users")
    table.add_column("id", :bigint, "id")
    table.add_partition_column("year", :string, "Year")
    table.add_partition_column("month", :string, "Month")
    expect(table.to_s).to eq(<<~SQL)
      CREATE TABLE IF NOT EXISTS `db_test.users` (
        `id` bigint COMMENT 'id'
      )
      COMMENT 'users'
      PARTITIONED BY (`year` string COMMENT 'Year', `month` string COMMENT 'Month')
      ROW FORMAT DELIMITED FIELDS
      TERMINATED BY '\\t'
      STORED AS TEXTFILE;
    SQL
  end
end
