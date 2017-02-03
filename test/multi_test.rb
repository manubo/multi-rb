require 'minitest/autorun'
require 'multi'

describe "Multi" do
  it "runs a run block" do
    result = Multi.new
      .run(:ok_step) do
        :foo
      end
      .commit

    assert result.success?
    refute result.failed?
    assert_equal :foo, result[:ok_step]
  end

  it "runs until an operation fails and stops" do
    result = Multi.new
      .run(:ok_step) do
        :foo
      end
      .run(:fail_step) do
        throw :fail, :error
      end
      .run(:never) do
        :ok
      end
      .commit

    refute result.success?
    assert result.failed?
    assert_equal :fail_step, result.failed_operation
    assert_equal :error, result.failed_value
    assert_equal :foo, result[:ok_step]
    assert_equal({ok_step: :foo}, result.changes)
  end
end
