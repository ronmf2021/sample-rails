class StaticPagesController < ApplicationController

  def home
    @books = Book.paginate(page: params[:page], per_page: PER_PAGE).order('sort asc')
  end

end
