class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  before_action :check_token,
                only: %i[index current revoke enable disable]


  def signin
    
    user = User.enabled.find_by(login: user_params[:login])

    if user.present? && user.valid_password?(user_params[:password])
      render(json: { token: user.generate_token! }, status: 200)
    else
      error = user.blank? ? 'Usuario inexistente' : 'Password incorrecta'
      render(json: format_error(request.path, error), status: 401)
    end
  end

  def signout
    if current_user.remove_token(header_token)
      render(status: 200)
    else
      render(
        json: format_error(request.path, current_user.errors.full_messages),
        status: 401,
      )
    end
  end

  def password
    if current_user.valid_password?(params['currentPassword'])
      if current_user.update(password: params['newPassword'])
        render(status: 200)
      else
        render(
          json: format_error(request.path, current_user.errors.full_messages),
          status: 401,
        )
      end
    else
      render(
        json: format_error(request.path, 'El currentPassword es cualquiera'),
        status: 401,
      )
    end
  end

  def index
    render(json: User.all.map(&:json), status: 200)
  end

  def enabled
    selected_user.update(enable: true)
    render(status: 200)
  end

  def disable
    selected_user.update(enable: false)
    render(status: 200)
  end

  def create
    user = User.new(user_params)

    if user.save
      render(json: { token: user.generate_token! }, status: 200)
    else
      render(
        json: format_error(request.path, user.errors.full_messages),
        status: 401,
      )
    end
  end

  def current
    json = current_user.json
    json.delete(:enabled)

    render(json: json, status: 200)
  end

  private

  def user_params
    params.require(:user).permit(:name, :login, :password)
  end
end
