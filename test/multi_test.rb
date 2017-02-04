require 'minitest/autorun'
require 'multi'

require 'active_record'

def runner(&block)
  block.call
end

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

  it "can be run as a block" do
    multi = Multi.new
      .run(:op_1) do
        :foo
      end
      .run(:op_2) do
        :bar
      end

    result = runner(&multi)
    assert result.success?
    refute result.failed?
    assert_equal :foo, result[:op_1]
    assert_equal :bar, result[:op_2]
  end

  it "can can fail when run as a block" do
    multi = Multi.new
      .run(:op_1) do
        :foo
      end
      .run(:op_fail) do
        throw :fail, :error
      end
      .run(:op_2) do
        :bar
      end

    result = runner(&multi)
    refute result.success?
    assert result.failed?
    assert_equal :foo, result[:op_1]
    assert_equal :op_fail, result.failed_operation
    assert_equal :error, result.failed_value
    assert_nil result[:op_2]
  end

  it "raises on failure" do
    multi = Multi.new(:active_record)
      .run(:op_1) do
        :foo
      end
      .run(:op_fail) do
        throw :fail, :error
      end
      .run(:op_2) do
        :bar
      end

    assert_raises ActiveRecord::Rollback do
      ActiveRecord::Base.transaction(&multi)
    end
  end
end
