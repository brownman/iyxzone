class User::StatusesController < UserBaseController

  layout 'app'

  before_filter :friend_or_owner_required, :only => [:index]

  def index
    @statuses = @user.statuses.paginate :page => params[:page], :per_page => 5
  end

  def friends
    @statuses = current_user.status_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def create
    @status = current_user.statuses.build((params[:status] || {}).merge({:poster_id => current_user.id}))
    unless @status.save
			render :update do |page|
				page << "error(保存时发生错误)"
			end
		end
  end

  def destroy
    if @status.destroy
      render :update do |page|
        page << "facebox.close();$('status_#{@status.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:id])
      if !params[:status_id].blank? and !params[:status_id].blank?
        @reply_to = User.find(params[:reply_to])
        @status = Status.find(params[:status_id])
        params[:page] = current_user.statuses.index(@status) / 5 + 1
        params.delete :status_id
        params.delete :reply_to
      end
    elsif ["destroy"].include? params[:action]
      @status = current_user.statuses.find(params[:id])
    end
  rescue
    not_found
  end

end
