class User::Guilds::RequestsController < UserBaseController

  layout 'app'

  def new
    @characters = @guild.requestable_characters_for current_user 
    render :action => 'new', :layout => false
  end

  def create
    request_params = (params[:request] || {}).merge({:user_id => current_user.id})
    @request = @guild.requests.build request_params
    unless @request.save
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def accept
    if @request.update_attributes(:status => Membership::Member)
      render :update do |page|
        page << "$('guild_request_option_#{@request.id}').innerHTML = '已接受';"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def decline
    if @request.destroy
      render :update do |page|
        page << "$('guild_request_#{@request.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['accept', 'decline'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_owner @guild.president
      @request = @guild.requests.find(params[:id])
    end
  end

end

