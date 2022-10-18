class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    comment = BookComment.new(book_comment_params)
    comment.user_id = current_user.id
    comment.book_id = @book.id
    comment.save
    @book_comment = BookComment.new

  end

  def destroy
    BookComment.find(params[:id]).destroy
    @book = Book.find(params[:book_id])
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
