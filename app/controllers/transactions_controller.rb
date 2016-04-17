class TransactionsController < ApplicationController
  before_action :logged_in?
  def new

  end

  def create
    @transaction = Transaction.create(lender_id: params[:user_id].to_i, borrower_id: current_user.id, amount: params[:amount].to_i)
    @lender = User.find(@transaction.lender_id)
    @borrower = User.find(@transaction.borrower_id)
    @lender.update(balance: @lender.balance - @transaction.amount)
    @borrower.update(balance: @borrower.balance + @transaction.amount)

    redirect_to user_path(@borrower), flash[:notice] => "Well it seems like she isn't eating for a few weeks"

  end

  def edit
  end

  def update
  end

  def destroy
  end
end
