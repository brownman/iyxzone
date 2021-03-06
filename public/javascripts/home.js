Iyxzone.Home = {

  version: '1.0',

  author: ['高侠鸿'],

  Feeder: {},

  NoticeManager: {}

};

Object.extend(Iyxzone.Home.NoticeManager, {

  fetch: function(){
    new Ajax.Request(Iyxzone.URL.listNotice(), {
      method: 'get',
      parameters: {'limit': 10, 'offset': 0},
      onSuccess: function(transport){
        $('my_notices').update(transport.responseText);
      }.bind(this)
    });
  },

  isReading: false,

  read: function(noticeID, token){
    // 要保证只能一条一条删，避免由于ajax异步带来的奇怪结果
    if(this.isReading){
      return;
    }

    new Ajax.Request(Iyxzone.URL.readNotice(noticeID), {
      method: 'put',
      parameters: "authenticity_token=" + encodeURIComponent(token),
      onLoading: function(){
        this.isReading = true;
        Iyxzone.changeCursor('wait');
      }.bind(this),
      onComplete: function(){
        this.isReading = false;
        Iyxzone.changeCursor('default');
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('my_notices').innerHTML = json.html;
        }else{
          error("删除的时候发生错误");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.Home.Feeder, {
  
  curIdx: 0, 

  curType: null,

  // 其实有点多余，只要判断cache里面有没有就可以了
  // 只要有，那说明不是ajax完成了，就是正在进行，无论哪种都不需要在发ajax了
  curLoading: false,

  userID: null,

  fetchSize: null,

  cache: new Hash(),

  init: function(userID, fetchSize){
    this.cache.set("all", {idx: 1, loading: false, html: null});
    this.cache.set("blog", {idx: 0, loading: false, html: null});
    this.cache.set("album", {idx: 0, loading: false, html: null});
    this.cache.set("video", {idx: 0, loading: false, html: null});
    this.curType = 'all';
    this.curIdx = 1;
    this.curLoading = false;
    this.userID = userID;
    this.fetchSize = fetchSize;
  },

  setTab: function(type){
    $('tab_all').className = '';
    $('tab_blog').className = '';
    $('tab_album').className = '';
    $('tab_video').className = '';
    $('tab_' + type).className = 'hover';
  },

  showFeeds: function(type){
    if(this.curType == type)
      return;

    // save
    this.cache.set(this.curType, {html: $('feed_panel').innerHTML, idx: this.curIdx, loading: this.curLoading});
   
    // restore
    var info = this.cache.get(type);
    this.curIdx = info.idx;
    this.curLoading = info.loading;
    this.curType = type;
    this.setTab(type);
    
    // try to load from cache
    if(info.html){
      $('feed_panel').innerHTML = info.html;
      $('feed_panel').innerHTML.evalScripts();
      return;
    }

    // 说明前面已经让他在loading了，不多发请求
    // 这保证了相同类型的，每次只会发一次请求
    if(this.curLoading){
      return;
    }

    // info.html为空说明是第一次点击
    new Ajax.Request('/feed_deliveries', {
      method: 'get',
      parameters: {recipient_id: this.userID, recipient_type: 'User', category: type, fetch: this.fetchSize},
      onLoading: function(){
        this.curLoading = true;
        $('feed_list').update('');
        $('more_feed_panel').update("<div class='ajaxLoading'><img src='/images/ajax-loader.gif' /></div>");
      }.bind(this),
      onSuccess: function(transport){
        var newFeeds = new Element('div');
        var moreFeeds = new Element('div');
        newFeeds.innerHTML = transport.responseText;
        var len = newFeeds.childElements().length;
        if(len == 0 || len < this.fetchSize){ //说明没有了
          moreFeeds.update(this.noFeedHTML());
        }else{
          moreFeeds.update(this.moreFeedHTML());
        }
        
        if(this.curType == type){ //说明没切换，或者又切了回来
          $('feed_list').insert({bottom: newFeeds.innerHTML});
          $('more_feed_panel').update(moreFeeds.innerHTML);
          this.curIdx = 1;
          this.curLoading = false;
        }else{ // 说明切换了, curIdx, curType, curLoading已经不是当时的值了
          var info = this.cache.get(type);
          var tmp = new Element('div').update(info.html);
          var oldFeedList = tmp.childElements()[0];
          var oldMoreFeeds = tmp.childElements()[2];
          oldFeedList.insert({bottom: newFeeds.innerHTML});
          oldMoreFeeds.update(moreFeeds.innerHTML);
          this.cache.set(type, {html: tmp.innerHTML, idx: info.idx + 1, loading: false});
        }
      }.bind(this)
    });
  },

  moreFeeds: function(){
    var oldType = this.curType;

    new Ajax.Request('/feed_deliveries', {
      method: 'get',
      parameters: {recipient_id: this.userID, recipient_type: 'User', fetch: this.fetchSize, category: this.curType, idx: this.curIdx},
      onLoading: function(){
        this.curLoading = true;
        $('more_feed_panel').update("<div class='ajaxLoading'><img src='/images/ajax-loader.gif' /></div>");
      }.bind(this),
      onSuccess: function(transport){
        var newFeeds = new Element('div');
        var moreFeeds = new Element('div');
        newFeeds.innerHTML = transport.responseText;
        var len = newFeeds.childElements().length;
        if(len == 0 || len < this.fetchSize){ //说明没有了
          moreFeeds.update(this.noFeedHTML());
        }else{
          moreFeeds.update(this.moreFeedHTML());
        }

        if(this.curType == oldType){
          $('feed_list').insert({bottom: newFeeds.innerHTML});
          $('more_feed_panel').update(moreFeeds.innerHTML);
          this.curIdx = this.curIdx + 1;
          this.curLoading = false;
        }else{
          var info = this.cache.get(oldType);
          var tmp = new Element('div').update(info.html);
          var oldFeedList = tmp.childElements()[0];
          var oldMoreFeeds = tmp.childElements()[2];
          oldFeedList.insert({bottom: newFeeds.innerHTML});
          oldMoreFeeds.update(moreFeeds.innerHTML);
          this.cache.set(oldType, {html: tmp.innerHTML, idx: info.idx + 1, loading: false});
        }
      }.bind(this)
    });
  },

  noFeedHTML: function(){
    return this.baseHTML('<div class="jl-more">没有更多了...</div>');
  },

  moreFeedHTML: function(){
    return this.baseHTML('<a href="javascript:void(0)" onclick="Iyxzone.Home.Feeder.moreFeeds();" class="jl-more">更多新鲜事</a>');
  },

  baseHTML: function(con){
    var html = '<div class="round04 round_r_t jl-read-more space s_clear">';
    html += '<div class="round_l_t"><div class="round_r_b"><div class="round_l_b"><div class="round_m"><div class="round_body" id="more_feed_link">';
    html +=  con;
    html += '</div></div></div></div></div></div>';
    return html;
  }

});
