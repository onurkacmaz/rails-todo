# frozen_string_literal: true

class AnalyzeReviewJob < ApplicationJob
  include Sneakers::Worker
  queue_as 'reviews'

  def work(msg)
    data = ActiveSupport::JSON.decode(msg)
    Sneakers.logger.info "Analyzing review #{data['review_id']}"
    ack!
  rescue StandardError
    reject!
  end
end
