class StoreController < ApplicationController
  def visit_page_counter
    if session[:counter].nil?
      session[:counter] = 0
    else
      session[:counter] += 1
    end
  end
     
  def index
    @counter = visit_page_counter
    @products = Product.order(:title)
    @counterMessage = "The count is:  #{@counter} " if @counter > 5
  end
end
