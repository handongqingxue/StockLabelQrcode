<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>编辑</title>
<%@include file="js.jsp"%>
<script type="text/javascript">
var path='<%=basePath %>';
$(function(){
	$("#edit_div").dialog({
		title:"编辑",
		width:setFitWidthInParent("body"),
		height:setFitHeightInParent(".layui-side"),
		top:80,
		left:200,
		buttons:[
           {text:"提交",id:"ok_but",iconCls:"icon-ok",handler:function(){
       	   	    checkEdit();
           }}
        ]
	});
	
	previewPDF('${requestScope.airBottle.label_type }');
	
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

function editPreviewCrsPdfSet(){
	var id=$("#pdf_div #id_hid").val();
    var cpxhLeft=$("#pdf_div #cpxh_span").css("margin-left");
    cpxhLeft=cpxhLeft.substring(0,cpxhLeft.length-2);
    var cpxhTop=$("#pdf_div #cpxh_span").css("margin-top");
    cpxhTop=cpxhTop.substring(0,cpxhTop.length-2);
    var qpbhLeft=$("#pdf_div #qpbh_span").css("margin-left");
    qpbhLeft=qpbhLeft.substring(0,qpbhLeft.length-2);
    var qpbhTop=$("#pdf_div #qpbh_span").css("margin-top");
    qpbhTop=qpbhTop.substring(0,qpbhTop.length-2);
    var gcrjLeft=$("#pdf_div #gcrj_span").css("margin-left");
    gcrjLeft=gcrjLeft.substring(0,gcrjLeft.length-2);
    var gcrjTop=$("#pdf_div #gcrj_span").css("margin-top");
    gcrjTop=gcrjTop.substring(0,gcrjTop.length-2);
    var ndbhLeft=$("#pdf_div #ndbh_span").css("margin-left");
    ndbhLeft=ndbhLeft.substring(0,ndbhLeft.length-2);
    var ndbhTop=$("#pdf_div #ndbh_span").css("margin-top");
    ndbhTop=ndbhTop.substring(0,ndbhTop.length-2);
    var zzrqLeft=$("#pdf_div #zzrq_span").css("margin-left");
    zzrqLeft=zzrqLeft.substring(0,zzrqLeft.length-2);
    var zzrqTop=$("#pdf_div #zzrq_span").css("margin-top");
    zzrqTop=zzrqTop.substring(0,zzrqTop.length-2);
    var qrcodeLeft=$("#pdf_div #qrcode_img").css("margin-left");
    qrcodeLeft=qrcodeLeft.substring(0,qrcodeLeft.length-2);
    var qrcodeTop=$("#pdf_div #qrcode_img").css("margin-top");
    qrcodeTop=qrcodeTop.substring(0,qrcodeTop.length-2);
    
    console.log("cpxhLeft==="+cpxhLeft);
    console.log("cpxhTop==="+cpxhTop);
    console.log("qpbhLeft==="+qpbhLeft);
    console.log("qpbhTop==="+qpbhTop);
    console.log("gcrjLeft==="+gcrjLeft);
    console.log("gcrjTop==="+gcrjTop);
    console.log("ndbhLeft==="+ndbhLeft);
    console.log("ndbhTop==="+ndbhTop);
    $.post("editPreviewCrsPdfSet",
   		{id:id,cpxh_left:cpxhLeft,cpxh_top:cpxhTop,qpbh_left:qpbhLeft,qpbh_top:qpbhTop,gcrj_left:gcrjLeft,gcrj_top:gcrjTop,
    	ndbh_left:ndbhLeft,ndbh_top:ndbhTop,zzrq_left:zzrqLeft,zzrq_top:zzrqTop,qrcode_left:qrcodeLeft,qrcode_top:qrcodeTop},
   		function(){
    	
    	}
    ,"json");
}

function previewPDF(labelType){
	$.post("selectCRSPdfSet",
		{labelType:labelType,accountNumber:'${sessionScope.user.id}'},
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
			
			var cpxh='${requestScope.airBottle.cpxh }';
			var qpbh='${requestScope.airBottle.qpbh }';
			var gcrj='${requestScope.airBottle.gcrj }';
			var ndbh='${requestScope.airBottle.ndbh }';
			var zzrq='${requestScope.airBottle.zzrq }';
			
			var previewPDFTd=$("#previewPDF_td");
			previewPDFTd.empty();
			previewPDFTd.append("<div id=\"pdf_div\" style=\"width:400px;height: 300px;border:#000 solid 1px;\">"
									+"<input id=\"id_hid\" type=\"hidden\" value=\""+id+"\"/>"
									+"<img id=\"qrcode_img\" alt=\"\" src=\""+path+"/resource/images/qrcode.png\" style=\"width: 180px;height: 180px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
									+"<span id=\"cpxh_span\" style=\"margin-top: "+cpxhTop+"px;margin-left: "+cpxhLeft+"px;position: absolute;\">"+cpxh+"</span>"
									+"<span id=\"qpbh_span\" style=\"margin-top: "+qpbhTop+"px;margin-left: "+qpbhLeft+"px;position: absolute;\">"+qpbh+"</span>"
									+"<span id=\"gcrj_span\" style=\"margin-top: "+gcrjTop+"px;margin-left: "+gcrjLeft+"px;position: absolute;\">"+gcrj+"</span>"
									+"<span id=\"ndbh_span\" style=\"margin-top: "+ndbhTop+"px;margin-left: "+ndbhLeft+"px;position: absolute;\">"+ndbh+"</span>"
									+"<span id=\"zzrq_span\" style=\"margin-top: "+zzrqTop+"px;margin-left: "+zzrqLeft+"px;position: absolute;\">"+zzrq+"</span>"
								+"</div>");
		}
	,"json");
}

function resetPDFHtmlLocation(labelName,action){
	if(checkPreviewPdfHtml()){
		if(action=="up"){
			var marginTop=$("#pdf_div #"+labelName).css("margin-top");
			marginTop=marginTop.substring(0,marginTop.length-2);
			marginTop--;
			$("#pdf_div #"+labelName).css("margin-top",marginTop+"px");
		}
		else if(action=="down"){
			var marginTop=$("#pdf_div #"+labelName).css("margin-top");
			marginTop=marginTop.substring(0,marginTop.length-2);
			marginTop++;
			$("#pdf_div #"+labelName).css("margin-top",marginTop+"px");
		}
		else if(action=="left"){
			var marginLeft=$("#pdf_div #"+labelName).css("margin-left");
			marginLeft=marginLeft.substring(0,marginLeft.length-2);
			marginLeft--;
			$("#pdf_div #"+labelName).css("margin-left",marginLeft+"px");
		}
		else if(action=="right"){
			var marginLeft=$("#pdf_div #"+labelName).css("margin-left");
			marginLeft=marginLeft.substring(0,marginLeft.length-2);
			marginLeft++;
			$("#pdf_div #"+labelName).css("margin-left",marginLeft+"px");
		}
	}
}

function checkPreviewPdfHtml(){
	var pdfHtml=$("#previewPDF_td").html();
    if(pdfHtml.trim()==""){
	    alert("请先生成预览！");
	    return false;
    }
    else
	    return true;
}

function checkEdit(){
	if(checkZl()){
		if(checkSCRJ()){
			if(checkQPZJXH()){
				editPreviewCrsPdfSet();
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
	if(scrj=="实测容积不能为空"){
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
	<%@include file="top.jsp"%>
	<%@include file="left.jsp"%>
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
				重量
			</td>
			<td>
				<input type="text" id="zl" name="zl" size="10" value="${requestScope.airBottle.zl }" onfocus="focusZl()" onblur="checkZl()" />
				<span style="color: #f00;">*</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				实测容积
			</td>
			<td>
				<input type="text" id="scrj" name="scrj" size="15" value="${requestScope.airBottle.scrj }" onfocus="focusSCRJ()" onblur="checkSCRJ()" />
				<span style="color: #f00;">*</span>
			</td>
		  </tr>
		  <tr style="border-bottom: #CAD9EA solid 1px;">
			<td align="right">
				气瓶支架型号
			</td>
			<td>
				<input type="text" id="qpzjxh" name="qpzjxh" value="${requestScope.airBottle.qpzjxh }" onfocus="focusQPZJXH()" onblur="checkQPZJXH()"/>
				<span style="color: #f00;">*</span>
			</td>
		  </tr>
				<tr style="border-bottom: #CAD9EA solid 1px;height: 350px;">
					<td align="right">
						<div style="height: 45px;line-height: 45px;">PDF预览</div>
						<div style="height: 45px;">
							产品型号：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('cpxh_span','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('cpxh_span','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('cpxh_span','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('cpxh_span','right')">右移</a>
						</div>
						<div style="height: 45px;">
							气瓶编号：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qpbh_span','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qpbh_span','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qpbh_span','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qpbh_span','right')">右移</a>
						</div>
						<div style="height: 45px;">
							公称容积：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('gcrj_span','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('gcrj_span','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('gcrj_span','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('gcrj_span','right')">右移</a>
						</div>
						<div style="height: 45px;">
							内胆壁厚：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('ndbh_span','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('ndbh_span','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('ndbh_span','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('ndbh_span','right')">右移</a>
						</div>
						<div style="height: 45px;">
							制造日期：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrq_span','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrq_span','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrq_span','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrq_span','right')">右移</a>
						</div>
						<div style="height: 45px;">
							二维码：
							&nbsp;&nbsp;
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','right')">右移</a>
						</div>
					</td>
					<td id="previewPDF_td">
					</td>
				</tr>
		</table>
		</form>
	</div>
	<%@include file="foot.jsp"%>
</div>
</body>
</html>