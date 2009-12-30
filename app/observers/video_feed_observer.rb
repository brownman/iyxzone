class VideoFeedObserver < ActiveRecord::Observer

	observe :video

	def after_create(video)
		return unless video.poster.application_setting.emit_video_feed
		return if video.privilege == 4
		recipients = [video.poster.profile]
		recipients.concat video.poster.guilds
		recipients.concat video.poster.friends.find_all{|f| f.application_setting.recv_video_feed}
		video.deliver_feeds :recipients => recipients
	end

  def after_update video
    video.destroy_feeds if video.privilege == 4 and video.privilege_was != 4
  end

end
