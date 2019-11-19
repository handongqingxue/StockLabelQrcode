<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>导出Pdf</title>
<%@include file="js.jsp"%>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/jspdf.debug.js"></script>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/html2canvas.min.js"></script>
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
			var zzrqYLeft=crsPdfSet.zzrq_y_left;
			var zzrqYTop=crsPdfSet.zzrq_y_top;
			
			var zzrqMLeft=crsPdfSet.zzrq_m_left;
			var zzrqMTop=crsPdfSet.zzrq_m_top;
			var qrcodeLeft=crsPdfSet.qrcode_left;
			var qrcodeTop=crsPdfSet.qrcode_top;
			
			var pdfDiv=$("#pdf_div");
			pdfDiv.empty();
			pdfDiv.append("<input id=\"id_hid\" type=\"hidden\" value=\""+id+"\"/>"
					+"<img id=\"qrcode_img\" alt=\"\" src=\""+row.qrcode_crs_url+"\" style=\"width: 120px;height: 120px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
					+"<span id=\"cpxh_span\" style=\"margin-top: "+cpxhTop+"px;margin-left: "+cpxhLeft+"px;position: absolute;\">"+row.cpxh+"</span>"
					+"<span id=\"qpbh_span\" style=\"margin-top: "+qpbhTop+"px;margin-left: "+qpbhLeft+"px;position: absolute;\">"+row.qpbh+"</span>"
					+"<span id=\"gcrj_span\" style=\"margin-top: "+gcrjTop+"px;margin-left: "+gcrjLeft+"px;position: absolute;\">"+row.gcrj+"</span>"
					+"<span id=\"ndbh_span\" style=\"margin-top: "+ndbhTop+"px;margin-left: "+ndbhLeft+"px;position: absolute;\">"+row.ndbh+"</span>"
					+"<span id=\"zzrqY_span\" style=\"margin-top: "+zzrqYTop+"px;margin-left: "+zzrqYLeft+"px;position: absolute;\">"+row.zzrq_y+"</span>"
					+"<span id=\"zzrqM_span\" style=\"margin-top: "+zzrqMTop+"px;margin-left: "+zzrqMLeft+"px;position: absolute;\">"+row.zzrq_m+"</span>");
		}
	,"json");
}

function prePdfByQpbhs(){
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
 		   
 		   $.post("selectAirBottleByQpbhs",
			   {qpbhsStr:qpbhsStr.substring(1)},
			   function(result){
				   if(result.status==1){
					  openBatchOutputDiv(0);
					  window.open("toPreviewCRSPdf?uuid="+result.data,"newwindow","width=300;");
				   }
				   else{
					  alert(result.msg);
				   }
 		   	   }
 		   ,"json");
	   }
    }
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

function initBatOutpDialog(){
	batOutpDialog=$("#batchOutput_div").dialog({
		title:"批量导出",
		width:370,
		height:200,
		top:250,
		left:400,
		buttons:[
           {text:"确定",id:"ok_but",iconCls:"icon-ok",handler:function(){
        	   prePdfByQpbhs();
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
		width:520,
		height:400,
		top:80,
		left:850,
		buttons:[
           {text:"导出Pdf",id:"output_but",iconCls:"icon-ok",handler:function(){
        	   outputPdf();
           }},
           {text:"取消",id:"canPre_but",iconCls:"icon-cancel",handler:function(){
        	   openBatchOutputDiv(0);
           }}
        ]
	});
	
	$("#previewPdf_div #pdf_div").css("width","500px");
	
	$(".panel.window").eq(1).css("width","513px");
	$(".panel.window").eq(1).css("margin-top","20px");
	$(".panel.window").eq(1).css("margin-left","300px");
	$(".panel.window").eq(1).css("background","linear-gradient(to bottom,#E7F4FD 0,#E7F4FD 20%)"); 
	
	$(".panel-header, .panel-body").eq(1).css("border-color","#ddd");
	
	resetPrePdfWindowShadow();
}

function checkPreviewPdfHtml(){
	var pdfHtml=$("#pdf_div").html();
    if(pdfHtml.trim()==""){
	    alert("请先生成预览！");
	    return false;
    }
    else
	    return true;
}

function outputPdf(){
	if(checkPreviewPdfHtml()){
	   	$("#pdf_div").css("border","0px");
		html2canvas(
           document.getElementById("pdf_div"),
           {
               dpi: 172,//导出pdf清晰度
               onrendered: function (canvas) {
                   var contentWidth = canvas.width;
                   var contentHeight = canvas.height;

                   //一页pdf显示html页面生成的canvas高度;
                   var pageHeight = contentWidth / 592.28 * 841.89;
                   //未生成pdf的html页面高度
                   var leftHeight = contentHeight;
                   //pdf页面偏移
                   var position = 0;
                   //html页面生成的canvas在pdf中图片的宽高（a4纸的尺寸[595.28,841.89]）
                   var imgWidth = 595.28;
                   var imgHeight = 592.28 / contentWidth * contentHeight;

                   var pageData = canvas.toDataURL('image/jpeg', 1.0);
                   var pdf = new jsPDF('', 'pt', 'a4');

                   //有两个高度需要区分，一个是html页面的实际高度，和生成pdf的页面高度(841.89)
                   //当内容未超过pdf一页显示的范围，无需分页
                   if (leftHeight < pageHeight) {
                       pdf.addImage(pageData, 'JPEG', 0, 0, imgWidth, imgHeight);
                   } else {
                       while (leftHeight > 0) {
                           pdf.addImage(pageData, 'JPEG', 0, position, imgWidth, imgHeight)
                           leftHeight -= pageHeight;
                           position -= 841.89;
                           //避免添加空白页
                           if (leftHeight > 0) {
                               pdf.addPage();
                           }
                       }
                   }
                   
                   var qpbh=$("#pdf_div #qpbh_span").text();
                   var zzrqY=$("#pdf_div #zzrqY_span").text();
                   var zzrqM=$("#pdf_div #zzrqM_span").text();
                   pdf.save(qpbh+zzrqY+zzrqM+'.pdf');
    			   $("#pdf_div").css("border","#000 solid 1px");
               },
               //背景设为白色（默认为黑色）
               background: "#fff"  
           }
        )
	}
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
	$(".window-shadow").eq(1).css("width","520px");
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
		<div id="pdf_div" style="width:500px;height: 300px;border:#000 solid 1px;">
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