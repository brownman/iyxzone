function addBookmark(){
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
}
