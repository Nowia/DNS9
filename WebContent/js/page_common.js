//放在 所有div之後

function userDialogOpen(dialogObj) 	{ dialogObj.dialog("open"); }

//輸入過濾器事件
//內嵌網頁中   多加一keypress事件  才工作正常 
//$('input.column_input').on('keyup keypress', function () {
$('input.column_input').on('keyup keypress', function () {
	//alert($(this).attr('data-column'));
	var i=$(this).attr('data-column');
	oTable.column(i).search($('#col'+i+'_input').val()).draw();
} );
			
//選擇過濾器事件
$('select.column_select').on('change', function () {
	//alert( $(this).attr('data-column'));
	var i=$(this).attr('data-column');
	oTable.column(i).search($('#col'+i+'_select').find('option:selected').val()).draw(); 
} );

//tab點選 事件觸發 切換php檔案
$('#tabs').on('tabsbeforeactivate', function(event, ui) {
	var curTabsIndex=$("#tabs").tabs("option", "active");
	//alert(curTabsIndex);
	var tabId=ui.newPanel.attr('id').toLowerCase();
	if ( tabId.indexOf("logout")>=0 )
	{		
		if ( confirm("Are you sure to logout?") ) window.location="Login.htm";
		else $("#tabs").tabs("option", "active", curTabsIndex);
		return false;	//interrupt event
	}
	//var tabId=$("#tabs .ui-state-active > a").html();
	//var tabId=ui.newTab.text();
	//var tabId=ui.newTab[0].innerText;
	//alert(tabId);
	var keyString = "tabs-";
	var position = tabId.indexOf(keyString);
	var newpage=tabId.substring(position+keyString.length, tabId.length)+".htm";
	//alert(newpage);
	window.location=newpage;
});

$(".grd1 tr:odd").addClass("odd");
$(".grd1 tr:even").addClass("even");

function trim(str)	//修剪字串前後的空格
{
	return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}