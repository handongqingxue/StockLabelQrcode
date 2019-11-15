<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>批次查询</title>
<%@include file="js.jsp"%>
<script type="text/javascript">
var path='<%=basePath %>';
$(function(){
	$("#search_but").linkbutton({
		iconCls:"icon-search",
		onClick:function(){
			var cpxh=$("#cpxh_inp").val();
			var qpbh=$("#qpbh_inp").val();
			var qpzjxh=$("#qpzjxh_inp").val();
			var zzrq=$("#zzrq_inp").val();
			var qpzzdw=$("#qpzzdw_inp").val();
			tab1.datagrid("load",{cpxh:cpxh,qpbh:qpbh,qpzjxh:qpzjxh,zzrq:zzrq,qpzzdw:qpzzdw});
		}
	});
	
	tab1=$("#tab1").datagrid({
		title:"批次查询",
		url:"queryBatchList",
		toolbar:"#toolbar",
		width:setFitWidthInParent("body"),
		singleSelect:true,
		pagination:true,
		pageSize:20,
		columns:[[
            {field:"cpxh",title:"产品型号",width:100,sortable:true},
            {field:"qpbh",title:"气瓶编号",width:150,sortable:true},
            {field:"gcrj",title:"公称容积",width:80,sortable:true},
            {field:"ndbh",title:"内胆壁厚",width:80,sortable:true},
            {field:"zl",title:"重量",width:80,sortable:true},
            {field:"scrj",title:"实测容积",width:80,sortable:true},
            {field:"qpzjxh",title:"气瓶支架型号",width:100,sortable:true},
            {field:"zzrq",title:"制造日期",width:100,sortable:true},
            {field:"qpzzdw",title:"气瓶制造单位",width:300,sortable:true}
        ]],
        onLoadSuccess:function(data){
			if(data.total==0){
				$(this).datagrid("appendRow",{cpxh:"<div style=\"text-align:center;\">暂无分类</div>"});
				$(this).datagrid("mergeCells",{index:0,field:"cpxh",colspan:9});
				data.total=0;
			}
			
			resetTabStyle();
		}
	});
});

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
			产品型号：<input type="text" id="cpxh_inp"/>
			气瓶编号：<input type="text" id="qpbh_inp"/>
			气瓶支架型号：<input type="text" id="qpzjxh_inp"/>
			制造日期：<input type="text" id="zzrq_inp"/>
			气瓶制造单位：<input type="text" id="qpzzdw_inp"/>
			<a id="search_but">查询</a>
		</div>
		<table id="tab1">
		</table>
	</div>
	<%@include file="foot.jsp"%>
</div>
</body>
</html>