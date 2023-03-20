RSpec.describe HiveSchema::Column do
  it "can be initialized" do
    column = HiveSchema::Column.new("id", :bigint, "id")
    expect(column.name).to eq("id")
    expect(column.type).to eq(:bigint)
    expect(column.comment).to eq("id")
  end

  it "can be converted to string" do
    column = HiveSchema::Column.new("id", :bigint, "id")
    expect(column.to_s).to eq("`id` bigint COMMENT 'id'")
  end
end
