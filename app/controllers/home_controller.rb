# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: { message: 'rocket api server' }
  end
end
