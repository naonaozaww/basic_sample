class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_action :require_login
  add_flash_types :success, :info, :warning, :danger

  private

  def not_authenticated
    redirect_to login_path, warning: t('defaults.require_login')
  end
  
  def render_404
    render file: Rails.root.join("public/404.html"), status: 404, layout: false, content_type: "text/html"
  end
end
