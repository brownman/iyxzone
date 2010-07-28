class LongzhiguBetaServers < ActiveRecord::Migration
  def self.up
game_id = Game.find(:first, :conditions => ["name = ?","龙之谷"]).id
this_area = GameArea.create( :name => '华东电信一区', :game_id => game_id)
this_area.servers.create( :name => '1服-雷神之锤', :game_id => game_id)
this_area.servers.create( :name => '2服-神圣之光', :game_id => game_id)
this_area.servers.create( :name => '3服-战斗咆哮', :game_id => game_id)
this_area.servers.create( :name => '4服-毁灭烈焰', :game_id => game_id)
this_area = GameArea.create( :name => '华东电信二区', :game_id => game_id)
this_area.servers.create( :name => '1服-雷霆万钧', :game_id => game_id)
this_area.servers.create( :name => '2服-神圣风暴', :game_id => game_id)
this_area.servers.create( :name => '3服-枪舞旋风', :game_id => game_id)
this_area.servers.create( :name => '4服-极冰之焰', :game_id => game_id)
this_area = GameArea.create( :name => '华东电信三区', :game_id => game_id)
this_area.servers.create( :name => '1服-星云锁链', :game_id => game_id)
this_area.servers.create( :name => '2服-连锁闪电', :game_id => game_id)
this_area.servers.create( :name => '3服-流星雨', :game_id => game_id)
this_area.servers.create( :name => '4服-暴风雪', :game_id => game_id)
this_area = GameArea.create( :name => '华东电信四区', :game_id => game_id)
this_area.servers.create( :name => '1服-潮汐之力', :game_id => game_id)
this_area.servers.create( :name => '2服-守护之魂', :game_id => game_id)
this_area.servers.create( :name => '3服-光芒之泉', :game_id => game_id)
this_area.servers.create( :name => '4服-天空之怒', :game_id => game_id)
this_area = GameArea.create( :name => '华南电信一区', :game_id => game_id)
this_area.servers.create( :name => '1服-闪电风暴', :game_id => game_id)
this_area.servers.create( :name => '2服-烈焰之怒', :game_id => game_id)
this_area.servers.create( :name => '3服-地狱咆哮', :game_id => game_id)
this_area.servers.create( :name => '4服-奇迹之手', :game_id => game_id)
this_area = GameArea.create( :name => '华南电信二区', :game_id => game_id)
this_area.servers.create( :name => '1服-狮子之心', :game_id => game_id)
this_area.servers.create( :name => '2服-大地之怒', :game_id => game_id)
this_area.servers.create( :name => '3服-烈焰风暴', :game_id => game_id)
this_area.servers.create( :name => '4服-时空枷锁', :game_id => game_id)
this_area = GameArea.create( :name => '华南电信三区', :game_id => game_id)
this_area.servers.create( :name => '1服-狂暴之拳', :game_id => game_id)
this_area.servers.create( :name => '2服-火焰风暴', :game_id => game_id)
this_area.servers.create( :name => '3服-神圣复仇', :game_id => game_id)
this_area.servers.create( :name => '4服-风起云涌', :game_id => game_id)
this_area = GameArea.create( :name => '华南电信四区', :game_id => game_id)
this_area.servers.create( :name => '1服-上古圣地', :game_id => game_id)
this_area.servers.create( :name => '2服-屠龙之谷', :game_id => game_id)
this_area.servers.create( :name => '3服-天涯之巅', :game_id => game_id)
this_area.servers.create( :name => '4服-天堂之门', :game_id => game_id)
this_area = GameArea.create( :name => '华中电信一区', :game_id => game_id)
this_area.servers.create( :name => '1服-雷霆之怒', :game_id => game_id)
this_area.servers.create( :name => '2服-怒雷风暴', :game_id => game_id)
this_area.servers.create( :name => '3服-流星赶月', :game_id => game_id)
this_area.servers.create( :name => '4服-雷电之手', :game_id => game_id)
this_area = GameArea.create( :name => '华中电信二区', :game_id => game_id)
this_area.servers.create( :name => '1服-剑气侠虹', :game_id => game_id)
this_area.servers.create( :name => '2服-飞火流星', :game_id => game_id)
this_area.servers.create( :name => '3服-乾坤一掷', :game_id => game_id)
this_area.servers.create( :name => '4服-凌波微步', :game_id => game_id)
this_area = GameArea.create( :name => '西南电信一区', :game_id => game_id)
this_area.servers.create( :name => '1服-制裁之锤', :game_id => game_id)
this_area.servers.create( :name => '2服-神圣之刃', :game_id => game_id)
this_area.servers.create( :name => '3服-圣光十字', :game_id => game_id)
this_area.servers.create( :name => '4服-横扫千军', :game_id => game_id)
this_area = GameArea.create( :name => '西南电信二区', :game_id => game_id)
this_area.servers.create( :name => '1服-无坚不摧', :game_id => game_id)
this_area.servers.create( :name => '2服-勇往直前', :game_id => game_id)
this_area.servers.create( :name => '3服-力不可挡', :game_id => game_id)
this_area.servers.create( :name => '4服-气势冲天', :game_id => game_id)
this_area = GameArea.create( :name => '南方电信一区', :game_id => game_id)
this_area.servers.create( :name => '1服-冰霜之魂', :game_id => game_id)
this_area.servers.create( :name => '2服-寒气凛然', :game_id => game_id)
this_area.servers.create( :name => '3服-烈火之灵', :game_id => game_id)
this_area.servers.create( :name => '4服-怒焰狂暴', :game_id => game_id)
this_area = GameArea.create( :name => '东北网通一区', :game_id => game_id)
this_area.servers.create( :name => '1服-天神下凡', :game_id => game_id)
this_area.servers.create( :name => '2服-自然之风', :game_id => game_id)
this_area.servers.create( :name => '3服-挥剑天下', :game_id => game_id)
this_area.servers.create( :name => '4服-闪耀之心', :game_id => game_id)
this_area = GameArea.create( :name => '东北网通二区', :game_id => game_id)
this_area.servers.create( :name => '1服-梦境圣地', :game_id => game_id)
this_area.servers.create( :name => '2服-魔幻森林', :game_id => game_id)
this_area.servers.create( :name => '3服-迷失之岛', :game_id => game_id)
this_area.servers.create( :name => '4服-落雨峡谷', :game_id => game_id)
this_area = GameArea.create( :name => '华北网通一区', :game_id => game_id)
this_area.servers.create( :name => '1服-复苏之风', :game_id => game_id)
this_area.servers.create( :name => '2服-神恩恢复', :game_id => game_id)
this_area.servers.create( :name => '3服-燃烧远袭', :game_id => game_id)
this_area.servers.create( :name => '4服-震荡猛击', :game_id => game_id)
this_area = GameArea.create( :name => '华北网通二区', :game_id => game_id)
this_area.servers.create( :name => '1服-冰封之刃', :game_id => game_id)
this_area.servers.create( :name => '2服-凛风冲击', :game_id => game_id)
this_area.servers.create( :name => '3服-寒光之泉', :game_id => game_id)
this_area.servers.create( :name => '4服-霜冻雷霆', :game_id => game_id)
this_area = GameArea.create( :name => '山东网通区', :game_id => game_id)
this_area.servers.create( :name => '1服-守护图腾', :game_id => game_id)
this_area.servers.create( :name => '2服-熔岩猛击', :game_id => game_id)
this_area.servers.create( :name => '3服-风暴打击', :game_id => game_id)
this_area.servers.create( :name => '4服-火焰冲锋', :game_id => game_id)
  end

  def self.down
  end
end
