module RequestAction
  extend ActiveSupport::Concern

  included do
    before_action :visible_request, only: %i(show update edit)
  end

  def show; end

  def update; end

  def edit; end

  private

  def visible_request
    @request = if current_user.accountant?
                 Request.find_by id: params[:id]
               elsif current_user.manager?
                 visible_request_for_manager
               else
                 visible_request_for_user
               end

    return if @request.present?

    flash[:error] = t ".request_not_found"
    redirect_to root_url
  end

  def visible_request_for_manager
    request = Request.find_by id: params[:id]
    request.user.section_id == current_user.section_id ? request : nil
  end

  def visible_request_for_user
    request = Request.find_by id: params[:id]
    user_requests = Request.own_request current_user.id
    user_requests.include?(request) ? request : nil
  end
end
