class UsersController < ApplicationController
  before_action :require_login
  before_action :set_user
  
  def show
    
  end

  def edit
  end

  def update
  end

  private

  def set_user
    @user = current_user
  end
end
