// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// allows users to type an option that is not in a drop-down select list
function changed(el, cmp, pmt){
	if(el.options[el.selectedIndex].value == cmp) {addoption(el, pmt);}
}

function addoption(el, pmt){
	var txt = prompt(pmt,'');
	if (txt == null) {return;}
	var o = new Option( txt, txt, false, true);
	el.options[el.options.length] = o;
}

function changetab(){
	ttt = tabberObj.prototype.init(document.getElementById('mytabberdiv'))
	ttt.tabShow('Step2')
	debug
	// console.log("hi you")
	// alert("hello")
}
