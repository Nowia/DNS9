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
	    scrollCollapse: true,
	    scrollY: '70vh',
        "language": {
        	"info": "共 _TOTAL_ 筆資料",
        },
        columnDefs: [
            {
                searchable: false,
                targets: 0,
            },
        ],
    });
    
    $('#example tbody').on('click', 'tr', function () {
        if ($(this).hasClass('selected')) {
            $(this).removeClass('selected');
        } else {
            table.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
    });
 
    $('#button0').click(function () {
    	//alert("Test");
        let column = table.column(0);
        // Toggle the visibility
        column.visible(!column.visible());
        refreshBTNTable("button0");
    });
    
    $('#button1').click(function () {
    	//alert("Test");
        let column = table.column(1);
        // Toggle the visibility
        column.visible(!column.visible());
        refreshBTNTable("button1");
    });
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

button {
  background-color: rgb(39, 174, 163);
  border: none;
  color: white;
  padding: 5px 10px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
}
</style>
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
ArrayList<String> grade = new ArrayList<String>(); //尺寸級別
ArrayList<String> bubble = new ArrayList<String>(); //號碼球
String ITEMGot = "";

//計算量測值MAX
Map<String,Double> MEASURE_Max_Map = new HashMap();
Map<String,Double> MEASURE_Min_Map = new HashMap();

DecimalFormat df = new DecimalFormat("0.0000");

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
  
  //deal with ITEM
  String[] ITEMs = ITEMGot.split(":");
  ITEMGot = ITEMs[ITEMs.length-1];
  String[] ITEM2s = ITEMGot.split("_");
  if (ITEM2s.length>=4){
	  grade.add(ITEM2s[0]);
	  bubble.add(ITEM2s[3]);
  } else {
	  grade.add("NA");
	  bubble.add("NA");
  }
}

mainQuery.CloseQueryData();
mainQuery.finish();

for( int i=0 ; i < MEASURE_DATA.size() ;i++){
	if (MEASURE_Max_Map.containsKey(bubble.get(i))){
		if (MEASURE_DATA.get(i) > MEASURE_Max_Map.get(bubble.get(i))){
			MEASURE_Max_Map.put(bubble.get(i), MEASURE_DATA.get(i));
		}
	} else {
		MEASURE_Max_Map.put(bubble.get(i), MEASURE_DATA.get(i));
	}

	if (MEASURE_Min_Map.containsKey(bubble.get(i))){
		if (MEASURE_DATA.get(i) < MEASURE_Min_Map.get(bubble.get(i))){
			MEASURE_Min_Map.put(bubble.get(i), MEASURE_DATA.get(i));
		}
	} else {
		MEASURE_Min_Map.put(bubble.get(i), MEASURE_DATA.get(i));
	}
}
%>

<div id='header2'>試模資料整理</div>

<div>
<button id="button0">欄位0</button>
<button id="button1">欄位1</button>
<table id="example" class="cell-border hover" style="width:100%">
        <thead>
            <tr>
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
                <th>檢驗時間</th>
            </tr>
        </thead>
        <tbody>
        <% for( int i=0 ; i < ISSUE_NO.size() ;i++){
        %>
            <tr>
                <td><%= ISSUE_TYPE %></td>
                <td><%= grade.get(i) %></td>
                <td><%= bubble.get(i) %></td>
                <td><%= df.format(TOLER_UP.get(i)+DESIGN_DATA.get(i)) %></td>
                <td><%= df.format(DESIGN_DATA.get(i)) %></td>
                <td><%= df.format(TOLER_DOWN.get(i)+DESIGN_DATA.get(i)) %></td>
                <td><%= TOLER_UP.get(i) %>/<%= TOLER_DOWN.get(i) %></td>
                <td><%= df.format(MEASURE_Max_Map.get(bubble.get(i))) %>~<%= df.format(MEASURE_Min_Map.get(bubble.get(i))) %></td>
                <td><%= PRODUCT_ID %></td>
                <td><%= WORDER_ID %></td>
                <td>NG</td>
                <td><%= QC_TIME.get(i) %></td>
            </tr>
        <% } %>
        </tbody>
        <tfoot>
            <tr>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th style="visibility:hidden">ISSUE_NO</th>
                <th>QC_TIME</th>
        </tfoot>
    </table>

</div>
<script>
function refreshBTNTable(btnID) {
	//alert ("tableID="+tableID);
	//alert ("colNo="+colNo);
	//alert ("btnID="+btnID);

	var btn = document.getElementById(btnID);
	var style = getComputedStyle(btn);
	//alert ("status="+style['background-color']);
	
	var disableStyle = 'rgb(133, 133, 133)';
	var enableStyle = 'rgb(39, 174, 163)';
	
	if (style['background-color']==disableStyle){
		//alert ("disable to enable");
		btn.style.background=enableStyle;
	} else if (style['background-color']==enableStyle){
		//alert ("enable to disable");
		btn.style.background=disableStyle;
	}
}
</script>
</body>

</html>