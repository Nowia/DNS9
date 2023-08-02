<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DBUtil.DB2Connection"%>
<%@page import="java.sql.*"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*,java.text.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Measure Data</title>

<link rel="stylesheet" href="./jquery.dataTables.min.css">
<script src="./jquery-3.5.1.js"></script>
<script src="./jquery.dataTables.min.js"></script>


<script type="text/javascript">
$(document).ready(function () {
	var table = $('#example').DataTable({
        paging: false,
        searching: false,
        "language": {
        	"info": "共 _TOTAL_ 筆資料",
        },
        columnDefs: [
            {
                searchable: false,
                targets: 0,
            },
        ],
        order: [[1, 'asc'], [4, 'asc']],//主排序:時間 次排序:號碼球
    });
    
    $('#example tbody').on('click', 'tr', function () {
        if ($(this).hasClass('selected')) {
            $(this).removeClass('selected');
        } else {
            table.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
    });
    
    table
    .on('order.dt search.dt', function () {
        var i = 1;
 
        table.cells(null, 0, { search: 'applied', order: 'applied' }).every(function (cell) {
            this.data(i++);
        });
    })
    .draw();
});
</script>

<style type='text/css'>
#header2  {width:100%;
           height:30px;
           text-align:center;
           background:#9BCDDE;
           margin:0 auto;
          }
#outer2   {width:100%;
           text-align:center;
           margin:0px auto;
           background:white;
          }


a { text-decoration:none }

</style>
<script>
function savePages() {
	var url = "儲存";
	var ISSUE_TYPE = "ISSUE_TYPE=";
	var grade = "grade=";
	var bubble = "bubble=";
	var DESIGN_Max = "DESIGN_Max=";
	var DESIGN_DATA = "DESIGN_DATA=";
	var DESIGN_Min = "DESIGN_Min=";
	var TOL = "TOL=";
	var MEASURE_DATA = "MEASURE_DATA=";
	var PRODUCT_ID = "PRODUCT_ID=";
	var WORDER_ID = "WORDER_ID=";
	var QC_TIME = "QC_TIME=";
	
	//gets table
	var oTable = document.getElementById('example');

	//gets rows of table
	var rowLength = oTable.rows.length;

	//loops through rows    
	for (i = 1; i < rowLength-1; i++){ //cut first and last row

	  //gets cells of current row  
	   var oCells = oTable.rows.item(i).cells;

	   //gets amount of cells of current row
	   var cellLength = oCells.length;

	   //loops through each cell in current row
	   for(var j = 0; j < cellLength; j++){
	      // get your cell info here

	      var cellVal = oCells.item(j).innerHTML;
	      //alert(cellVal);
	      if (j==0){ ISSUE_TYPE = ISSUE_TYPE + cellVal + "~"; }
	      if (j==1){ QC_TIME = QC_TIME + cellVal + "~"; }
	      if (j==2){ grade = grade + cellVal + "~"; }
	      if (j==3){ bubble = bubble + cellVal + "~"; }
	      if (j==4){ DESIGN_Max = DESIGN_Max + cellVal + "~"; }
	      if (j==5){ DESIGN_DATA = DESIGN_DATA + cellVal + "~"; }
	      if (j==6){ DESIGN_Min = DESIGN_Min + cellVal + "~"; }
	      if (j==7){ TOL = TOL + cellVal + "~"; }
	      if (j==8){ MEASURE_DATA = MEASURE_DATA + cellVal + "~"; }
	      if (j==9){ PRODUCT_ID = PRODUCT_ID + cellVal + "~"; }
	      if (j==10){ WORDER_ID = WORDER_ID + cellVal + "~"; }
	   }
	}
	
	url = url+ISSUE_TYPE+grade+bubble+DESIGN_Max+DESIGN_DATA+DESIGN_Min+TOL+MEASURE_DATA+PRODUCT_ID+WORDER_ID+QC_TIME;
	alert(url);
}

function refreshTable(timeWant) {
	//alert ("timeWant="+timeWant);
	var btn = document.getElementById(timeWant);
	var style = getComputedStyle(btn);
	//alert ("status="+style['background-color']);
	
	var disableStyle = 'rgb(133, 133, 133)';
	var enableStyle = 'rgb(255, 255, 255)';
	
	if (style['background-color']==disableStyle){
		//alert ("disable to enable");
		document.getElementById(timeWant).style.background=enableStyle;
		enableRows(timeWant);
	} else if (style['background-color']==enableStyle){
		//alert ("enable to disable");
		document.getElementById(timeWant).style.background=disableStyle;
		disableRows(timeWant);
	}
}

function enableRows(timeWant) {
	var tableSet = document.getElementById("example");
	var totalRow = document.getElementById("example").rows.length;
	var timeGot;
	for(var f = 1; f < totalRow; f++){
		timeGot = tableSet.rows[f].cells[1].innerHTML;
		//alert ("timeGot="+timeGot);
		if (timeGot==timeWant){
			//alert ("true");
			tableSet.rows[f].style.display = "";
		}
	}
}

function disableRows(timeWant) {
	var tableSet = document.getElementById("example");
	var totalRow = document.getElementById("example").rows.length;
	var timeGot;
	for(var f = 1; f < totalRow; f++){
		timeGot = tableSet.rows[f].cells[1].innerHTML;
		//alert ("timeGot="+timeGot);
		if (timeGot==timeWant){
			//alert ("true");
			tableSet.rows[f].style.display = "none";
		}
	}
}
</script>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");

String DIE_ID =  request.getParameter("DIE_ID");
String WORDER_ID =  request.getParameter("WORDER_ID");
String PRODUCT_ID =  request.getParameter("PRODUCT_ID");
String ISSUE_TYPE =  request.getParameter("ISSUE_TYPE");

ArrayList<String> ISSUE_NO = new ArrayList<String>(); //
ArrayList<String> ITEM = new ArrayList<String>(); //
//ArrayList<String> NOTE = new ArrayList<String>();
ArrayList<Double> MEASURE_DATA = new ArrayList<Double>(); //
ArrayList<Double> DESIGN_DATA = new ArrayList<Double>(); //
ArrayList<Double> TOLER_UP = new ArrayList<Double>(); //
ArrayList<Double> TOLER_DOWN = new ArrayList<Double>(); //
ArrayList<String> DEVIATION = new ArrayList<String>();
ArrayList<String> ASSESMENT = new ArrayList<String>();
//ArrayList<String> MEASURE_TYPE = new ArrayList<String>();
//ArrayList<String> QC_EQPT = new ArrayList<String>();
ArrayList<String> QC_DATE = new ArrayList<String>();
ArrayList<String> QC_TIME = new ArrayList<String>();
//ArrayList<String> PROGRAM_NAME = new ArrayList<String>();
ArrayList<String> SIDE_NO = new ArrayList<String>();
ArrayList<String> grade = new ArrayList<String>(); //尺寸級別
ArrayList<String> bubble = new ArrayList<String>(); //號碼球
String ITEMGot = "";

//計算量測值MAX
Map<String,Double> MEASURE_Max_Map = new HashMap();
Map<String,Double> MEASURE_Min_Map = new HashMap();
Map<String,String> gradeMap = new HashMap();
Map<String,Double> TOLER_UP_Map = new HashMap();
Map<String,Double> TOLER_DOWN_Map = new HashMap();
Map<String,String> TOLER_UP_STR_Map = new HashMap();
Map<String,String> TOLER_DOWN_STR_Map = new HashMap();
Map<String,Double> DESIGN_DATA_Map = new HashMap();
Map<String,String> QC_TIME_Map = new HashMap();
Map<String,String> bubbleMap = new HashMap();
TreeSet<String> TIME_BTN_Set = new TreeSet<String>(); //sort by nature
//顯示檢驗類別
Map<String,String> ISSUE_TYPE_Map = new HashMap();
ISSUE_TYPE_Map.put("01", "完整首件");
ISSUE_TYPE_Map.put("02", "簡易首件");
ISSUE_TYPE_Map.put("03", "中件頻率送檢");
ISSUE_TYPE_Map.put("04", "末件檢查");
ISSUE_TYPE_Map.put("05", "調整量測");
ISSUE_TYPE_Map.put("06", "品保-調查量測");
ISSUE_TYPE_Map.put("07", "模工-試模量測");
ISSUE_TYPE_Map.put("08", "模工-新產品首件");
ISSUE_TYPE_Map.put("09", "模工-新產品中件頻率送檢");
ISSUE_TYPE_Map.put("10", "模工-新產品末件");
ISSUE_TYPE_Map.put("11", "品保-新產品送樣報告");

String ISSUE_TYPE_STR = ISSUE_TYPE_Map.get(ISSUE_TYPE);
DecimalFormat df = new DecimalFormat("0.0000");
//df.setPositivePrefix("+");

DB2Connection mainQuery = new DB2Connection();
//ResultSet qcrs = mainQuery.QueryData("SELECT * FROM PPT1D.AIPQC_SAMPLE_MEASURE_DATA WHERE DIE_ID='"+DIE_ID+"' AND WORDER_ID='"+WORDER_ID+"' AND PRODUCT_ID='"+PRODUCT_ID+"'");
ResultSet qcrs = mainQuery.QueryData("SELECT * FROM RPT1D.AIPQC_SAMPLE_MEASURE_DATA WHERE DIE_ID='"+DIE_ID+"' AND WORDER_ID='"+WORDER_ID+"' AND PRODUCT_ID='"+PRODUCT_ID+"' AND ISSUE_TYPE='"+ISSUE_TYPE+"' AND ((DEVIATION > TOLER_UP) OR (DEVIATION < TOLER_DOWN)) ORDER BY QC_TIME DESC");
int rsCount = mainQuery.getRsCount();

while (qcrs.next()) {
  //empNo = rs.getString(1);
  ISSUE_NO.add(qcrs.getString("ISSUE_NO"));
  ITEMGot = qcrs.getString("ITEM"); 
  ITEM.add(ITEMGot);
  //NOTE.add(qcrs.getString("NOTE"));
  MEASURE_DATA.add(qcrs.getDouble("MEASURE_DATA"));
  DESIGN_DATA.add(qcrs.getDouble("DESIGN_DATA"));
  TOLER_UP.add(qcrs.getDouble("TOLER_UP"));
  TOLER_DOWN.add(qcrs.getDouble("TOLER_DOWN"));
  DEVIATION.add(qcrs.getString("DEVIATION"));
  ASSESMENT.add(qcrs.getString("ASSESMENT"));
  //MEASURE_TYPE.add(qcrs.getString("MEASURE_TYPE"));
  //QC_EQPT.add(qcrs.getString("QC_EQPT"));
  QC_DATE.add(qcrs.getString("QC_DATE"));
  QC_TIME.add(qcrs.getString("QC_TIME"));
  //PROGRAM_NAME.add(qcrs.getString("PROGRAM_NAME"));
  SIDE_NO.add(qcrs.getString("SIDE_NO"));
  
  //deal with ITEM
  String[] ITEMs = ITEMGot.split(":");
  ITEMGot = ITEMs[ITEMs.length-1];
  String[] ITEM2s = ITEMGot.split("_");
  if (ITEM2s.length>=4){
	  grade.add(ITEM2s[0]);
	  bubble.add(ITEM2s[3]);
	  //gradeMap.put(ITEM2s[3], ITEM2s[0]);
  } else {
	  grade.add("NA");
	  bubble.add("NA");
  }
}

mainQuery.CloseQueryData();
mainQuery.finish();

for( int i=0 ; i < MEASURE_DATA.size() ;i++){
	String pkey = bubble.get(i)+ " " +QC_DATE.get(i)+ " " +QC_TIME.get(i)+ " " +SIDE_NO.get(i);
	gradeMap.put(pkey, grade.get(i));
	bubbleMap.put(pkey, bubble.get(i));
	//max
	if (MEASURE_Max_Map.containsKey(bubble.get(i))){
		if (MEASURE_DATA.get(i) > MEASURE_Max_Map.get(bubble.get(i))){
			MEASURE_Max_Map.put(pkey, MEASURE_DATA.get(i));
		}
	} else {
		MEASURE_Max_Map.put(pkey, MEASURE_DATA.get(i));
	}
	//min
	if (MEASURE_Min_Map.containsKey(bubble.get(i))){
		if (MEASURE_DATA.get(i) < MEASURE_Min_Map.get(bubble.get(i))){
			MEASURE_Min_Map.put(pkey, MEASURE_DATA.get(i));
		}
	} else {
		MEASURE_Min_Map.put(pkey, MEASURE_DATA.get(i));
	}
	//set others, store the last one
	if (TOLER_UP.get(i)>=0.0){
		TOLER_UP_STR_Map.put(pkey, "+"+TOLER_UP.get(i));
	} else {
		TOLER_UP_STR_Map.put(pkey, TOLER_UP.get(i).toString());
	}
	if (TOLER_DOWN.get(i)>=0.0){
		TOLER_DOWN_STR_Map.put(pkey, "+"+TOLER_DOWN.get(i));
	} else {
		TOLER_DOWN_STR_Map.put(pkey, TOLER_DOWN.get(i).toString());
	}
	TOLER_UP_Map.put(pkey, TOLER_UP.get(i));
	TOLER_DOWN_Map.put(pkey, TOLER_DOWN.get(i));
	DESIGN_DATA_Map.put(pkey, DESIGN_DATA.get(i));
	QC_TIME_Map.put(pkey, QC_DATE.get(i)+ " " +QC_TIME.get(i)+ " " +SIDE_NO.get(i));
}

//只儲存有在表內的
for( int i=0 ; i < QC_DATE.size() ;i++){
	TIME_BTN_Set.add( QC_DATE.get(i)+ " " +QC_TIME.get(i)+ " " +SIDE_NO.get(i));
}
%>

<div id='header2'>試模資料整理</div>

<div>
<% for (String value : TIME_BTN_Set){
%>
<button id="<%= value %>" onclick="refreshTable('<%= value %>')" style="background-color:rgb(255, 255, 255);"><%= value %></button>
<% } %>
<button id="saveBtn" onclick="savePages()">寫入PLM後關閉網頁</button>
<table id="example" class="cell-border hover" style="width:100%">
        <thead>
            <tr>
            	<th>排序</th>
            	<th>檢驗時間/側別</th>
                <th>製程事件</th>
                <th>尺寸級別</th>
                <th>號碼球</th>
                <th>上限</th>
                <th>尺寸規格值</th>
                <th>下限</th>
                <th>公差</th>
                <th>尺寸實際值</th>
                <th>料號</th>
                <th>工單編號</th>
                <th>狀態</th>
            </tr>
        </thead>
        <tbody>
        <% for (Object key : gradeMap.keySet()) {
        %>
            <tr>
            	<td></td>
            	<td><%= QC_TIME_Map.get(key) %></td>
                <td><%= ISSUE_TYPE_STR %></td>
                <td><%= gradeMap.get(key) %></td>
                <td><%= bubbleMap.get(key) %></td>
                <td><%= df.format(TOLER_UP_Map.get(key)+DESIGN_DATA_Map.get(key)) %></td>
                <td><%= df.format(DESIGN_DATA_Map.get(key)) %></td>
                <td><%= df.format(TOLER_DOWN_Map.get(key)+DESIGN_DATA_Map.get(key)) %></td>
                <td><%= TOLER_UP_STR_Map.get(key) %>/<%= TOLER_DOWN_STR_Map.get(key) %></td>
                <td><%= df.format(MEASURE_Min_Map.get(key)) %>~<%= df.format(MEASURE_Max_Map.get(key)) %></td>
                <td><%= PRODUCT_ID %></td>
                <td><%= WORDER_ID %></td>
                <td>NG</td>
            </tr>
        <% } %>
        </tbody>
        <tfoot>
            <tr>
            	<th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
              </tr>
        </tfoot>
    </table>
</div>
   
</body>

</html>