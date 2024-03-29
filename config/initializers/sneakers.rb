# frozen_string_literal: true

require 'sneakers'

module Connection
  def self.sneakers
    @sneakers ||= Bunny.new(
      host: ENV['RABBITMQ_HOST'],
      port: ENV['RABBITMQ_PORT'],
      username: ENV['RABBITMQ_USER'],
      password: ENV['RABBITMQ_PASSWORD'],
      vhost: ENV['RABBITMQ_VHOST']
    )
  end
end

Sneakers.configure connection: Connection.sneakers,
                   exchange: ENV['RABBITMQ_EXCHANGE'],
                   exchange_type: :topic,
                   log: $stdout,
                   workers: ENV['SNEAKERS_WORKERS'].to_i,
                   timeout_job_after: 5.minutes,
                   prefetch: ENV['SNEAKERS_PREFETCH'].to_i,
                   threads: ENV['SNEAKERS_THREADS'].to_i,
                   durable: true,
                   ack: true,
                   heartbeat: 5
