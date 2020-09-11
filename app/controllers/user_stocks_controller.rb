class UserStocksController < ApplicationController
    def create
        stock = Stock.check_db(params[:ticker])
        if stock.blank?
            stock = Stock.new_lookup(params[:ticker])
            stock.save
        end
        @user_stock = UserStock.create(user: current_user, stock: stock)
        flash[:notice] = "Stock #{stock.ticker} has successfully been added to your portfolio"
        redirect_to my_portfolio_path
    end

    def destroy
        stock = Stock.find(params[:id])
        UserStock.where(user: current_user, stock: stock).first.destroy
        flash[:notice] = "#{stock.ticker} has been removed from the portfolio"
        redirect_to my_portfolio_path
    end
end
