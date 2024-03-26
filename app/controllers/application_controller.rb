# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_user
    return unless session[:user_id].nil?

    redirect_to root_path
  end

  def is_authenticated
    return unless session[:user_id]

    redirect_to tasks_path
  end
end
