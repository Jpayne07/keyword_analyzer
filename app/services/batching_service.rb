class BatchingService
  def self.call(scope, batch_size: 500, delay: 0.1)
    scope.find_in_batches(batch_size: batch_size) do |batch|
      sleep(delay) if delay.positive?
      yield(batch)
    end
  end
end
