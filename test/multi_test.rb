require 'minitest/autorun'
require 'multi'

describe "Multi" do
  it "runs a run block" do
    result = Multi.new
      .run(:ok_step) do
        :foo
      end
      .done

    assert result.success?
    refute result.failure?
    assert_equal :foo, result[:ok_step]
  end

  it "runs a run block with a failure" do
    result = Multi.new
      .run(:ok_step) do
        :foo
      end
      .run(:fail_step) do
        throw :fail, :error
      end
      .done

    refute result.success?
    assert result.failure?
    assert_equal :error, result.reason
    assert_equal :fail_step, result.last
    assert_equal :foo, result[:ok_step]
    assert_equal({ok_step: :foo}, result.changes)
  end
end
