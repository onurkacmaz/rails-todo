# frozen_string_literal: true

Rails.application.config.session_store :cookie_store, key: '_my_app_session', httponly: true,
                                                      expire_after: 1.day
