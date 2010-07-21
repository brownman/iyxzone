Iyxzone.Guild = {
  version: '1.4',
  author: ['高侠鸿'],
  Builder: {},
  Editor: {},
  MemberManager: {},
  Presentor: {}
};

// 一些guild/show页面上的函数
Object.extend(Iyxzone.Guild.Presentor, {

  feedIdx: 0,

  curTab: null,
  
  cache: new Hash(),

  setTab: function(type){
    $('tab_feed').writeAttribute('class', 'fix unSelected');
    $('tab_topic').writeAttribute('class', 'fix unSelected');
    $('tab_photo').writeAttribute('class', 'fix unSelected');
    $('tab_wall').writeAttribute('class', 'fix unSelected');
    $('tab_' + type).writeAttribute('class', 'fix');
    this.curTab = type;
  },

  loading: function(){
    $('presentation').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
  },
 
  showFeeds: function(guildID){
    if(this.curTab == 'feed')
      return;
  
    var html = this.cache.get('feed');
    
    if(html){
      this.setTab('feed');
      $('presentation').innerHTML = html;
      this.feedIdx = 0;
      return;
    }

    new Ajax.Request('/guilds/' + guildID + '/feeds', {
      method: 'get',
      onLoading: function(){
        this.setTab('feed');
        this.loading();
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('feed', transport.responseText);
        if(this.curTab == 'feed'){
          $('presentation').innerHTML = transport.responseText;
          this.feedIdx = 0;
        }
      }.bind(this)
    });
  },

  moreFeeds: function(guildID){
    // show loading page
    //$('more_feed').innerhTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';

    // send ajax request
    new Ajax.Request('/guilds/' + guildID + '/feeds/more?idx=' + this.feedIdx, {
      method: 'get',
      onSuccess: function(){
        this.feedIdx++;
      }.bind(this)
    });
  },

  showPhotos: function(albumID){
    if(this.curTab == 'photo')
      return;

    var html = this.cache.get('photo')
    
    if(html){
      this.setTab('photo');
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/guild_photos?album_id=' + albumID, {
      method: 'get',
      onLoading: function(){
        this.setTab('photo');
        this.loading();
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('photo', transport.responseText);
        if(this.curTab == 'photo'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  },

  showTopics: function(guildID){
    if(this.curTab == 'topic')
      return;

    var html = this.cache.get('topic');

    if(html){
      this.setTab('topic');
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/guilds/' + guildID + '/topics', {
      method: 'get',
      onLoading: function(){
        this.setTab('topic');
        this.loading();
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('topic', transport.responseText);
        if(this.curTab == 'topic'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  },

  showWall: function(guildID, recipientID){
    if(this.curTab == 'wall')
      return;

    var html = this.cache.get('wall');

    if(html){
      this.setTab('wall');
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/wall_messages/index_with_form', {
      method: 'get',
      parameters: {wall_type: 'guild', wall_id: guildID, recipient_id: recipientID},
      onLoading: function(){
        this.setTab('wall');
        this.loading();
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('wall', transport.responseText);
        if(this.curTab == 'wall'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });      
  }

});

Object.extend(Iyxzone.Guild.MemberManager, {

  currentID: null,

  currentStatus: null,

  guildID: null,

  roleList: null,

  startObserving: function(field){
    this.field = field;
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  stopObserving: function(field){
    clearTimeout(this.timer);
  },

  search: function(){
    var val = this.field.value;
    var ul = $('members');
    ul.childElements().each(function(li){
      var pinyin = li.readAttribute('pinyin');
      var name = li.readAttribute('name');
      if(pinyin.include(val) || name.include(val)){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  buildRoleList: function(){
      this.roleList = new Element('div', {'class': 'drop-wrap'});
      var div = new Element('div', {'class': 'wrap-bg'});
      var dl = new Element('dl');
      var dd = new Element('dd', {'class': 'jt-cutline'});
      var veteran = new Element('a', {href: 'javascript:void(0)'}).update('工会长老');
      var member = new Element('a', {href: 'javascript:void(0)'}).update('普通会员');
      
      dd.appendChild(veteran);
      dd.appendChild(member);
      dl.appendChild(dd);
      this.roleList.appendChild(div);
      this.roleList.appendChild(dl);

      document.observe('click', function(){
        this.roleList.hide();
      }.bind(this));
      veteran.observe('click', function(event){
        Event.stop(event);
        this.changeRole(3);
      }.bind(this));
      member.observe('click', function(event){
        Event.stop(event);
        this.changeRole(4);
      }.bind(this));
  },

  toggleRoleList: function(membershipID, status, event, span){
    Event.stop(event);

    if(this.isChanging){
      return;
    }

    if(this.roleList){
      if(this.currentID == membershipID){
        if(this.roleList.visible()){
          this.roleList.hide();
          this.currentID = null;
          this.currentStatus = null;
        }else{
          this.roleList.show();
          this.currentID = membershipID;
          this.currentStatus = status;
        }
      }else{
        if(this.roleList.visible()){
          Element.insert(span, {after: this.roleList});
          this.currentID = membershipID;
          this.currentStatus = status;
        }else{
          Element.insert(span, {after: this.roleList});
          this.roleList.show();
          this.currentID = membershipID;
          this.currentStatus = status;
        }
      }
    }else{
      this.buildRoleList();
      Element.insert(span, {after: this.roleList});
      this.currentID = membershipID;
      this.currentStatus = status;
    }
  },

  changeRole: function(status){
    if(this.isChanging){
      return;
    }

    if(status == this.currentStatus){
      this.roleList.hide();
    }else{
      new Ajax.Request('/guilds/' + this.guildID + '/memberships/' + this.currentID, {
        method: 'put',
        parameters: 'status=' + status,
        onLoading: function(){
          this.isChanging = true;
          Iyxzone.changeCursor('wait');
          this.roleList.hide();
        }.bind(this),
        onComplete: function(transport){
          this.isChanging = false;
          Iyxzone.changeCursor('default');
          $('member_status_' + this.currentID).writeAttribute('onclick', "Iyxzone.Guild.MemberManager.toggleRoleList(" + this.currentID + ", " + status + ", event, $(this).up());");
        }.bind(this)
      });
    }
  }

});

Object.extend(Iyxzone.Guild.Builder, {

  validate: function(){
    if($('guild_name').value == ''){
      error('名字不能为空');
      return false;
    }
    if($('guild_character_id') && $('guild_character_id').value == ''){
      error('你必须选择作为会长的游戏角色');
      return false;
    }
    if($('guild_name').value.length >= 100){
      error('名字最长100个字符');
      return false;
    }
    if($('guild_description').value == ''){
      error('描述不能为空');
      return false;
    }
    if($('guild_description').value.length >= 1000){
      error('描述最多1000个字符');
      return false;
    }
    return true;
  },

  save: function(form, button){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validate()){
      form.submit();
    }else{
      Iyxzone.enableButton(button, '提交');
    }
  }

});

Object.extend(Iyxzone.Guild.Editor, {

  showError: function(div, content){
    var span = new Element('span', {'class': 'icon-warn'});
    $(div).update(content);
    Element.insert($(div), {'top': span});
  },

  clearError: function(div){
    $(div).innerHTML = '';
  },

  loading: function(div, title){
    $(div).innerHTML = "<div class='edit-toggle space edit'><h3 class='s_clear'><strong class='left'>" + title + "</strong><a class='right' href='#'>取消</a></h3><div class='formcontent con con2'><img src='/images/loading.gif'/></div></div>";
  },

  attendanceRulesHTML: null,

  editAttendanceRulesHTML: null,

  editAttendanceRules: function(guildID){
    this.attendanceRulesHTML = $('attendance_rule_frame').innerHTML;
    if(this.editAttendanceRulesHTML){
//      $('attendance_rule_frame').innerHTML = this.editAttendanceRulesHTML;
      $('attendance_rule_frame').update( this.editAttendanceRulesHTML);
    }else{
      new Ajax.Request('/guilds/' + guildID + '/rules?type=0', {
        method: 'get',
        onLoading: function(){
          this.loading('attendance_rule_frame', '出勤规则');
        }.bind(this),
        onSuccess: function(transport){
          this.editAttendanceRulesHTML = transport.responseText;
//          $('attendance_rule_frame').innerHTML = transport.responseText;
          $('attendance_rule_frame').update( transport.responseText);
        }.bind(this)
      });
    }
  },

  isPresenceOutcomeValid: function(){
    var div = 'presence_rule_error';
    var outcome = $('presence_outcome').value;  

    this.clearError(div);

    if(outcome == ''){
      this.showError(div, "不能为空");
      return false;
    }else{
      outcome = parseInt(outcome);
      if(!outcome){
        this.showError(div, "必须是个整数");
        return false;
      }else if(outcome < 0){
        this.showError(div, "必须是正整数");
        return false;
      }
    }

    return true
  },

  isAbsenceOutcomeValid: function(){
    var div = 'absence_rule_error'; 
    var outcome = $('absence_outcome').value; 
    
    this.clearError(div);

    if(outcome == ''){
      this.showError(div, "不能为空");
      return false;
    }else{
      outcome = parseInt(outcome);
      if(!outcome){
        this.showError(div, "必须是个整数");
        return false;
      }else if(outcome > 0){
        this.showError(div, "必须是负数");
        return false;
      }
    }
  
    return true
  },

  validateAttendanceRules: function(){
    var v1 = this.isPresenceOutcomeValid();
    var v2 = this.isAbsenceOutcomeValid();
    return v1 && v2;
  },

  updateAttendanceRules: function(guildID, form, button){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validateAttendanceRules()){
      new Ajax.Request('/guilds/' + guildID + '/rules/create_or_update?type=0', {
        method: 'post',
        parameters: $(form).serialize(),
        onSuccess: function(transport){
          $('attendance_rule_frame').update( transport.responseText);
          this.editAttendanceRulesHTML = null;
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(button, '完成');
    }
  },

  cancelEditAttendanceRules: function(guildID){
//    $('attendance_rule_frame').innerHTML = this.attendanceRulesHTML;
    $('attendance_rule_frame').update( this.attendanceRulesHTML);
  },
  
  basicRulesHTML: null,

  editBasicRulesHTML: null,
 
  basicRulesCount: 0,

  delRuleIDs: new Array(),

  editBasicRules: function(guildID){
    this.basicRulesHTML = $('basic_rule_frame').innerHTML;
    if(this.editBasicRulesHTML){
//      $('basic_rule_frame').innerHTML = this.editBasicRulesHTML;
      $('basic_rule_frame').update( this.editBasicRulesHTML);
    }else{
      new Ajax.Updater('basic_rule_frame', '/guilds/' + guildID + '/rules?type=1', {
        method: 'get',
        evalScripts: true,
        onLoading: function(){
          this.loading('basic_rule_frame', '其他规则');
        }.bind(this),
        onSuccess: function(transport){
          this.editBasicRulesHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  newBasicRule: function(guildID, button){
    new Ajax.Updater('basic_rules', '/guilds/' + guildID + '/rules/new?id=' + this.basicRulesCount, {
      method: 'get',
      insertion: 'bottom',
      evalScripts: true,
      onSuccess: function(transport){
      }.bind(this)
    });
    this.basicRulesCount++;
  },

  isRuleReasonValid: function(ruleID, newRule){
    if(newRule)
      prefix = 'new';
    else
      prefix = 'existing';

    var div = prefix + '_rule_' + ruleID + '_reason_error';
    var reason = $('guild_' + prefix + '_rules_' + ruleID + '_reason').value;

    this.clearError(div);

    if(reason == ''){
      this.showError(div, '原因不能为空');
      return false;
    }
    
    return true;
  },

  isRuleOutcomeValid: function(ruleID, newRule){
    if(newRule)
      prefix = 'new';
    else
      prefix = 'existing';

    var div = prefix + '_rule_' + ruleID + '_outcome_error';
    var outcome = $('guild_' + prefix + '_rules_' + ruleID + '_outcome').value;

    this.clearError(div);

    if(outcome == ''){
      this.showError(div, '结果不能为空');
      return false;
    }else if(!parseInt(outcome)){
      this.showError(div, '结果必须是整数');
      return false;
    }

    return true;
  },

  validateBasicRules: function(form){
    var valid = true;

    var inputs = form.getInputs();

    inputs.each(function(input){
      if(input.type != 'text')
        return;
      var inputID = input.id;
      var newRule = null;
      if(inputID.match(/new/))
        newRule = true;
      else
        newRule = false;
      var id = inputID.match(/\d+/)[0];
      if(inputID.match(/reason/)){
        valid &= this.isRuleReasonValid(id, newRule);
      }else if(inputID.match(/outcome/)){
        valid &= this.isRuleOutcomeValid(id, newRule);
      }
    }.bind(this));
    
    return valid;
  },

  updateBasicRules: function(guildID, form, button){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validateBasicRules(form)){
      var delParams = '';
      for(var i=0;i < this.delRuleIDs.length;i++){
        delParams += "guild[del_rules][]=" + this.delRuleIDs[i] + "&";
      }

      new Ajax.Request('/guilds/' + guildID + '/rules/create_or_update?type=1', {
        method: 'post',
        parameters: delParams + $(form).serialize(),
        onSuccess: function(transport){
          $('basic_rule_frame').update( transport.responseText);
          this.editBasicRulesHTML = null;
          this.delRuleIDs = new Array();
          this.basicRules = new Hash();
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(button, '完成');
    }
  },

  cancelEditBasicRules: function(guildID){
//    $('basic_rule_frame').innerHTML = this.basicRulesHTML;
    $('basic_rule_frame').update( this.basicRulesHTML);
    this.delRuleIDs = new Array();
  },

  removeBasicRule: function(ruleID, newRule, div){
    if(newRule)
      prefix = 'new';
    else
      prefix = 'existing';

    if(!newRule)
      this.delRuleIDs.push(ruleID);
    
    $(prefix + '_rule_' + ruleID).remove();
  },

  bossesHTML: null,

  editBossesHTML: null,

  bossesCount: 0,

  delBossIDs: new Array(),

  editBosses: function(guildID){
    this.bossesHTML = $('boss_frame').innerHTML;
    this.loading('boss_frame', 'BOSS');

    if(this.editBossesHTML){
//      $('boss_frame').innerHTML = this.editBossesHTML;
      $('boss_frame').update( this.editBossesHTML);
    }else{
      new Ajax.Updater('boss_frame', '/guilds/' + guildID + '/bosses', {
        method: 'get',
        evalScripts: true,
        onSuccess: function(transport){
          this.editBossesHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  newBoss: function(guildID){
    new Ajax.Updater('guild_bosses', '/guilds/' + guildID + '/bosses/new?id=' + this.bossesCount, {
      method: 'get',
      evalScripts: true,
      insertion: 'bottom',
      onSuccess: function(transport){
      }.bind(this)
    });
    this.bossesCount++;
  },

  isBossNameValid: function(bossID, newBoss){
    if(newBoss)
      prefix = 'new';
    else
      prefix = 'existing';

    var div = prefix + '_boss_' + bossID + '_name_error';
    var name = $('guild_' + prefix + '_bosses_' + bossID + '_name').value;

    this.clearError(div);

    if(name == ''){
      this.showError(div, '名字不能为空');
      return false;
    }

    return true;
  },

  isBossRewardValid: function(bossID, newBoss){
    if(newBoss)
      prefix = 'new';
    else
      prefix = 'existing';

    var div = prefix + '_boss_' + bossID + '_reward_error';
    var reward = $('guild_' + prefix + '_bosses_' + bossID + '_reward').value;

    this.clearError(div);

    if(reward == ''){
      this.showError(div, '奖励不能为空');
      return false;
    }else{
      reward = parseInt(reward);
      if(!reward){
        this.showError(div, '奖励不合法');
        return false;
      }else if(reward <= 0){
        this.showError(div, '奖励必须是正数');
        return false;
      }
    }

    return true;
  },

  validateBosses: function(form){
    var valid = true;
    var inputs = form.getInputs();

    inputs.each(function(input){
      if(input.type != 'text')
        return;
      var inputID = input.id;
      var newBoss = null;
      if(inputID.match(/new/))
        newBoss = true;
      else
        newBoss = false;
      var id = inputID.match(/\d+/)[0];
      if(inputID.match(/name/))
        valid &= this.isBossNameValid(id, newBoss);
      else
        valid &= this.isBossRewardValid(id, newBoss);
    }.bind(this));

    return valid; 
  },
  
  updateBosses: function(guildID, form, button){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validateBosses(form)){
      var delParams = '';
      for(var i=0; i < this.delBossIDs.length; i++){
        delParams += "guild[del_bosses][]=" + this.delBossIDs[i] + "&";
      }
      new Ajax.Updater('boss_frame', '/guilds/' + guildID + '/bosses/create_or_update', {
        method: 'post',
        parameters: delParams + $(form).serialize(),
        onSuccess: function(transport){
          this.editBossesHTML = null;
          this.delBossIDs = new Array();
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(button, '完成');
    }
  },

  cancelEditBosses: function(guildID){
//    $('boss_frame').innerHTML = this.bossesHTML;
    $('boss_frame').update( this.bossesHTML);
    this.delBossIDs = new Array();
  },

  removeBoss: function(bossID, newBoss){
    if(newBoss)
      prefix = 'new';
    else
      prefix = 'existing';

    if(!newBoss)
      this.delBossIDs.push(bossID);
  
    $(prefix + '_boss_' + bossID).remove();
  },

  gearsHTML: null,

  editGearsHTML: null,

  gearsCount: 0,

  delGearIDs: new Array(),

  editGears: function(guildID){
    this.gearsHTML = $('gear_frame').innerHTML;
    if(this.editGearsHTML){
//      $('gear_frame').innerHTML = this.editGearsHTML;
      $('gear_frame').update( this.editGearsHTML);
    }else{
      new Ajax.Updater('gear_frame', '/guilds/' + guildID + '/gears', {
        method: 'get',
        evalScripts: true,
        onLoading: function(){
          this.loading('gear_frame', '装备');
        }.bind(this),
        onSuccess: function(transport){
          this.editGearsHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  newGear: function(guildID){
    new Ajax.Updater('guild_gears', '/guilds/' + guildID + '/gears/new?id=' + this.gearsCount, {
      method: 'get',
      evalScripts: true,
      insertion: 'bottom',
      onSuccess: function(transport){
      }.bind(this)
    });
    this.gearsCount++;
  },

  isGearNameValid: function(gearID, newGear){
    if(newGear)
      prefix = 'new';
    else
      prefix = 'existing';

    var div = prefix + '_gear_' + gearID + '_name_error';
    var name = $('guild_' + prefix + '_gears_' + gearID + '_name').value;

    this.clearError(div);

    if(name == ''){
      this.showError(div, '名字不能为空');
      return false;
    }

    return true;        
  },

  isGearCostValid: function(gearID, newGear){
    if(newGear)
      prefix = 'new';
    else
      prefix = 'existing';

    var div = prefix + '_gear_' + gearID + '_cost_error';
    var cost = $('guild_' + prefix + '_gears_' + gearID + '_cost').value;

    this.clearError(div);

    if(cost == ''){
      this.showError(div, '奖励不能为空');
      return false;
    }else{
      cost = parseInt(cost);
      if(!cost){
        this.showError(div, '奖励不合法');
        return false;
      }else if(cost <= 0){
        this.showError(div, '奖励必须是正数');
        return false;
      }
    }

    return true;
  },

  validateGears: function(form){
    var valid = true;
    var inputs = form.getInputs();

    inputs.each(function(input){
      if(input.type != 'text')
        return;
      var inputID = input.id;
      var newGear = null;
      if(inputID.match(/new/))
        newGear = true;
      else
        newGear = false;
      var id = inputID.match(/\d+/)[0];
      if(inputID.match(/name/))
        valid &= this.isGearNameValid(id, newGear);
      else
        valid &= this.isGearCostValid(id, newGear);
    }.bind(this));

    return valid;
  },

  updateGears: function(guildID, form, button){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validateGears(form)){
      var delParams = '';
      for(var i=0; i < this.delGearIDs.length; i++){
        delParams += "guild[del_gears][]=" + this.delGearIDs[i] + "&";
      }
      this.updateGearRequest = new Ajax.Request('/guilds/' + guildID + '/gears/create_or_update', {
        method: 'post',
        parameters: delParams + $(form).serialize(),
        onSuccess: function(transport){
          $('gear_frame').update( transport.responseText);
          this.editGearsHTML = null;
          this.delGearIDs = new Array();
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(button, '完成');
    }
  },

  cancelEditGears: function(guildID){
    $('gear_frame').update( this.gearsHTML);
    this.delGearIDs = new Array();
  },

  removeGear: function(gearID, newGear){
    if(newGear)
      prefix = 'new';
    else
      prefix = 'existing';

    if(!newGear)
      this.delGearIDs.push(gearID);
    
    $(prefix + '_gear_' + gearID).remove();
  }

});
