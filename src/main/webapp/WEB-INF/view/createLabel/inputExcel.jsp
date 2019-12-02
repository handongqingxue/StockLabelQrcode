<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>导入检测数据</title>
<%@include file="js.jsp"%>
<script type="text/javascript">
var path='<%=basePath %>';
$(function(){
	$("#search_but").linkbutton({
		iconCls:"icon-search",
		onClick:function(){
			var qpbh=$("#qpbh_inp").val();
			tab1.datagrid("load",{qpbh:qpbh});
		}
	});

	$("#inputExcel_but").linkbutton({
		iconCls:"icon-back",
		onClick:function(){
			inputExcelByQpbh();
		}
	});
	
	$("#batchIE_but").linkbutton({
		iconCls:"icon-back",
		onClick:function(){
			openBatchInputDiv(1);
		}
	});
	
	tab1=$("#tab1").datagrid({
		title:"历史记录查询",
		url:"queryAirBottleList",
		toolbar:"#toolbar",
		width:setFitWidthInParent("body"),
		singleSelect:true,
		pagination:true,
		pageSize:10,
		columns:[[
            {field:"cpxh_qc",title:"产品型号（全称）",width:150,sortable:true},
            {field:"qpbh",title:"气瓶编号",width:150,sortable:true},
            {field:"gcrj",title:"公称容积",width:80,sortable:true},
            {field:"ndbh",title:"内胆壁厚",width:80,sortable:true},
            {field:"zl",title:"重量",width:80,sortable:true},
            {field:"scrj",title:"实测容积",width:80,sortable:true},
            {field:"qpzjxh",title:"气瓶支架型号",width:100,sortable:true},
            {field:"zzrq",title:"制造日期",width:100,sortable:true},
            {field:"qpzzdw",title:"气瓶制造单位",width:300,sortable:true},
            {field:"id",title:"操作",width:100,formatter:function(value,row){
            	return "<a href=\"${pageContext.request.contextPath}/createLabel/goEditAirBottle?id="+value+"\">编辑</a>";
            }}
        ]],
        onLoadSuccess:function(data){
			if(data.total==0){
				$(this).datagrid("appendRow",{cpxh:"<div style=\"text-align:center;\">暂无分类</div>"});
				$(this).datagrid("mergeCells",{index:0,field:"cpxh",colspan:10});
				data.total=0;
			}
			
			resetTabStyle();
		}
	});
	
	batInpDialog=$("#batchInput_div").dialog({
		title:"批量导入",
		width:370,
		height:200,
		top:250,
		left:400,
		buttons:[
           {text:"确定",id:"ok_but",iconCls:"icon-ok",handler:function(){
        	   batchInputExcel();
           }},
           {text:"取消",id:"cancel_but",iconCls:"icon-cancel",handler:function(){
        	   openBatchInputDiv(0);
           }}
        ]
	});
	
	$("#batchInput_div table").css("width","350px");
	$("#batchInput_div table").css("magin","-100px");
	$("#batchInput_div table td").css("padding-left","10px");
	$("#batchInput_div table td").css("padding-right","10px");
	$("#batchInput_div table td").css("font-size","15px");
	
	$("#batchInput_div table tr").each(function(){
		$(this).find("td").eq(0).css("color","#006699");
		$(this).find("td").eq(0).css("border-right","#CAD9EA solid 1px");
		$(this).find("td").eq(0).css("font-weight","bold");
		$(this).find("td").eq(0).css("background-color","#F5FAFE");
	});

	$("#batchInput_div table tr").mousemove(function(){
		$(this).css("background-color","#ddd");
	}).mouseout(function(){
		$(this).css("background-color","#fff");
	});
	
	$(".panel.window").css("width","353px");
	$(".panel.window").css("margin-top","20px");
	$(".panel.window").css("margin-left","300px");
	$(".panel.window").css("background","linear-gradient(to bottom,#E7F4FD 0,#E7F4FD 20%)"); 
	
	$(".panel-header, .panel-body").css("border-color","#ddd");
	
	resetWindowShadow();
	
	$(".dialog-button").css("background-color","#fff");
	$(".dialog-button .l-btn-text").css("font-size","20px");
	
	openBatchInputDiv(0);
	
	tab2=$("#tab2").datagrid({
		title:"Excel数据",
		//url:"queryAirBottleList",
		//toolbar:"#toolbar",
		width:setFitWidthInParent("body"),
		height:300,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		columns:[[
            {field:"cpxh_qc",title:"产品型号（全称）",width:150,sortable:true},
            {field:"qpbh",title:"气瓶编号",width:150,sortable:true},
            {field:"zl",title:"重量",width:80,sortable:true},
            {field:"scrj",title:"实测容积",width:80,sortable:true},
            {field:"qpzjxh",title:"气瓶支架型号",width:100,sortable:true},
            {field:"qpzzdw",title:"气瓶制造单位",width:300,sortable:true}
        ]]
	});
	tab2.datagrid("appendRow",{cpxh:"<div style=\"text-align:center;\">暂无数据</div>"});
	tab2.datagrid("mergeCells",{index:0,field:"cpxh",colspan:6});
});

function inputExcelByQpbh(){
	var row=tab1.datagrid("getSelected");
	if (row==null) {
		$.messager.alert("提示","请选择要更新的信息！","warning");
		return false;
	}
	
	$.messager.confirm("提示","确定要更新吗？",function(r){
		if(r){
			//$.ajaxSetup({async:false});
			$.post("updateAirBottleRecord", 
				{qpbhsStr:row.qpbh,qpJAStr:getQPJAStr()},
				function(data) {
					if(data.status==1){
						alert(data.msg);
						tab1.datagrid("load");
					}
					else{
						alert(data.msg);
					}
				}
			, "json");
			
		}
	});
}

function batchInputExcel(){
	if(checkQpQsBh()){
	   if(checkQpJsBh()){
 		   var qpqsbh=$("#qpqsbh_inp").val();
 		   var qpjsbh=$("#qpjsbh_inp").val();
 		   var qpqsbhPre=qpqsbh.substring(0,7);
 		   var qpqsbhSuf=qpqsbh.substring(7,qpqsbh.length);
 		   qpjsbh=qpjsbh.substring(7,qpjsbh.length);
 		   var qpbhsStr="";
 		   for(var i = qpqsbhSuf;i <= qpjsbh;i++){
                var qpbhSuf;
                qpbhSuf=i+"";
                if(qpbhSuf.length==2)
             	    qpbhSuf="0"+i;
                else if(qpbhSuf.length==1)
             	    qpbhSuf="00"+i;
                var qpbh=qpqsbhPre+qpbhSuf;
                qpbhsStr+=","+qpbh;
 		   }
 		   
 		   $.post("updateAirBottleRecord",
			   {qpbhsStr:qpbhsStr.substring(1),qpJAStr:getQPJAStr()},
			   function(data){
				   if(data.status==1){
					  alert(data.msg);
					  openBatchInputDiv(0);
					  tab1.datagrid("load");
				   }
				   else{
					  alert(data.msg);
				   }
 		   	   }
 		   ,"json");
	   }
    }
}

function getQPJAStr(){
	var qpJAStr="[";
	var rows = tab2.datagrid("getRows");
	for(var i=0;i<rows.length;i++){
		if(i>0)
			qpJAStr+=",";
        qpJAStr+="{'cpxh_qc':'"+rows[i].cpxh_qc+"','qpbh':'"+rows[i].qpbh+"','zl':'"+rows[i].zl+"','scrj':'"+rows[i].scrj+"','qpzjxh':'"+rows[i].qpzjxh+"','qpzzdw':'"+rows[i].qpzzdw+"'}";
	}
	qpJAStr+="]";
	return qpJAStr;
}

function openBatchInputDiv(flag){
	batInpDialog.dialog({
        closed: flag==1?false:true
    })
    if(flag==1)
       resetWindowShadow();
}

function resetWindowShadow(){
	$(".panel.window .panel-title").css("color","#000");
	$(".panel.window .panel-title").css("font-size","15px");
	$(".panel.window .panel-title").css("padding-left","10px");
	
	//以下的是表格下面的面板
	$(".window-shadow").css("width","370px");
	$(".window-shadow").css("margin-top","20px");
	$(".window-shadow").css("margin-left","300px");
	$(".window-shadow").css("background","#E7F4FD");
	$(".window,.window .window-body").css("border-color","#ddd");

	$("#ok_but").css("left","30%");
	$("#ok_but").css("position","absolute");
	
	$("#cancel_but").css("left","60%");
	$("#cancel_but").css("position","absolute");
}

function resetTabStyle(){
	$(".panel.datagrid").css("margin-left",initTab1WindowMarginLeft());
	
	$(".panel.datagrid .panel-header").css("background","linear-gradient(to bottom,#E7F4FD 0,#E7F4FD 20%)");
	$(".panel.datagrid .panel-header .panel-title").css("color","#000");
	$(".panel.datagrid .panel-header .panel-title").css("font-size","15px");
	$(".panel.datagrid .panel-header .panel-title").css("padding-left","10px");
	
	$(".panel.datagrid .datagrid-toolbar").css("background","#F5FAFE");
	$(".panel.datagrid .datagrid-header-row").css("background","#E7F4FD");
	$(".panel.datagrid .datagrid-pager.pagination").css("background","#F5FAFE");
}

function focusQpQsBh(){
	var qpqsbh = $("#qpqsbh_inp").val();
	if(qpqsbh=="气瓶起始编号不能为空"){
		$("#qpqsbh_inp").val("");
		$("#qpqsbh_inp").css("color", "#555555");
	}
}

//验证气瓶起始编号
function checkQpQsBh(){
	var qpqsbh = $("#qpqsbh_inp").val();
	if(qpqsbh==null||qpqsbh==""||qpqsbh=="气瓶起始编号不能为空"){
		$("#qpqsbh_inp").css("color","#E15748");
    	$("#qpqsbh_inp").val("气瓶起始编号不能为空");
    	return false;
	}
	else
		return true;
}

function focusQpJsBh(){
	var qpjsbh = $("#qpjsbh_inp").val();
	if(qpjsbh=="气瓶结束编号不能为空"){
		$("#qpjsbh_inp").val("");
		$("#qpjsbh_inp").css("color", "#555555");
	}
}

//验证气瓶结束编号
function checkQpJsBh(){
	var qpjsbh = $("#qpjsbh_inp").val();
	if(qpjsbh==null||qpjsbh==""||qpjsbh=="气瓶结束编号不能为空"){
		$("#qpjsbh_inp").css("color","#E15748");
    	$("#qpjsbh_inp").val("气瓶结束编号不能为空");
    	return false;
	}
	else
		return true;
}

function loadExcelTab(obj){
	/*
	//var file=$(obj);
	//var fileHtml=file.prop("outerHTML");
	var $file = $(obj);
    var fileObj = $file[0];
    file=$file;
    var windowURL = window.URL || window.webkitURL;
    var dataURL;
    if (fileObj && fileObj.files && fileObj.files[0]) {
        dataURL = windowURL.createObjectURL(fileObj.files[0]);
    } else {
        dataURL = $file.val();
        var imgObj = document.getElementById("preview");
        // 两个坑:
        // 1、在设置filter属性时，元素必须已经存在在DOM树中，动态创建的Node，也需要在设置属性前加入到DOM中，先设置属性在加入，无效；
        // 2、src属性需要像下面的方式添加，上面的两种方式添加，无效；
        imgObj.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale)";
        imgObj.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = dataURL;

    }
	console.log(fileObj.files[0]);
	*/
	
	var formData = new FormData($("#form1")[0]);
	 
	$.ajax({
		type:"post",
		url:"loadExcelData",
		//dataType: "json",
		data:formData,
		cache: false,
		processData: false,
		contentType: false,
		success: function (result){
			var resultJO=JSON.parse(result);
			var data=resultJO.data;
			//console.log(data);
			if(resultJO.status==1){
				//var data={"total":2,"rows":[{cpxh:"1",qpbh:"一"},{cpxh:"2",qpbh:"二"}]};
				tab2.datagrid('loadData',JSON.parse(result).data);
			}
			else{
				alert(data.msg);
			}
		}
	});
}

function setFitWidthInParent(o){
	var width=$(o).css("width");
	return width.substring(0,width.length-2)-210;
}

function initTab1WindowMarginLeft(){
	var tab1DivWidth=$("#tab1_div").css("width");
	tab1DivWidth=tab1DivWidth.substring(0,tab1DivWidth.length-2);
	var pdWidth=$(".panel.datagrid").css("width");
	pdWidth=pdWidth.substring(0,pdWidth.length-2);
	return ((tab1DivWidth-pdWidth)/2)+"px";
}
</script>
</head>
<body>
<div class="layui-layout layui-layout-admin">
	<%@include file="top.jsp"%>
	<%@include file="left.jsp"%>
	<div id="tab1_div" style="margin-top:20px;margin-left: 200px;">
		<div id="toolbar">
			气瓶编号：<input type="text" id="qpbh_inp"/>
			<a id="search_but">查询</a>
			<form id="form1">
				<input type="file" id="excel_file" name="excel_file" onchange="loadExcelTab(this)"/>
				<input type="hidden" id="qpbhsStr" name="qpbhsStr"/>
			</form>
			<a id="inputExcel_but">导入</a>
			<a id="batchIE_but">批量导入</a>
			
			<!-- 
			<a id="input_but">导入Excel</a>
			<a id="previewPdf_but">预览Pdf</a>
			 -->
		</div>
		<table id="tab1">
		</table>
		<table id="tab2">
		</table>
	</div>
	<div id="batchInput_div">
		<table>
			<tr style="height: 45px;">
				<td>气瓶起始编号：</td>
				<td>
					<input id="qpqsbh_inp" name="" type="text" maxlength="20" placeholder="例如:CB19001001" onfocus="focusQpQsBh()" onblur="checkQpQsBh()"/>
					<span style="color: #f00;">*</span>
				</td>
			</tr>
			<tr style="height: 45px;">
				<td>气瓶结束编号：</td>
				<td>
					<input id="qpjsbh_inp" name="" type="text" maxlength="20" placeholder="例如:CB19001003" onfocus="focusQpJsBh()" onblur="checkQpJsBh()"/>
					<span style="color: #f00;">*</span>
				</td>
			</tr>
		</table>
	</div>
	<%@include file="foot.jsp"%>
</div>
</body>
</html>