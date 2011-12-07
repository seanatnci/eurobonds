class EurobondController < ApplicationController
  def index
    require 'bond10y.rb'
    @eurobonds = EuroBond.getbonds
  end

end
