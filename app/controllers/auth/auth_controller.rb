# frozen_string_literal: true

class Auth::AuthController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)

    if user
      session[:user_id] = user.id
      session[:user_name] = user.name
      session[:user_email] = user.email
      redirect_to tasks_path
    else
      redirect_to root_path
    end
  end

  def auth_failure
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_email] = nil
    redirect_to root_path
  end

  def login
    redirect_to '/auth/google_oauth2'
  end
end
