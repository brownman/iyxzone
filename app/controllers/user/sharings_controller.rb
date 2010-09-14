class User::SharingsController < UserBaseController

  def new
    @link = MiniLink.new :url => params[:url]
    @title = params[:title]

    if @link.save
      render :action => 'new'      
    else
      render :text => "发生错误"
    end
  end

protected

  def setup
  end

end
