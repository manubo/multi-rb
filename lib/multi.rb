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
    current_operation = nil
    failed_value = catch(:fail)  do
      failed_operation = @operations.each do |operation, callable|
        current_operation = operation
        result[operation] = callable.call(result.changes)
      end
      nil
    end
    result.maybe_fail(current_operation, failed_value)
  end
end
