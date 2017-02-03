require 'multi/result'
require 'byebug'

class Multi
  attr_reader :result, :failed_operation, :failed_value

  def initialize
    @result = Multi::Result.new
    @operations = {}
    @failed_operation = nil
    @failed_value = nil
  end

  def run(operation, &block)
    raise 'Block required' unless block_given?
    @operations[operation] = block
    self
  end

  def commit
    @operations.each do |operation, callable|
      success = false
      value = catch(:fail) do
        result[operation] = callable.call(result.changes)
        success = true
      end
      next if success
      result.fail(operation, value)
      break
    end
    result
  end
end
