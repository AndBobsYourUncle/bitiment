every 1.minute do
  runner 'UpdateSentimentJob.perform_later'
end
