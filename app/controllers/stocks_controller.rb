class StocksController < ApplicationController
  def search
    @stock = Stock.new
    @stock.last_price = Stock.new_lookup(params[:stock])
  end
end
