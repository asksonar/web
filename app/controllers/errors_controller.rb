class ErrorsController < ApplicationController
  layout 'error'

  def not_found_404
    render status: 404
  end

  def internal_server_error_500
    render status: 500
  end

  def forbidden_403
    render status: 403
  end

  def service_unavailable_503
    render status: 503
  end
end
