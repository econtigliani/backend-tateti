class ApplicationController < ActionController::API
  private

  def verify_selected_client
    return if selected_user.present?

    render(
      json: format_error(request.path, 'No existe el cliente'),
      status: 401,
    )
  end

  def check_token
    return if current_user.present?

    render(json: format_error(request.path, 'No se quien sos'), status: 401)
  end

  def format_error(path, message)
    { message: [{ path: path, message: message }] }
  end

  def header_token
    request.headers['Authorization'].split(' ').last
  end

  def current_user
    @current_user ||= User.find_by_token(header_token)
  end



end
