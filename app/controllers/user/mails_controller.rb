class User::MailsController < UserBaseController

  layout 'app'

  before_filter :catch_mail, :only => [:show, :reply, :destroy]

  before_filter :catch_mails, :only => [:read_multiple, :unread_multiple, :destroy_multiple]

  before_filter :catch_recipients, :only => [:new, :create]

  def index
    if params[:type].to_i == 0
      @mails = current_user.sent_mails.paginate :page => params[:page], :per_page => 10
      render :action => 'sent_index'
    else
      @mails = current_user.recv_mails.paginate :page => params[:page], :per_page => 10
      render :action => 'recv_index'
    end
  end

  def show
    Mail.update_all("read_by_recipient = 1", {:parent_id => @root_mail.id, :recipient_id => current_user.id})
  end

  def new
    @infos = @recipients.map{|r| {:id => r.id, :profileID => r.profile.id, :login => r.login}}.to_json    
  end

  def create
    @notify = []
    Mail.transaction do
      @recipients.each do |recipient|
        mail = Mail.new(params[:mail].merge({:sender_id => current_user.id, :recipient_id => recipient.id}))
        if mail.save
          mail.update_attribute('parent_id', mail.id)
          @notify << recipient
        end
      end
    end
    render :juggernaut => {:type => :send_to_clients, :client_ids => @notify.map(&:id)} do |page|
      page << "Iyxzone.newMailNotice();"
    end
    redirect_to mails_url(:type => 0)
  end

  def reply
    @new_mail = Mail.new(params[:mail])
    @new_mail.title = "回复: #{@root_mail.title}"
    @new_mail.sender_id = current_user.id
    @new_mail.recipient_id = (@root_mail.sender == current_user)? @root_mail.recipient_id : @root_mail.sender_id
    @new_mail.parent_id = @root_mail.id
    if @new_mail.save
      render :juggernaut => {:type => :send_to_client, :client_id => @new_mail.recipient_id} do |page|
        page << "Iyxzone.newMailNotice();"
      end
      render :update do |page|
        page.insert_html :bottom, 'mails', :partial => 'mail', :object => @new_mail
        page << "$('mail_content').value = '';"
      end
    else
      render_js_error
    end
  end

  def destroy
    if params[:type].to_i == 0
      Mail.update_all("delete_by_sender = 1", {:parent_id => @root_mail.id, :sender_id => current_user.id})
    else
      Mail.update_all("delete_by_recipient = 1", {:parent_id => @root_mail.id, :recipient_id => current_user.id})
    end
    flash[:notice] = "删除成功"
    render :update do |page|
      page.redirect_to mails_url(:type => params[:type])
    end
  end

  def read_multiple
    @mails.each do |mail|
      if mail.parent_id == 0
        mail.update_attribute('read_by_recipient', 1)
      else 
        Mail.update_all("read_by_recipient = 1", {:parent_id => mail.parent_id, :recipient_id => current_user.id})
      end
    end
    render :nothing => true
  end

  def unread_multiple
    @mails.each do |mail|
      if mail.parent_id == 0
        mail.update_attribute('read_by_recipient', 0)
      else 
        Mail.update_all("read_by_recipient = 0", {:parent_id => mail.parent_id, :recipient_id => current_user.id})
      end
    end
    render :nothing => true
  end

  def destroy_multiple
    if params[:type].to_i == 0
      @mails.each { |mail| Mail.update_all("delete_by_sender = 1", {:parent_id => mail.parent_id, :sender_id => current_user.id}) }
    else
      @mails.each { |mail| Mail.update_all("delete_by_recipient = 1", {:parent_id => mail.parent_id, :recipient_id => current_user.id}) }
    end
    render :update do |page|
      flash[:notice] = "删除成功"
      page.redirect_to mails_url(:type => params[:type])
    end     
  end

protected

  def catch_mail
    if params[:type].to_i == 0 # sent
      @mail = current_user.out_mails.find(params[:id])
    else
      @mail = current_user.in_mails.find(params[:id])
    end
    @root_mail = @mail.parent || @mail   
  end

  def catch_mails
    if params[:type].to_i == 0
      @mails = current_user.out_mails.find(params[:ids])
    else
      @mails = current_user.in_mails.find(params[:ids])
    end
  end

  def catch_recipients
    @recipients = params[:recipient_ids].blank? ? [] : User.find(params[:recipient_ids])
  end

end
