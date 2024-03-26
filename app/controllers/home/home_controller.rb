# frozen_string_literal: true

class Home::HomeController < ApplicationController
  layout 'application'
  before_action :is_authenticated

  def index
    render 'home/index'
  end
end
