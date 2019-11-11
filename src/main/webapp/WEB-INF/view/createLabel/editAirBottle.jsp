<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>编辑</title>
<%@include file="js.jsp"%>
<script type="text/javascript">
$(function(){
	$("#edit_div").dialog({
		title:"编辑",
		width:setFitWidthInParent("body"),
		height:setFitHeightInParent(".layui-side"),
		top:60,
		left:200,
		buttons:[
           {text:"提交",id:"ok_but",iconCls:"icon-ok",handler:function(){
       	   	    checkEdit();
           }}
        ]
	});
	
	$("#edit_div table").css("width","1000px");
	$("#edit_div table").css("magin","-100px");
	$("#edit_div table td").css("padding-left","50px");
	$("#edit_div table td").css("padding-right","20px");
	$("#edit_div table td").css("font-size","15px");
	$("#edit_div table tr").css("height","45px");
	$("#edit_div table tr").each(function(){
		$(this).find("td").eq(0).css("color","#006699");
		$(this).find("td").eq(0).css("border-right","#CAD9EA solid 1px");
		$(this).find("td").eq(0).css("font-weight","bold");
		$(this).find("td").eq(0).css("background-color","#F5FAFE");
	});

	$("#edit_div table tr").mousemove(function(){
		$(this).css("background-color","#ddd");
	}).mouseout(function(){
		$(this).css("background-color","#fff");
	});

	$(".panel.window").css("width","983px");
	$(".panel.window").css("margin-top","20px");
	$(".panel.window").css("margin-left",initWindowMarginLeft());
	$(".panel.window").css("background","linear-gradient(to bottom,#E7F4FD 0,#E7F4FD 20%)"); 
	$(".panel.window .panel-title").css("color","#000");
	$(".panel.window .panel-title").css("font-size","15px");
	$(".panel.window .panel-title").css("padding-left","10px");
	
	$(".panel-header, .panel-body").css("border-color","#ddd");
	
	//以下的是表格下面的面板
	$(".window-shadow").css("width","1000px");
	$(".window-shadow").css("margin-top","20px");
	$(".window-shadow").css("margin-left",initWindowMarginLeft());
	$(".window-shadow").css("background","#E7F4FD");
	
	$(".window,.window .window-body").css("border-color","#ddd");
	
	$("#ok_but").css("left","45%");
	$("#ok_but").css("position","absolute");
	$(".dialog-button").css("background-color","#fff");
	$(".dialog-button .l-btn-text").css("font-size","20px");
});

function checkEdit(){
	if(checkZl()){
		if(checkSCRJ()){
			if(checkQPZJXH()){
				editAirBottle();
			}
		}
	}
}

function editAirBottle(){
	var id=$("#id").val();
	var zl=$("#zl").val();
	var scrj=$("#scrj").val();
	var qpzjxh=$("#qpzjxh").val();
	
	$.post("editAirBottle",
		{id:id,zl:zl,scrj:scrj,qpzjxh:qpzjxh},
		function(data){
			if(data.message=="ok"){
				alert(data.info);
				history.go(-1);
			}
			else{
				alert(data.info);
			}
		}
	,"json");
}

function focusZl(){
	var zl = $("#zl").val();
	if(zl=="重量不能为空"){
		$("#zl").val("");
		$("#zl").css("color", "#555555");
	}
}

//验证重量
function checkZl(){
	var zl = $("#zl").val();
	if(zl==null||zl==""||zl=="重量不能为空"){
		$("#zl").css("color","#E15748");
    	$("#zl").val("重量不能为空");
    	return false;
	}
	else
		return true;
}

function focusSCRJ(){
	var scrj = $("#scrj").val();
	if(zl=="实测容积不能为空"){
		$("#scrj").val("");
		$("#scrj").css("color", "#555555");
	}
}

//验证实测容积
function checkSCRJ(){
	var scrj = $("#scrj").val();
	if(scrj==null||scrj==""||scrj=="实测容积不能为空"){
		$("#scrj").css("color","#E15748");
    	$("#scrj").val("实测容积不能为空");
    	return false;
	}
	else
		return true;
}

function focusQPZJXH(){
	var qpzjxh = $("#qpzjxh").val();
	if(qpzjxh=="气瓶支架型号不能为空"){
		$("#qpzjxh").val("");
		$("#qpzjxh").css("color", "#555555");
	}
}

//验证气瓶支架型号
function checkQPZJXH(){
	var qpzjxh = $("#qpzjxh").val();
	if(qpzjxh==null||qpzjxh==""||qpzjxh=="气瓶支架型号不能为空"){
		$("#qpzjxh").css("color","#E15748");
    	$("#qpzjxh").val("气瓶支架型号不能为空");
    	return false;
	}
	else
		return true;
}

function setFitWidthInParent(o){
	var width=$(o).css("width");
	return width.substring(0,width.length-2)-200;
}

function setFitHeightInParent(o){
	var height=$(o).css("height");
	return height.substring(0,height.length-2)-98;
}

function initWindowMarginLeft(){
	var editDivWidth=$("#edit_div").css("width");
	editDivWidth=editDivWidth.substring(0,editDivWidth.length-2);
	var pwWidth=$(".panel.window").css("width");
	pwWidth=pwWidth.substring(0,pwWidth.length-2);
	return ((editDivWidth-pwWidth)/2)+"px";
}
</script>
</head>
<body>
<div class="layui-layout layui-layout-admin">
	<%@include file="side.jsp"%>
	<div id="edit_div">
		<form id="form1" name="form1" method="post" action="editAirBottle" enctype="multipart/form-data">
		<input type="hidden" id="id" name="id" value="${requestScope.airBottle.id }"/>
		<table>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				产品型号
			</td>
			<td>
				<span>${requestScope.airBottle.cpxh }</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				气瓶编号
			</td>
			<td>
				<span>${requestScope.airBottle.qpbh }</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				公称容积
			</td>
			<td>
				<span>${requestScope.airBottle.gcrj }</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				内胆壁厚
			</td>
			<td>
				<span>${requestScope.airBottle.ndbh }</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				重量
			</td>
			<td>
				<input type="text" id="zl" name="zl" size="4" value="${requestScope.airBottle.zl }" />
				<span style="color: #f00;">*</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				实测容积
			</td>
			<td>
				<input type="text" id="scrj" name="scrj" size="4" value="${requestScope.airBottle.scrj }" />
				<span style="color: #f00;">*</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				气瓶支架型号
			</td>
			<td>
				<input type="text" id="qpzjxh" name="qpzjxh" value="${requestScope.airBottle.qpzjxh }" onfocus="focusSort()" onblur="checkSort()"/>
				<span style="color: #f00;">*</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				制造日期
			</td>
			<td>
				<span>${requestScope.airBottle.zzrq }</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				气瓶制造单位
			</td>
			<td>
				<span>${requestScope.airBottle.qpzzdw }</span>
			</td>
		  </tr>
		</table>
		</form>
	</div>
	<%@include file="foot.jsp"%>
</div>
</body>
</html>