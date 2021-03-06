#
# 如果你的好友最近开始玩某个游戏（或者停止玩某个游戏）
#
class GameCharacterObserver < ActiveRecord::Observer

  def before_create character
    unless character.user.has_game? character.game
      # increment counter
      character.user.raw_increment :games_count
    end
  end
	
  def after_create character
    # increment counter
    character.game.raw_increment :characters_count
    character.user.raw_increment :characters_count

    # issue feeds if necessary
		character.deliver_feeds :data => {:type => 0}
	end

  def before_update character
    # if it is wow or wow tw characters, verifying need to be operated again
    if character.name_changed?
      g1 = Game.find_by_name("魔兽世界")
      g2 = Game.find_by_name("魔兽世界（台服）")
      if g1 and g2 and (character.game_id == g1.id or character.game_id == g2.id) and !character.data.nil?
        character.data = nil
      end
    end  
  end

  def after_update character
    # issue feeds
    if character.playing and !character.playing_was
      character.deliver_feeds :data => {:type => 1}
    elsif !character.playing and character.playing_was
      character.deliver_feeds :data => {:type => 2}
    end
  end

  def after_destroy character
    # increment counter
    character.game.raw_decrement :characters_count
    character.user.raw_decrement :characters_count

    unless character.user.has_game? character.game
      # decrement game counter if necessary
		  character.user.raw_decrement :games_count
    end
  end

end
