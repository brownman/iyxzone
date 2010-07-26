class User::AttentionsController < UserBaseController

  def create
    @attention = @attentionable.attentions.build :follower_id => current_user.id

    if @attention.save
      render :update do |page|
        page.replace_html "#{@attentionable.class.name.underscore}_attention_#{@attentionable.id}", :partial => 'unfollow', :locals => {:attentionable => @attention.attentionable}
      end    
    else
      render_js_error
    end 
  end

  def destroy
    @attention = @attentionable.attentions.find_by_follower_id(current_user.id)

    if @attention.destroy
      render :update do |page|
        page.replace_html "#{@attentionable.class.name.underscore}_attention_#{@attentionable.id}", :partial => 'follow', :locals => {:attentionable => @attention.attentionable}
      end
    else
      render_js_error
    end
  end

protected

  def setup
    if ['create'].include? params[:action]
      @attentionable = params[:attentionable_type].camelize.constantize.find(params[:attentionable_id])
    elsif ['destroy'].include? params[:action]
      @attentionable = params[:attentionable_type].camelize.constantize.find(params[:attentionable_id]) #Attention.find params[:id]
    end 
  end
  
end