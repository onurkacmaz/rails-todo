# frozen_string_literal: true

require 'sneakers'

Sneakers.configure  amqp: ENV['RABBITMQ_URL'],
                    vhost: '/',
                    exchange: 'sneakers',
                    exchange_type: :topic
