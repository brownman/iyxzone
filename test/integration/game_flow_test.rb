require 'test_helper'

class GameFlowTest < ActionController::IntegrationTest

	def setup
    # create a user with game character
    @user = UserFactory.create

    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game

		ga = GameArea.create(:name => 'huadong1', :game_id => @game.id)
		ga.save

		gs = GameServer.create(:name => 'server1', :area_id => ga.id, :game_id => @game.id)
		gs.save

		# create a idol
    @idol = UserFactory.create_idol
    @idol_character = GameCharacterFactory.create @character.game_info.merge({:user_id => @idol.id})
    FanFactory.create @user, @idol
    @user.reload and @idol.reload

    # create friends
    @diff_friend = UserFactory.create
    FriendFactory.create @user, @diff_friend
    @diff_friend_character = GameCharacterFactory.create :user_id => @diff_friend.id
		@game2 = @diff_friend_character.game

    @same_game_friend = UserFactory.create
    FriendFactory.create @user, @same_game_friend
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => ga.id, :server_id => gs.id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_friend.id

    @comrade_friend = UserFactory.create
    FriendFactory.create @user, @comrade_friend
		@comrade_friend_character = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @comrade_friend.id

    # create strangers
    @diff_stranger = UserFactory.create
    @stranger_character = GameCharacterFactory.create :user_id => @diff_stranger.id
		@game3 = @stranger_character.game

    @same_game_stranger = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => ga.id, :server_id => gs.id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_stranger.id

    @comrade_stranger = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @comrade_stranger.id
		
		# a beta game
    @game4 = GameFactory.create :sale_date => Date.today + 1.day
		@game5 = GameFactory.create :sale_date => Date.today + 2.day

		# game attention
		GameAttention.create(:user_id => @user.id, :game_id => @game2.id)
		GameAttention.create(:user_id => @diff_friend.id, :game_id => @game.id)
		GameAttention.create(:user_id => @same_game_friend.id, :game_id => @game2.id)

    # login
    @user_sess = login @user
    @diff_friend_sess = login @diff_friend
    @same_game_friend_sess = login @same_game_friend
		@comrade_friend_sess = login @comrade_friend
    @diff_stranger_sess = login @diff_stranger
    @same_game_stranger_sess = login @same_game_stranger
		@comrade_stranger_sess = login @comrade_stranger
		@idol_sess = login @idol
  
	end
=begin
	test "GET index" do
		# invalid uid
    @user_sess.get "/games", {:uid => 'invalid'}
    @user_sess.assert_not_found

		# self
		@user_sess.get "/games", {:uid => @user.id}
    @user_sess.assert_template 'user/games/index'
    assert_equal @user_sess.assigns(:games), [@game]
		
		# friend
		@user_sess.get "/games", {:uid => @diff_friend.id}
    @user_sess.assert_template 'user/games/index'
    assert_equal @user_sess.assigns(:games), [@game2]

		# stranger
		@user_sess.get "/games", {:uid => @diff_stranger.id}
    @user_sess.assert_redirected_to new_friend_url(:uid => @diff_stranger.id)

		# idol
		@user_sess.get "/games", {:uid => @idol.id}
    @user_sess.assert_template 'user/games/index'

		# fan
		@idol_sess.get "/games", {:uid => @user.id}
    @idol_sess.assert_template 'user/games/index'
	end
=end
  #
  # XIEXIN
  # TODO
  # create some blogs/events/guilds/albums, and construct some feeds
  #
	test "GET show" do
		# invalid uid
    @user_sess.get "/games/invalid"
    @user_sess.assert_template "errors/404"
		
		# user play this game
		@user_sess.get "/games/#{@game.id}"
		@user_sess.assert_template "user/games/show"
		assert_equal @user_sess.assigns(:game), @game
		assert_not_nil @user_sess.assigns(:comrades)

		# user not play this game
		@diff_friend_sess.get "/games/#{@game.id}"
		@diff_friend_sess.assert_template "user/games/show"
		assert_nil @diff_friend_sess.assigns(:comrades)

		# blogs
    @blog1 = BlogFactory.create :poster_id => @comrade_stranger.id, :game_id => @game.id
		sleep 1
    @blog2 = BlogFactory.create :poster_id => @comrade_friend.id, :game_id => @game.id
		sleep 1
    @blog3 = BlogFactory.create :poster_id => @idol.id, :game_id => @game.id
		@user_sess.get "/games/#{@game.id}"
    assert_equal @user_sess.assigns(:blogs), [@blog3, @blog2, @blog1]

    # video feed
    @video = VideoFactory.create :poster_id => @comrade_friend.id, :game_id => @game.id
    assert @game.reload.recv_feed?(@video)

    @video1 = VideoFactory.create :poster_id => @idol.id, :game_id => @game.id
    assert @game.reload.recv_feed?(@video1)

		# personal album
    @album = PersonalAlbumFactory.create :owner_id => @diff_friend.id, :game_id => @game2.id
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @album.record_upload @diff_friend, [@photo]
 
    @album1 = PersonalAlbumFactory.create :owner_id => @comrade_friend.id, :game_id => @game.id
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @album1.record_upload @comrade_friend, [@photo1]
 
    @album2 = PersonalAlbumFactory.create :owner_id => @comrade_stranger.id, :game_id => @game.id
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @album2.record_upload @comrade_stranger, [@photo2]
 
    @album3 = PersonalAlbumFactory.create :owner_id => @idol.id, :game_id => @game.id
    @photo3 = PhotoFactory.create :album_id => @album3.id, :type => 'PersonalPhoto'
    @album3.record_upload @idol, [@photo3]

		@user_sess.get "/games/#{@game.id}"
		@game.reload.albums.each{|a| puts a.title}
    assert_equal @user_sess.assigns(:albums), [@album3, @album2, @album1]

		# poll feed
    @poll = Poll.create :poster_id => @comrade_friend.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    assert @game.reload.recv_feed?(@poll)

    @poll1 = Poll.create :poster_id => @idol.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    assert @game.reload.recv_feed?(@poll1)

		# vote feed
    @vote = @poll.votes.create :answer_ids => [@poll.answers.first.id], :voter_id => @user.id
    assert @game.reload.recv_feed?(@vote)

    @vote1 = @poll.votes.create :answer_ids => [@poll.answers.first.id], :voter_id => @idol.id
    assert @game.reload.recv_feed?(@vote1)

		# event feed
    @event = EventFactory.create :character_id => @comrade_friend_character.id
    assert @game.reload.recv_feed?(@event)

    @request = @event.requests.create :participant_id => @user.id, :character_id => @character.id
    @request.accept_request
    assert @game.reload.recv_feed?(@request)
		
    @event.confirmed_participations.create :participant_id => @idol.id, :character_id => @idol_character.id

		sleep 1
    @event1 = EventFactory.create :character_id => @idol_character.id
    assert @game.reload.recv_feed?(@event1)
 
    @event2 = EventFactory.create :character_id => @diff_friend_character.id
    assert !@game.reload.recv_feed?(@event2)
 
		@user_sess.get "/games/#{@game.id}"
    assert_equal @user_sess.assigns(:events), [@event, @event1]

		# guild feed
    @guild = GuildFactory.create :character_id => @idol_character.id
    assert @game.reload.recv_feed?(@guild)
    @request = @guild.requests.create :user_id => @user.id, :character_id => @character.id
    @request.accept_request
    assert @game.reload.recv_feed?(@request)
		
    @guild1 = GuildFactory.create :character_id => @comrade_friend_character.id
    assert @game.reload.recv_feed?(@guild1)

		@user_sess.get "/games/#{@game.id}"
    assert_equal @user_sess.assigns(:guilds), [@guild, @guild1]
	end
=begin
	test "GET hot" do
		@user_sess.get "/games/hot"
		@user_sess.assert_template "user/games/hot"
		assert_equal @user_sess.assigns(:games), [@game2, @game]
	end

	test "GET sexy" do
		@user_sess.get "/games/sexy"
		@user_sess.assert_template "user/games/sexy"
		assert_equal @user_sess.assigns(:games), [@game, @game2, @game3, @game4, @game5]
	end

	test "GET interested" do
		# invalid uid
    @user_sess.get "/games/interested", {:uid => 'invalid'}
    @user_sess.assert_not_found

		@user_sess.get "/games/interested", {:uid => @user.id}
		@user_sess.assert_template "user/games/interested"
		assert_equal @user_sess.assigns(:games), [@game2]

		# friend
		@user_sess.get "/games/interested", {:uid => @diff_friend.id}
    @user_sess.assert_template 'user/games/interested'
    assert_equal @user_sess.assigns(:games), [@game]

		# stranger
		@user_sess.get "/games/interested", {:uid => @diff_stranger.id}
    @user_sess.assert_redirected_to new_friend_url(:uid => @diff_stranger.id)

		# idol
		@user_sess.get "/games/interested", {:uid => @idol.id}
    @user_sess.assert_template 'user/games/interested'

		# fan
		@idol_sess.get "/games/interested", {:uid => @user.id}
    @idol_sess.assert_template 'user/games/interested'
	end

	test "GET beta" do
		@user_sess.get "/games/beta"
		@user_sess.assert_template "user/games/beta"
		assert_equal @user_sess.assigns(:games), [@game4, @game5]
	end

  test "GET friends" do
		@user_sess.get "/games/friends"
		@user_sess.assert_template "user/games/friends"
		assert_equal @user_sess.assigns(:games), [@game,@game2]
	end
=end
end
