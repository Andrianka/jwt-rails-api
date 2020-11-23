class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  # REGISTER
  def create
    @user = User.create(user_params)
    render json: { error: 'Invalid username or password' } unless @user.valid?

    token = encode_token({ user_id: @user.id })
    render json: { user: @user, token: token }
  end

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username])

    return render json: { error: 'Invalid username or password' } unless @user&.authenticate(params[:password])

    token = encode_token({ user_id: @user.id })
    render json: { user: @user, token: token }
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.permit(:username, :password, :age)
  end
end
