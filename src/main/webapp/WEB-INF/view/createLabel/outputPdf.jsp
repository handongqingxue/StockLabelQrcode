<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>导出Pdf</title>
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
	
	$("#previewPdf_but").linkbutton({
		iconCls:"icon-back",
		onClick:function(){
			previewPdf();
		}
	});
	
	$("#batPrePdf_but").linkbutton({
		iconCls:"icon-back",
		onClick:function(){
			openBatchOutputDiv(1);
		}
	});

	tab1=$("#tab1").datagrid({
		title:"可导出Pdf的数据",
		url:"queryAirBottleList",
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
	
	initBatOutpDialog();
	
	initPrePdfDialog();
	
	$(".dialog-button").css("background-color","#fff");
	$(".dialog-button .l-btn-text").css("font-size","20px");
});

function previewPdf(){
	var row=tab1.datagrid("getSelected");
	if (row==null) {
		$.messager.alert("提示","请选择要预览的Pdf信息！","warning");
		return false;
	}
	
	$.post("selectCRSPdfSet",
		{labelType:row.label_type,accountNumber:'${sessionScope.user.id}'},
		function(data){
			console.log(data);
			var crsPdfSet=data.crsPdfSet;
			var id=crsPdfSet.id;
			var cpxhLeft=crsPdfSet.cpxh_left;
			var cpxhTop=crsPdfSet.cpxh_top;
			var qpbhLeft=crsPdfSet.qpbh_left;
			var qpbhTop=crsPdfSet.qpbh_top;
			var gcrjLeft=crsPdfSet.gcrj_left;
			var gcrjTop=crsPdfSet.gcrj_top;
			var ndbhLeft=crsPdfSet.ndbh_left;
			var ndbhTop=crsPdfSet.ndbh_top;
			var zzrqLeft=crsPdfSet.zzrq_left;
			var zzrqTop=crsPdfSet.zzrq_top;
			var qrcodeLeft=crsPdfSet.qrcode_left;
			var qrcodeTop=crsPdfSet.qrcode_top;
			
			var pdfDiv=$("#pdf_div");
			pdfDiv.empty();
			pdfDiv.append("<input id=\"id_hid\" type=\"hidden\" value=\""+id+"\"/>"
					+"<img id=\"qrcode_img\" alt=\"\" src=\""+row.qrcode_url+"\" style=\"width: 180px;height: 180px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
					+"<span id=\"cpxh_span\" style=\"margin-top: "+cpxhTop+"px;margin-left: "+cpxhLeft+"px;position: absolute;\">"+row.cpxh+"</span>"
					+"<span id=\"qpbh_span\" style=\"margin-top: "+qpbhTop+"px;margin-left: "+qpbhLeft+"px;position: absolute;\">"+row.qpbh+"</span>"
					+"<span id=\"gcrj_span\" style=\"margin-top: "+gcrjTop+"px;margin-left: "+gcrjLeft+"px;position: absolute;\">"+row.gcrj+"</span>"
					+"<span id=\"ndbh_span\" style=\"margin-top: "+ndbhTop+"px;margin-left: "+ndbhLeft+"px;position: absolute;\">"+row.ndbh+"</span>"
					+"<span id=\"zzrq_span\" style=\"margin-top: "+zzrqTop+"px;margin-left: "+zzrqLeft+"px;position: absolute;\">"+row.zzrq+"</span>");
		}
	,"json");
}

function initBatOutpDialog(){
	batOutpDialog=$("#batchOutput_div").dialog({
		title:"批量导出",
		width:370,
		height:200,
		top:250,
		left:400,
		buttons:[
           {text:"确定",id:"ok_but",iconCls:"icon-ok",handler:function(){
        	   batchInputExcel();
           }},
           {text:"取消",id:"cancel_but",iconCls:"icon-cancel",handler:function(){
        	   openBatchOutputDiv(0);
           }}
        ]
	});

	$("#batchOutput_div table").css("width","350px");
	$("#batchOutput_div table").css("magin","-100px");
	$("#batchOutput_div table td").css("padding-left","10px");
	$("#batchOutput_div table td").css("padding-right","10px");
	$("#batchOutput_div table td").css("font-size","15px");
	
	$("#batchOutput_div table tr").each(function(){
		$(this).find("td").eq(0).css("color","#006699");
		$(this).find("td").eq(0).css("border-right","#CAD9EA solid 1px");
		$(this).find("td").eq(0).css("font-weight","bold");
		$(this).find("td").eq(0).css("background-color","#F5FAFE");
	});

	$("#batchOutput_div table tr").mousemove(function(){
		$(this).css("background-color","#ddd");
	}).mouseout(function(){
		$(this).css("background-color","#fff");
	});

	$(".panel.window").eq(0).css("width","353px");
	$(".panel.window").eq(0).css("margin-top","20px");
	$(".panel.window").eq(0).css("margin-left","300px");
	$(".panel.window").eq(0).css("background","linear-gradient(to bottom,#E7F4FD 0,#E7F4FD 20%)"); 
	
	$(".panel-header, .panel-body").eq(0).css("border-color","#ddd");

	openBatchOutputDiv(0);
	//resetBatOutWindowShadow();
}

function initPrePdfDialog(){
	previewPdfDialog=$("#previewPdf_div").dialog({
		title:"预览Pdf",
		width:570,
		height:400,
		top:80,
		left:850,
		buttons:[
           {text:"导出Pdf",id:"output_but",iconCls:"icon-ok",handler:function(){
        	   batchInputExcel();
           }},
           {text:"取消",id:"canPre_but",iconCls:"icon-cancel",handler:function(){
        	   openBatchOutputDiv(0);
           }}
        ]
	});
	
	$("#previewPdf_div #pdf_div").css("width","570px");
	
	$(".panel.window").eq(1).css("width","553px");
	$(".panel.window").eq(1).css("margin-top","20px");
	$(".panel.window").eq(1).css("margin-left","300px");
	$(".panel.window").eq(1).css("background","linear-gradient(to bottom,#E7F4FD 0,#E7F4FD 20%)"); 
	
	$(".panel-header, .panel-body").eq(1).css("border-color","#ddd");
	
	resetPrePdfWindowShadow();
}

function openBatchOutputDiv(flag){
	batOutpDialog.dialog({
        closed: flag==1?false:true
    })
    if(flag==1)
    	resetBatOutWindowShadow();
}

function resetBatOutWindowShadow(){
	$(".panel.window").eq(0).find(".panel-title").css("color","#000");
	$(".panel.window").eq(0).find(".panel-title").css("font-size","15px");
	$(".panel.window").eq(0).find(".panel-title").css("padding-left","10px");
	
	//以下的是表格下面的面板
	$(".window-shadow").eq(0).css("width","370px");
	$(".window-shadow").eq(0).css("margin-top","20px");
	$(".window-shadow").eq(0).css("margin-left","300px");
	$(".window-shadow").eq(0).css("background","#E7F4FD");
	$(".window,.window .window-body").css("border-color","#ddd");

	$("#ok_but").css("left","30%");
	$("#ok_but").css("position","absolute");
	
	$("#cancel_but").css("left","60%");
	$("#cancel_but").css("position","absolute");
}

function resetPrePdfWindowShadow(){
	$(".panel.window").eq(1).find(".panel-title").css("color","#000");
	$(".panel.window").eq(1).find(".panel-title").css("font-size","15px");
	$(".panel.window").eq(1).find(".panel-title").css("padding-left","10px");
	
	//以下的是表格下面的面板
	$(".window-shadow").eq(1).css("width","570px");
	$(".window-shadow").eq(1).css("margin-top","20px");
	$(".window-shadow").eq(1).css("margin-left","300px");
	$(".window-shadow").eq(1).css("background","#E7F4FD");
	$(".window,.window .window-body").css("border-color","#ddd");

	$("#output_but").css("left","30%");
	$("#output_but").css("position","absolute");
	
	$("#canPre_but").css("left","60%");
	$("#canPre_but").css("position","absolute");
}

function resetTabStyle(){
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
	return width.substring(0,width.length-2)-810;
}
</script>
</head>
<body>
<div class="layui-layout layui-layout-admin">
	<%@include file="top.jsp"%>
	<div id="tab1_div" style="margin-top:20px;margin-left: 20px;">
		<div id="toolbar">
			气瓶编号：<input type="text" id="qpbh_inp"/>
			<a id="search_but">查询</a>
			<a id="previewPdf_but">预览标签Pdf</a>
			<a id="batPrePdf_but">批量预览标签Pdf</a>
		</div>
		<table id="tab1">
		</table>
		<table id="tab2">
		</table>
	</div>
	<div id="batchOutput_div">
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
	<div id="previewPdf_div">
		<div id="pdf_div" style="width:400px;height: 300px;border:#000 solid 1px;">
			<!-- 
			 <img alt="" src="<%=basePath %>/resource/images/qrcode.png" style="width: 80px;height: 80px;margin-top: 10px;margin-left: 300px;position: absolute;">
		     <span style="margin-top: 20px;margin-left: 150px;position: absolute;">356-70</span>
		     <span style="margin-top: 40px;margin-left: 90px;position: absolute;">CB190</span>
		     <span style="margin-top: 90px;margin-left: 210px;position: absolute;">70L</span>
		     <span style="margin-top: 140px;margin-left: 120px;position: absolute;">5.0</span>
		     <span style="margin-top: 190px;margin-left: 210px;position: absolute;">2019&nbsp;&nbsp;&nbsp;&nbsp;1</span>
		      -->
		</div>
	</div>
	<%@include file="foot.jsp"%>
</div>
</body>
</html>