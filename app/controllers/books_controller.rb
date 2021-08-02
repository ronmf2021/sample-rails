class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :format_publish_date_param, only: %i[ create update ]

  def index
    @books = Book.paginate(page: params[:page], per_page: PER_PAGE).order('sort asc')
    @books = @books.find_by_keyword(search_params[:keyword]) unless (search_params[:keyword].nil? || search_params[:keyword].empty?)
    @books = @books.find_by_category(search_params[:category]) if search_params[:category].to_i > 0
    @books = @books.find_by_author(search_params[:author]) if search_params[:author].to_i > 0
    @books = @books.find_by_publish_date(search_params[:publish_date]) unless search_params[:publish_date].to_s.empty?
    @books
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    
    author_params[:author_ids].each do |k, v|
      @book.authors << Author.find(k) unless k.empty?
    end

    respond_to do |format|
      if @book.save
        format.html { redirect_to books_path, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @book.authors = []
    
    author_params[:author_ids].each do |k, v|
      @book.authors << Author.find(k) unless k.empty?
    end
    
    @book.image.purge if delete_params[:delete_image].to_i == 1
    
    respond_to do |format|
      if @book.update(book_params)
        @book
        format.html { redirect_to books_path, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    redirect_to books_path(search_params)
  end


  private
    def set_book
      @book = Book.find(params[:id])
    end

    def format_publish_date_param
      return if params[:book][:publish_date] == ''
      params[:book][:publish_date] = Date.strptime(params[:book][:publish_date], "%m/%d/%Y").to_datetime
    end

    def book_params
      params.require(:book).permit(:title, :sort, :category_id, :image, :publish_date)
    end

    def author_params
      params.require(:book).permit(:author_ids => [])
    end

    def search_params
      params.permit(:keyword, :category, :author, :publish_date)
    end

    def delete_params
      params.require(:book).permit(:delete_image)
    end

end
