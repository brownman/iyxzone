class CommentMailer < ActionMailer::Base

  layout 'mail'

  def blog_comment_to_poster comment, user
    setup_email user
    subject			"17Gaming.com(一起游戏网) - #{comment.poster.login}在博客#{comment.commentable.title}发表评论"
		body				:comment => comment, :user => user, :url => "#{SITE_URL}/blogs/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

  def blog_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在博客#{comment.commentable.title}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/blogs/#{comment.commentable_id}?reply_to=#{comment.poster_id}"  
  end

  def blog_comment_to_tagged_user comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在和你相关的博客#{comment.commentable.title}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/blogs/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def video_comment_to_poster comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在视频#{comment.commentable.title}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/videos/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def video_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在视频#{comment.commentable.title}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/videos/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

  def video_comment_to_tagged_user comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在和你相关的视频#{comment.commentable.title}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/videos/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def photo_comment_to_poster comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}对相册#{comment.commentable.album.title}中的照片发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/#{comment.commentable.class.to_s.underscore}s/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def photo_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}对相册#{comment.commentable.album.title}中的照片发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/#{comment.commentable.class.to_s.underscore}s/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end  

  def photo_comment_to_tagged_user comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在你被标记的图片里发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/#{comment.commentable.class.to_s.underscore}s/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

	def album_comment_to_poster comment, user
		setup_email user
		subject			"17Gaming.com(一起游戏网) - #{comment.poster.login}在相册#{comment.commentable.title}发表评论"
		body				:comment => comment, :user => user, :url => "#{SITE_URL}/#{comment.commentable.class.to_s.underscore}s/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def album_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在相册#{comment.commentable.title}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/#{comment.commentable.class.to_s.underscore}s/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

  def status_comment_to_poster comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在你的状态里留言了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/statuses?uid=#{user.id}&reply_to=#{comment.poster_id}&status_id=#{comment.commentable_id}"
	end

  def status_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在状态里回复了你"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/statuses?uid=#{user.id}&reply_to=#{comment.poster_id}&status_id=#{comment.commentable_id}"
  end

  def poll_comment_to_poster comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在投票#{comment.commentable.name}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/polls/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def poll_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在投票#{comment.commentable.name}发表评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/polls/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

	def event_comment_to_poster comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在你的活动#{comment.commentable.title}留言了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/events/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def event_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在活动#{comment.commentable.title}里回复了你"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/events/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

	def guild_comment_to_president comment, user
    setup_email user
		subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在公会#{comment.commentable.name}留言了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/guilds/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def guild_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在公会#{comment.commentable.name}留言了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/guilds/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

	def profile_comment_to_poster comment, user
		setup_email	user
		subject			"17Gaming.com(一起游戏网) - #{comment.poster.login}在你的留言版上留言了"
		body				:comment => comment, :user => user, :url => "#{SITE_URL}/profiles/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
	end

  def profile_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在留言版上给你留言了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/profiles/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

  def game_comment comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在游戏#{comment.commentable.name}的留言版上留言了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/games/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

  def sharing_comment_to_poster comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在你的分享里留言了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/sharings?uid=#{user.id}&reply_to=#{comment.poster_id}&sharing_id=#{comment.commentable_id}"
  end

  def sharing_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在分享里回复你了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/sharings?uid=#{user.id}&reply_to=#{comment.poster_id}&sharing_id=#{comment.commentable_id}"
  end

  def application_comment comment, user 
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在应用#{comment.commentable.name}的留言版上回复了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/applications/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

  def news_comment comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在新闻#{comment.commentable.title}的留言版上回复了"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/news/#{comment.commentable_id}?reply_to=#{comment.poster_id}"
  end

  def mini_blog_comment_to_poster comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}评论了你的微博"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/mini_blogs?uid=#{user.id}&reply_to=#{comment.poster_id}&bid=#{comment.commentable_id}"
  end

  def mini_blog_comment_to_recipient comment, user
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{comment.poster.login}在微博中回复了你的评论"
    body        :comment => comment, :user => user, :url => "#{SITE_URL}/mini_blogs?uid=#{comment.commentable.poster_id}&reply_to=#{comment.poster_id}&bid=#{comment.commentable_id}"  
  end

protected

  def setup_email user
		recipients	user.email	
		from				SITE_MAIL
		sent_on			Time.now
  end

end
