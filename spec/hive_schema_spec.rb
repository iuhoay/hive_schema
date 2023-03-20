# frozen_string_literal: true

RSpec.describe HiveSchema do
  it "has a version number" do
    expect(HiveSchema::VERSION).not_to be nil
  end
end
