/**
 * TODO:
 * 点击document.body时候，能够触发hideForm事件
 */

Iyxzone.Comment = {

  version: '1.6',

  author: ['高侠鸿'],

  checkLength: function(field, max){
    var fieldID = field.id;
    var count = field.value.length;
    if(count > max){
      field.value = field.value.substr(0, max);
    }else{
      var wordsCountID = fieldID.gsub('comment_content_', '') + '_words_count';
      $(wordsCountID).innerHTML = count + '/' + max;
    }
  }

};

Object.extend(Iyxzone.Comment, {

  pluralize: function(str){
    if(str == 'status')
      return 'statuses';
    else
      return str + 's';
  },

  validate: function(content){
    if(content.value.length == 0){
      error('评论不能为空');
      return false;
    }
    if(content.value.length > 140){
      error('评论最多140个字节');
      return false;
    }
    return true;
  },

  showForm: function(commentableType, commentableID, login, recipientID){
    $('add_' + commentableType + '_comment_' + commentableID).hide();
    $(commentableType + '_comment_' + commentableID).show();
    $(commentableType + '_comment_recipient_' + commentableID).value = recipientID;
    if(login == null)
      $(commentableType + '_comment_content_' + commentableID).value = "";
    else
      Iyxzone.insertAtCursor($(commentableType + '_comment_content_' + commentableID), "回复" + login + "：");
    $(commentableType + '_comment_content_' + commentableID).focus();  
  },

  hideForm: function(commentableType, commentableID, event){
    Event.stop(event);
    $(commentableType + '_comment_' + commentableID).hide();
    $('add_' + commentableType + '_comment_' + commentableID).show();
  },

  save: function(commentableType, commentableID, event){
    Event.stop(event);

    var form = $(commentableType + '_comment_form_' + commentableID);
    var button = form.down('button', 1);

    if(Iyxzone.Comment.validate($(commentableType + '_comment_content_' + commentableID))){
      new Ajax.Request(Iyxzone.URL.createComment(), { 
        method: 'post',
        parameters: $(commentableType + '_comment_form_' + commentableID).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '发布');
          $(commentableType + '_comment_' + commentableID).hide();
          $('add_' + commentableType + '_comment_' + commentableID).show();
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            $(commentableType + '_comments_' + commentableID).insert({'bottom': json.html});
          }else{
            error("发生错误，请稍后再试");
          }
        }.bind(this)
      });
    }
  },

  destroy: function(commentID, link){
    new Ajax.Request(Iyxzone.URL.deleteComment(commentID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Effect.BlindUp($('comment_' + commentID));
        }else{
          error("发生错误");
          $(link).writeAttribute('onclick', "Iyxzone.Comment.destroy(" + commentID, + ", this);");
        }
      }.bind(this)
    });
  },

  set: function(commentableType, commentableID, login, commentorID){
    this.showForm(commentableType, commentableID, login, commentorID);
    // 需要稍后再移动，是因为上面showForm需要一点时间，不然总是返回0
    setTimeout(function(){window.scrollTo(0, $(commentableType + '_comment_form_' + commentableID).cumulativeOffset().top - 50);}, 200);
  },

  moreCommentsInFoldedBox: function(commentableType, commentableID, offset, limit, link){
    var div = link.up();
    
    if(offset < 1)
      offset = 1;
    if(limit < 0)
      limit = 0;
    
    new Ajax.Request('/comments',{
      method: 'get',
      parameters: {commentable_id: commentableID, commentable_type: commentableType, offset: offset, limit: limit},
      onLoading: function(){
        div.update('显示更多<img src="/images/small-ajax-loader.gif"/>');
      }.bind(this),
      onSuccess: function(transport){
        $(commentableType + '_comments_' + commentableID).update(transport.responseText);
        if(offset == 1){
          div.remove();
        }else{
          div.update('<a href="javascript:void(0)" onclick="Iyxzone.Comment.moreCommentsInFoldedBox(\'' + commentableType + '\', ' + commentableID + ', ' + (offset - limit) + ', ' + limit + ', $(this))">显示更多' + (offset - 1) + '条</a>');
        }
      }.bind(this)
    });
  },

  moreComments: function(commentableType, commentableID, offset, limit, link){
    if(offset < 0)
      offset = 0;
    if(limit < 0)
      limit = 0;

    var div = link.up();

    new Ajax.Request('/comments', {
      method: 'get',
      parameters: {commentable_id: commentableID, commentable_type: commentableType, offset: offset, limit: limit},
      onLoading: function(){
        div.update('显示较早评论<img src="/images/small-ajax-loader.gif"/>');
      }.bind(this),
      onSuccess: function(transport){
        $(commentableType + '_comments_' + commentableID).insert({top: transport.responseText});
        if(offset == 0){
          div.update('没有评论了');
        }else{
          div.update('<a href="javascript:void(0)" onclick="Iyxzone.Comment.moreComments(\'' + commentableType + '\', ' + commentableID + ', ' + (offset - limit) + ', ' + limit + ', $(this))">显示较早评论</a>');
        }
      }.bind(this)
    });
  },

  toggleBox: function(commentableType, commentableID, commentsCount){
    var box = $(commentableType + '_comment_box_' + commentableID);
    var link = $(commentableType + '_comment_link_' + commentableID);
    if(!box.visible()){
      Effect.BlindDown(box);
      if(link)
        link.update('收起回复')
    }else{
      Effect.BlindUp(box);
      if(link)
        link.update(commentsCount + '条回复')
    }
  }

});

Iyxzone.WallMessage = {
  version: '1.1',
  author: ['高侠鸿'],
  changeLog: ['修正了回复别人后，默认的收到评论的人没有恢复']
};

Object.extend(Iyxzone.WallMessage, {

  checkLength: function(field, max){
    var fieldID = field.id;
    var count = field.value.length;
    if(count > max){
      field.value = field.value.substr(0, max);
    }else{
      var wordsCountID = 'wall_words_count';
      $(wordsCountID).innerHTML = count + '/' + max;
    }
  },

  validate: function(content){
    if(content.value.length == 0){
      error('留言不能为空');
      return false;
    }
    if(content.value.length > 140){
      error('留言最多140个字节');
      return false;
    }
    return true; 
  },

  save: function(wallType, wallID, form){
    var textarea = $(form).down('textarea', 0);
    var button = $(form).down('button', 0);

		if(this.validate(textarea)){
			new Ajax.Request(Iyxzone.URL.createWallMessage(), {
        method: 'post',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
          Iyxzone.changeCursor('wait');
        }.bind(this),
        onComplete: function(){
          Iyxzone.enableButton(button, '发布');
          Iyxzone.changeCursor('default');
        }.bind(this),
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            $('comments').insert({'top': json.html});
            if(this.oldRecipientID){
              $('comment_recipient_id').value = this.oldRecipientID;
              this.oldRecipientID = null;
            }
            $('comment_content').clear();
            $('comment_content').focus();
            Effect.BlindDown('comment_' + json.id);
          }else{
            error("发生错误");
          }
        }.bind(this)
      });
		} 
  },

  fetch: function(wallType, wallID){
    new Ajax.Request('/wall_messages?wall_type=' + wallType + '&wall_id=' + wallID, {
      method: 'get',
      onLoading: function(){
        $('comments').innerHTML = '<img src="images/loading.gif" />';
      },
      onSuccess: function(transport){
        $('comments').update( transport.responseText);
      }
    });
  },

  oldRecipientID: null,

  set: function(login, id){
    this.oldRecipientID = $('comment_recipient_id').value;
    $('comment_recipient_id').value = id;
    $('comment_content').focus();
    Iyxzone.insertAtCursor($('comment_content'), '回复' + login + '：');
    setTimeout(function(){window.scrollTo(0, $('comment_content').cumulativeOffset().top - 50);}, 200);
  },
  
  destroy: function(messageID, link){
    new Ajax.Request(Iyxzone.URL.deleteWallMessage(messageID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Effect.BlindUp('comment_' + messageID);
        }else{
          error("发生错误");
          $(link).writeAttribute('onclick', "Iyxzone.WallMessage.destroy(" + messageID, + ", this);");
        }
      }.bind(this)
    });
  }

});
