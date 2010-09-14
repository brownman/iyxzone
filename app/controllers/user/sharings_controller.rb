class User::SharingsController < UserBaseController

  def new
    if params[:url] =~ MiniLink::UrlReg
      @link = MiniLink.find_by_proxy_url params[:url]
    else
      @link = MiniLink.find_by_url params[:url]
    end

    @title = params[:title]

    if @link.nil?
      @link = MiniLink.new :url => params[:url]
      if @link.save
        render :action => 'new'
      else
        render :text => "发生错误"
      end
    else
      render :action => 'new'
    end
  end

protected

  def setup
  end

end
