class Multi
  class Result
    attr_reader :changes, :reason, :last

    def initialize
      @changes = {}
      @reason = nil
      @last = nil
    end

    def [](step)
      changes[step]
    end

    def []=(step, value)
      changes[step] = value
    end

    def fail(step, reason)
      @reason = reason
      @last = step
    end

    def failure?
      !success?
    end

    def success?
      reason.nil?
    end
  end
end
