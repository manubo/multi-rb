module Multi::ActiveRecord
  def save(operation, model)
    run(operation) do
      model.save ? model : throw(:fail, model)
    end
  end

  def update(operation, model, params)
    run(operation) do
      model.update(params) ? model : throw(:fail, model)
    end
  end

  def to_proc
    result = commit
    raise ActiveRecord::Rollback if result.failed?
    result
  end
end