class Multi
  class Result
    attr_reader :changes, :failed_value, :failed_operation

    def initialize
      @changes = {}
      @failed_value = nil
      @failed_operation = nil
    end

    def [](operation)
      changes[operation]
    end

    def []=(operation, value)
      changes[operation] = value
    end

    def fail(operation, value)
      @failed_value = value
      @failed_operation = operation
    end

    def failed?
      !success?
    end

    def success?
      failed_operation.nil?
    end
  end
end
