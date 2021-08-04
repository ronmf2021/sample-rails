class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :format_publish_date_param, only: %i[ create update ]

  def index
    @books = Book.includes(:authors, :category)
                 .find_by_keyword(search_params[:keyword])
                 .find_by_category(search_params[:category])
                 .find_by_author(search_params[:author])
                 .find_by_publish_date(search_params[:publish_date])
                 .paginate(page: params[:page], per_page: PER_PAGE)
                 .order('sort asc')
  end

  def show
  end

  def new
    @book = Book.new.decorate
  end

  def edit
  end

  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_path(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        @book.image.purge if delete_params[:delete_image].to_i == 1

        format.html { redirect_to book_path(@book), notice: "Book was successfully updated." }
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
      format.html { redirect_to books_path, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    redirect_to books_path(search_params)
  end


  private
    def set_book
      @book = Book.find(params[:id]).decorate
    end

    def format_publish_date_param
      return if params[:book][:publish_date] == ''
      params[:book][:publish_date] = Date.strptime(params[:book][:publish_date], "%m/%d/%Y").to_datetime
    end

    def book_params
      params.require(:book).permit(:title, :sort, :category_id, :image, :publish_date, author_ids: [])
    end

    def search_params
      params.permit(:keyword, :category, :author, :publish_date)
    end

    def delete_params
      params.require(:book).permit(:delete_image)
    end

end
