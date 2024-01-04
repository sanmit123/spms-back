ActiveInteraction::Runnable.module_eval do
  def result
    if @_interaction_result.class == Hash
      return @_interaction_result.deep_symbolize_keys
    else
      return @_interaction_result
    end
  end
end