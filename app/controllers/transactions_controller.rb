class TransactionsController < ApplicationController
  before_action :logged_in?


  def index
     @transactions = Transaction.all
    render json: @transactions
  end

  def new
  end

  def create

    @transaction = Transaction.new(trans_params)
    # @transaction.update(borrower_id: current_user.id)
    @transaction.borrower_id = current_user.id
    if @transaction.save
      # @transaction.lender.update(balance: @transaction.lender.balance - @transaction.amount)
      # @transaction.borrower.update(balance: @transaction.borrower.balance + @transaction.amount)

      redirect_to user_path(current_user), flash[:message] => "Well it seems like she isn't eating for a few weeks"
    else
      # raise
      flash[:message] = @transaction.errors.full_messages[0]
      redirect_to user_friendship_path(current_user.id, params[:transaction][:lender_id])
    end
  end


  def edit
  end

  def update
  end

  def destroy
  end

  def show

  end

  private

    def trans_params
      params.require(:transaction).permit(:amount, :lender_id, :lending)
    end
end
