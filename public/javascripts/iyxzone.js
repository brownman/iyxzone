Iyxzone = {};

Object.extend(Iyxzone, {

  version: 1.0,

  author: ['高侠鸿'],

  SiteURL: "http://localhost:3000"

});

// 一些按钮操作
Object.extend(Iyxzone, {
  
  disableButton: function(button, text){
    button.innerHTML = text;
    $(button).writeAttribute('disabled', 'disabled');
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button button-gray');
  },

  enableButton: function(button, text){
    button.innerHTML = text;
    button.disabled = '';
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button');
  },

  disableButtonThree: function(button, text){
    button.innerHTML = text;
    $(button).writeAttribute('disabled', 'disabled');
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button03 button03-gray');
  },

  enableButtonThree: function(button, text){
    button.innerHTML = text;
    button.disabled = '';
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button03');
  }

});


Object.extend(Iyxzone, {

  validationCode: function(digits){
    var codes = new Array(digits);       //用于存储随机验证码
    var colors = new Array("Red","Green","Gray","Blue","Maroon","Aqua","Fuchsia","Lime","Olive","Silver");
    for(var i=0;i < codes.length;i++){//获取随机验证码
      codes[i] = Math.floor(Math.random()*10);
    }
    var div = new Element('div');
    for(var i = 0;i < codes.length;i++){
      var span = new Element('span');
      span.innerHTML = codes[i];
      span.setStyle({'color': colors[Math.floor(Math.random()*10)]});
      div.appendChild(span);
    }
    return {'codes': codes, 'div': div};
  },

  changeCursor: function(type){
    document.body.style.cursor = type;
  },

  blinkTitle: function(){
    if(!/^【　　　】/.exec(document.title)){
      document.title='【　　　】' + this.documentTitle;
    }else{
      document.title='【' + this.blinkText + '】' + this.documentTitle;
    }
    setTimeout(this.blinkTitle.bind(this), 500);
  },

  startBlinkTitle: function(text){
    if(this.documentTitleTimer == null){
      this.documentTitle = document.title;
      this.blinkText = text;
      this.documentTitleTimer = setTimeout(this.blinkTitle.bind(this), 500);
    }else{
      this.blinkText = text;
    } 
  },

	
	addToBookmark: function(){
		title = "17gaming 一起游戏网";
		url="http://www.17gaming.com/";
		if (window.sidebar) // firefox
			window.sidebar.addPanel(title, url, "");
		else if(window.opera && window.print){ // opera
			var elem = document.createElement('a');
			elem.setAttribute('href',url);
			elem.setAttribute('title',title);
			elem.setAttribute('rel','sidebar');
			elem.click();
		}
		else if(document.all)// ie
			window.external.AddFavorite(url, title);
	},

	addToHomepage: function(){
		if (Prototype.Browser.IE){
			document.body.style.behavior='url(#default#homepage)';
			document.body.setHomePage('http://www.17gaming.com');
		}
		else{
			alert("您的浏览器不支持自动设置首页，请手动添加!");
		}
	},

  // 下面这个函数只是用于你收到邮件后的提示
  newMailNotice: function(){
    Iyxzone.startBlinkTitle('新邮件');
    var navItem = $('navinbox');
    var elm = navItem.down('strong');
    if(elm){
      var num = parseInt(elm.innerHTML) + 1;
      elm.update(num);
    }else{
      navItem.update('站内信<em class="notice-bubble"><strong>1</strong></em>');
    }
    Sound.play('music/tip.wav');
  },

  newNotificationNotice: function(){
    Iyxzone.startBlinkTitle('新通知');
    var navItem = $('navnotice');
    var elm = navItem.down('strong');
    if(elm){
      var num = parseInt(elm.innerHTML) + 1;
      elm.update(num);
    }else{
      navItem.update('通知<em class=\"notice-bubble\"><strong>1</strong></em>'); 
    }
    $('notifications_dropdown_list').update(''); 
    $('notifications_dropdown').hide(); 
    Sound.play('/music/tip.wav');
  }

});

// some cursor operation
Object.extend(Iyxzone, {

  // FIXME: ie下的resetCursor貌似有点问题
  resetCursor: function (field) { 
    if (field.setSelectionRange) { 
      field.focus(); 
      field.setSelectionRange(0, 0); 
    }else if (field.createTextRange) { 
      var range = field.createTextRange();  
      range.moveStart('character', 0); 
      range.select(); 
    } 
  },

  insertAtCursor: function(txtarea, text) {
		 var scrollPos = txtarea.scrollTop;
		 var strPos = 0;
		 var br = ((txtarea.selectionStart || txtarea.selectionStart == '0') ? "ff" : (document.selection ? "ie" : false ) );
		 if (br == "ie") { 
				txtarea.focus();
				var range = document.selection.createRange();
				range.moveStart ('character', -txtarea.value.length);
				strPos = range.text.length;
			} 
			else if (br == "ff") strPos = txtarea.selectionStart;
			var front = (txtarea.value).substring(0,strPos);
			var back = (txtarea.value).substring(strPos,txtarea.value.length);
			txtarea.value=front+text+back;
			strPos = strPos + text.length;
			if (br == "ie") {
				txtarea.focus();
				var range = document.selection.createRange();
				range.moveStart ('character', -txtarea.value.length);
				range.moveStart ('character', strPos);
				range.moveEnd ('character', 0);
				range.select(); 
				} 
				else if (br == "ff"){
					txtarea.selectionStart = strPos;
					txtarea.selectionEnd = strPos;
					txtarea.focus(); 
				}
				txtarea.scrollTop = scrollPos; 
    //IE support
		/*
    if (document.selection) {
        field.focus();
				//field.update(value);
        var sel = document.selection.createRange();
				range.moveStart ('character', -field.value.length);
    //Mozilla/Firefox/Netscape 7+ support
    } else if (field.selectionStart || field.selectionStart == '0') {
        field.focus();
        var startPos = field.selectionStart;
        var endPos = field.selectionEnd;
        field.value = field.value.substring(0, startPos) + value + field.value.substring(endPos, field.value.length);
        field.setSelectionRange(endPos+value.length, endPos+value.length);
    } else {
        field.value += value;
    }*/
  },

  getCurPos: function(field){
    if(field.selectionStart)
      return field.selectionStart;
    else if(document.selection){
			var sel = document.selection.createRange();
			var selLength = sel.text.length;
			sel.moveStart ('character', -field.value.length);
			return (sel.text.length - selLength);
		}
  },

  selectText: function(field, start, end){
    field.focus();
    if(field.setSelectionRange){
      field.setSelectionRange(start, end);
    }else{
      var r = field.createTextRange();
      r.collapse(true);
      r.moveEnd('character', end);
      r.moveStart('character', start);
      r.select();
    }
  }

});

Object.extend(Iyxzone, {
  
  limitTextTimers: new Hash(),

  limitText: function(el, max, hook){
    this.limitTextTimers.set(el, {timer: setTimeout(function(){Iyxzone.checkLength(el);}, 200), hook: hook, max: max});
  },

  cancelLimitText: function(el){
    var info = this.limitTextTimers.unset(el);
    if(info)
      clearTimeout(info.timer);
  },

  checkLength: function(el){
    var info = this.limitTextTimers.unset(el);
    if(info && info.hook && info.max){
      info.hook(el, info.max);
    }
    info.timer = setTimeout(function(){Iyxzone.checkLength(el);}, 200);
    this.limitTextTimers.set(el, info);
  }

});

// app game bar
Iyxzone.AppBar = {};

Object.extend(Iyxzone.AppBar, {

  gameInfos: null,

  gameList: null,

  init: function(gameInfos){
    this.gameInfos = gameInfos;
  },

  showGameBar: function(link){
    if(this.gameList == null){
      this.gameList = this.constructGameList();
      document.body.appendChild(this.gameList);
    }
    var li = link.up('li');
    this.gameList.setStyle({
      position: 'absolute',
      left: (li.cumulativeOffset().left + li.getWidth()/2) + 'px',
      top: (li.cumulativeOffset().top + li.getHeight()*3/4) + 'px'
    });
    this.gameList.show();
  },

  hideGameBar: function(){
    if(this.gameList){
      this.gameList.hide();
    }
  },

  constructGameList: function(){
    var el = new Element('div', {id: 'app_game_bar', 'class': 'appGameMine'});
    var html = '<div class="t fix"><strong class="left">我的游戏</strong><a href="javascript:void(0)" onclick="Iyxzone.AppBar.hideGameBar()" class="icon-active right"></a></div>';
    html += '<div class="con"><ul class="xList">';
    for(var i=0;i<this.gameInfos.length;i++){
      html += '<li><a href="/games/' + this.gameInfos[i].id + '" onclick="Iyxzone.AppBar.hideGameBar();">' + this.gameInfos[i].name + '</a></li>';
    }
    html += '</ul></div>';
    el.update(html);
    return el;
  }

});
