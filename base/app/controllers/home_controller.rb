class HomeController < ApplicationController
  def index
    flash.now[:notice] = "Hello, World!"
  end
end
