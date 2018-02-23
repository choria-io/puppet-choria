require "spec_helper"

describe("choria::in_groups_of") do
  it {
    seen = []
    is_expected.to run.with_params([1, 2, 3, 4, 5, 6, 7], 2).with_lambda {|items|
      seen << items
    }

    expect(seen).to eq([[1, 2], [3, 4], [5, 6], [7]])
  }
end
