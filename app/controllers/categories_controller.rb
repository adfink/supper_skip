class CategoriesController < ApplicationController
  layout "special_layout"

  def show
    @category = Category.find(params[:id])
  end
end
