Iyxzone.Status = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {}
};

Object.extend(Iyxzone.Status.Builder, {

  validate: function(){
    if($('status_content').value == ''){
      error('状态不能为空');
      return false;
    }else if($('status_content').value.length > 140){
      error('字数不能超过140');
      return false;
    }
    return true;
  },

  save: function(button, event){
    Event.stop(event);
    if(this.validate()){
      var form = $('status_form');
      new Ajax.Request('/statuses', {
        method: 'post', 
        parameters: form.serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '发布');
        }
      });
    }
  }

});
