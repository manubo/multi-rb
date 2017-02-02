require 'multi/result'
require 'byebug'

class Multi
  attr_reader :result

  def initialize
    @result = Multi::Result.new
  end

  def run(step, &block)
    rails 'Block required' unless block_given?
    success = false
    reason = catch(:fail) do
      result[step] = yield block
      success = true
    end
    unless success
      result.fail(step, reason)
    end
    self
  end

  def done
    result
  end
end
