<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>预览Pdf</title>
<style type="text/css">
.pro_div{
	width: 100%;
	height: 100%;
	background-color: rgba(0,0,0,0.5);
	position: fixed;
	z-index: 1;
	display: none;
}
.pro_div .outputIndex_div{
	width: 300px;
	height: 50px;
	line-height: 50px;
	color: #fff;
	font-size: 30px;
	text-align:center;
	margin: 0 auto;
	margin-top: 250px;
}
.pro_div .outputCount_div{
	width: 300px;
	height: 50px;
	line-height: 50px;
	color: #fff;
	font-size: 30px;
	text-align:center;
	margin: 0 auto;
	margin-top: 30px;
}
.pro_div .proBar_div{
	width: 1000px;
	height: 30px;
	line-height: 30px;
	background-color: #fff;
	margin: 0 auto;
	margin-top: 40px;
}
.pro_div .percent_div{
	width: 0px;
	height: 30px;
	line-height: 30px;
	background-color: #00f;
}
</style>
<%@include file="js.jsp"%>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/jspdf.debug.js"></script>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/html2canvas.min.js"></script>
<script type="text/javascript">
var path='<%=basePath %>';
//var itemIndex=0;
var cloneDivIndex=0;
var outputImgIndex=0;
var outputCount=0;
var pdfDivSize=5;
var t;
var pdf;
var pageData;
$(function(){
	$.post("getPrePdfJsonByUuid",
		{uuid:'${param.uuid}'},
		function(result){
			jsonStr=result.data;
			initPreviewPdfDiv(jsonStr);
		}
	,"json");
	

	$("#output_but").linkbutton({
		iconCls:"icon-back",
		onClick:function(){
			outputPdf();
		}
	});
});

function outputPdf(){
	pdf = new jsPDF('', 'pt', 'a4');
	cloneDivIndex=0;
	outputCount=$("#previewPdf_div div[id^='pdf_div']").length;
	$("#previewPdf_div div[id^='pdf_div']").css("border-color","#fff");
	$("#outputPdf_div").css("display","block");
    $("#previewPdf_div").css("height","708.75px");
    $("#previewPdf_div div[id^='pdf_div']").css("display","none");
    clonePreItemDiv();
}

function clonePreItemDiv(){
	if(t!=undefined)
		clearTimeout(t);
	var preItemDiv=$("#previewPdf_div div[id^='pdf_div']").eq(cloneDivIndex);
	preItemDiv.css("display","block");
	if(cloneDivIndex>0){
		$("#previewPdf_div div[id^='pdf_div']").eq(cloneDivIndex-1).css("display","none");
	}
	$("#outputPdf_div").append(preItemDiv.clone());
	cloneDivIndex++;
	if(cloneDivIndex%pdfDivSize==0){
		createPdfImage();
	}
	showProDiv(true);
    if(cloneDivIndex<outputCount){
	   	   t=setTimeout("clonePreItemDiv()",1000);
    }
    else{
       pdf.save($("#previewPdf_div #pch_hid").val()+'.pdf');
       pdf=null;
       setTimeout(function(){
     	  showProDiv(false);
   	   },1000);
       cloneDivIndex=0;
       outputCount=0;
       $("#outputPdf_div").css("height","0px");
	   $("#outputPdf_div").css("display","none");
	   $("#previewPdf_div div[id^='pdf_div']").css("border-color","#000");
    }
}

function createPdfImage(){
	resizeOutputPdfDiv(1);
	html2canvas(
       document.getElementById("outputPdf_div"),
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

               pageData = canvas.toDataURL('image/jpeg', 1.0);

               //有两个高度需要区分，一个是html页面的实际高度，和生成pdf的页面高度(841.89)
               //当内容未超过pdf一页显示的范围，无需分页
               if (leftHeight < pageHeight) {
                   pdf.addImage(pageData, 'JPEG', 0, 0, imgWidth, imgHeight);
               } else {
                   while (leftHeight > 0) {
                       pdf.addImage(pageData, 'JPEG', 0, position, imgWidth, imgHeight)
                       leftHeight -= pageHeight;
                       outputImgIndex++;
                       position -= 841.89;
                       //避免添加空白页
                       //if (leftHeight > 0) {
                       if(outputImgIndex<outputCount)
                           pdf.addPage();
                       //}
                   }
               }
               //cloneDivIndex++;
        	   $("#outputPdf_div").empty();
        	   resizeOutputPdfDiv(0);
           },
           //背景设为白色（默认为黑色）
           background: "#fff"  
       }
    )
}

function resizeOutputPdfDiv(flag){
	var scale=4;
	var outputPdfDivWidth=$("#outputPdf_div").css("width");
	outputPdfDivWidth=outputPdfDivWidth.substring(0,outputPdfDivWidth.length-2);
	if(flag==1){
		outputPdfDivWidth=outputPdfDivWidth*scale;
		$("#outputPdf_div").css("width",outputPdfDivWidth+"px");
		
		$("#outputPdf_div div[id^='pdf_div']").each(function(){
			var pdfItemDiv=$(this);
			var pdfItemWidth=pdfItemDiv.css("width");
			pdfItemWidth=pdfItemWidth.substring(0,pdfItemWidth.length-2);
			pdfItemWidth=pdfItemWidth*scale;
			pdfItemDiv.css("width",pdfItemWidth+"px");
			
			var pdfItemHeight=pdfItemDiv.css("height");
			pdfItemHeight=pdfItemHeight.substring(0,pdfItemHeight.length-2);
			pdfItemHeight=pdfItemHeight*scale;
			pdfItemDiv.css("height",pdfItemHeight+"px");
			
			var pdfItemFontSize=pdfItemDiv.css("font-size");
			pdfItemFontSize=pdfItemFontSize.substring(0,pdfItemFontSize.length-2);
			pdfItemFontSize=pdfItemFontSize*scale;
			pdfItemDiv.css("font-size",pdfItemFontSize+"px");
			
			var pdfItemBorderWidth=pdfItemDiv.css("border-width");
			pdfItemBorderWidth=pdfItemBorderWidth.substring(0,pdfItemBorderWidth.length-2);
			pdfItemBorderWidth=pdfItemBorderWidth*scale;
			pdfItemDiv.css("border-width",pdfItemBorderWidth+"px");
			
			var cpxhSpan=pdfItemDiv.find("#cpxh_span");
			var cpxhWidth=cpxhSpan.css("width");
			cpxhWidth=cpxhWidth.substring(0,cpxhWidth.length-2);
			cpxhWidth=cpxhWidth*scale;
			cpxhSpan.css("width",cpxhWidth+"px");
			
			var cpxhMarginTop=cpxhSpan.css("margin-top");
			cpxhMarginTop=cpxhMarginTop.substring(0,cpxhMarginTop.length-2);
			cpxhMarginTop=cpxhMarginTop*scale;
			cpxhSpan.css("margin-top",cpxhMarginTop+"px");
			
			var cpxhMarginLeft=cpxhSpan.css("margin-left");
			cpxhMarginLeft=cpxhMarginLeft.substring(0,cpxhMarginLeft.length-2);
			cpxhMarginLeft=cpxhMarginLeft*scale;
			cpxhSpan.css("margin-left",cpxhMarginLeft+"px");
			
			var tybmSpan=pdfItemDiv.find("#tybm_span");
			var tybmWidth=tybmSpan.css("width");
			tybmWidth=tybmWidth.substring(0,tybmWidth.length-2);
			tybmWidth=tybmWidth*scale;
			tybmSpan.css("width",tybmWidth+"px");

			var tybmFontSize=tybmSpan.css("font-size");
			tybmFontSize=tybmFontSize.substring(0,tybmFontSize.length-2);
			tybmFontSize=tybmFontSize*scale;
			tybmSpan.css("font-size",tybmFontSize+"px");
	
			var tybmMarginTop=tybmSpan.css("margin-top");
			tybmMarginTop=tybmMarginTop.substring(0,tybmMarginTop.length-2);
			tybmMarginTop=tybmMarginTop*scale;
			tybmSpan.css("margin-top",tybmMarginTop+"px");
	
			var tybmMarginLeft=tybmSpan.css("margin-left");
			tybmMarginLeft=tybmMarginLeft.substring(0,tybmMarginLeft.length-2);
			tybmMarginLeft=tybmMarginLeft*scale;
			tybmSpan.css("margin-left",tybmMarginLeft+"px");
			
			var qpbhSpan=pdfItemDiv.find("#qpbh_span");
			var qpbhWidth=qpbhSpan.css("width");
			qpbhWidth=qpbhWidth.substring(0,qpbhWidth.length-2);
			qpbhWidth=qpbhWidth*scale;
			qpbhSpan.css("width",qpbhWidth+"px");

			var qpbhMarginTop=qpbhSpan.css("margin-top");
			qpbhMarginTop=qpbhMarginTop.substring(0,qpbhMarginTop.length-2);
			qpbhMarginTop=qpbhMarginTop*scale;
			qpbhSpan.css("margin-top",qpbhMarginTop+"px");
	
			var qpbhMarginLeft=qpbhSpan.css("margin-left");
			qpbhMarginLeft=qpbhMarginLeft.substring(0,qpbhMarginLeft.length-2);
			qpbhMarginLeft=qpbhMarginLeft*scale;
			qpbhSpan.css("margin-left",qpbhMarginLeft+"px");
			
			var gcrjSpan=pdfItemDiv.find("#gcrj_span");
			var gcrjWidth=gcrjSpan.css("width");
			gcrjWidth=gcrjWidth.substring(0,gcrjWidth.length-2);
			gcrjWidth=gcrjWidth*scale;
			gcrjSpan.css("width",gcrjWidth+"px");

			var gcrjMarginTop=gcrjSpan.css("margin-top");
			gcrjMarginTop=gcrjMarginTop.substring(0,gcrjMarginTop.length-2);
			gcrjMarginTop=gcrjMarginTop*scale;
			gcrjSpan.css("margin-top",gcrjMarginTop+"px");
	
			var gcrjMarginLeft=gcrjSpan.css("margin-left");
			gcrjMarginLeft=gcrjMarginLeft.substring(0,gcrjMarginLeft.length-2);
			gcrjMarginLeft=gcrjMarginLeft*scale;
			gcrjSpan.css("margin-left",gcrjMarginLeft+"px");
			
			var ndbhSpan=pdfItemDiv.find("#ndbh_span");
			var ndbhWidth=ndbhSpan.css("width");
			ndbhWidth=ndbhWidth.substring(0,ndbhWidth.length-2);
			ndbhWidth=ndbhWidth*scale;
			ndbhSpan.css("width",ndbhWidth+"px");

			var ndbhMarginTop=ndbhSpan.css("margin-top");
			ndbhMarginTop=ndbhMarginTop.substring(0,ndbhMarginTop.length-2);
			ndbhMarginTop=ndbhMarginTop*scale;
			ndbhSpan.css("margin-top",ndbhMarginTop+"px");
	
			var ndbhMarginLeft=ndbhSpan.css("margin-left");
			ndbhMarginLeft=ndbhMarginLeft.substring(0,ndbhMarginLeft.length-2);
			ndbhMarginLeft=ndbhMarginLeft*scale;
			ndbhSpan.css("margin-left",ndbhMarginLeft+"px");
			
			var zzrqYSpan=pdfItemDiv.find("#zzrqY_span");
			var zzrqYWidth=zzrqYSpan.css("width");
			zzrqYWidth=zzrqYWidth.substring(0,zzrqYWidth.length-2);
			zzrqYWidth=zzrqYWidth*scale;
			zzrqYSpan.css("width",zzrqYWidth+"px");

			var zzrqYMarginTop=zzrqYSpan.css("margin-top");
			zzrqYMarginTop=zzrqYMarginTop.substring(0,zzrqYMarginTop.length-2);
			zzrqYMarginTop=zzrqYMarginTop*scale;
			zzrqYSpan.css("margin-top",zzrqYMarginTop+"px");
	
			var zzrqYMarginLeft=zzrqYSpan.css("margin-left");
			zzrqYMarginLeft=zzrqYMarginLeft.substring(0,zzrqYMarginLeft.length-2);
			zzrqYMarginLeft=zzrqYMarginLeft*scale;
			zzrqYSpan.css("margin-left",zzrqYMarginLeft+"px");
			
			var zzrqMSpan=pdfItemDiv.find("#zzrqM_span");
			var zzrqMWidth=zzrqMSpan.css("width");
			zzrqMWidth=zzrqMWidth.substring(0,zzrqMWidth.length-2);
			zzrqMWidth=zzrqMWidth*scale;
			zzrqMSpan.css("width",zzrqMWidth+"px");

			var zzrqMMarginTop=zzrqMSpan.css("margin-top");
			zzrqMMarginTop=zzrqMMarginTop.substring(0,zzrqMMarginTop.length-2);
			zzrqMMarginTop=zzrqMMarginTop*scale;
			zzrqMSpan.css("margin-top",zzrqMMarginTop+"px");
	
			var zzrqMMarginLeft=zzrqMSpan.css("margin-left");
			zzrqMMarginLeft=zzrqMMarginLeft.substring(0,zzrqMMarginLeft.length-2);
			zzrqMMarginLeft=zzrqMMarginLeft*scale;
			zzrqMSpan.css("margin-left",zzrqMMarginLeft+"px");
			
			var qrcodeImg=pdfItemDiv.find("#qrcode_img");
			var qrcodeWidth=qrcodeImg.css("width");
			qrcodeWidth=qrcodeWidth.substring(0,qrcodeWidth.length-2);
			qrcodeWidth=qrcodeWidth*scale;
			qrcodeImg.css("width",qrcodeWidth+"px");
			
			var qrcodeHeight=qrcodeImg.css("height");
			qrcodeHeight=qrcodeHeight.substring(0,qrcodeHeight.length-2);
			qrcodeHeight=qrcodeHeight*scale;
			qrcodeImg.css("height",qrcodeHeight+"px");
			
			var qrcodeMarginTop=qrcodeImg.css("margin-top");
			qrcodeMarginTop=qrcodeMarginTop.substring(0,qrcodeMarginTop.length-2);
			qrcodeMarginTop=qrcodeMarginTop*scale;
			qrcodeImg.css("margin-top",qrcodeMarginTop+"px");
			
			var qrcodeMarginLeft=qrcodeImg.css("margin-left");
			qrcodeMarginLeft=qrcodeMarginLeft.substring(0,qrcodeMarginLeft.length-2);
			qrcodeMarginLeft=qrcodeMarginLeft*scale;
			qrcodeImg.css("margin-left",qrcodeMarginLeft+"px");
		});
	}
	else{
		outputPdfDivWidth=outputPdfDivWidth/scale;
		$("#outputPdf_div").css("width",outputPdfDivWidth+"px");
	}
}

function showProDiv(ifShow){
	if(ifShow){
		$("#pro_div").css("display","block");
		$("#pro_div #outputIndex_div").text("正在导出第"+cloneDivIndex+"个气瓶");
		$("#pro_div #outputCount_div").text("共"+outputCount+"个");
		var pbdw=$("#proBar_div").css("width");
		pbdw=pbdw.substring(0,pbdw.length-2);
		$("#percent_div").css("width",cloneDivIndex/outputCount*pbdw+"px");
	}
	else{
		$("#pro_div").css("display","none");
		$("#pro_div #outputIndex_div").text("");
		$("#pro_div #outputCount_div").text("");
		$("#percent_div").css("width","0px");
	}
}

function initPreviewPdfDiv(jsonStr){
	var previewPdfDiv=$("#previewPdf_div");
	var airBottleJA=JSON.parse(jsonStr);
    var pch=airBottleJA[0].qpbh.substring(4,7);
    previewPdfDiv.append("<input type=\"hidden\" id=\"pch_hid\" value=\""+pch+"\"/>");
	for(var i=0;i<airBottleJA.length;i++){
		var airBottleJO=airBottleJA[i];
		$.ajaxSetup({async:false});
		$.post("selectCRSPdfSet",
			{labelType:airBottleJO.label_type,accountNumber:'${sessionScope.user.id}'},
			function(data){
				//console.log(data);
				var crsPdfSet=data.crsPdfSet;
				var id=crsPdfSet.id;
				var cpxhLeft=crsPdfSet.cpxh_left;
				var cpxhTop=crsPdfSet.cpxh_top;
				var tybmLeft=crsPdfSet.tybm_left;
				var tybmTop=crsPdfSet.tybm_top;
				var tybmFontSize=crsPdfSet.tybm_font_size;
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

                previewPdfDiv.append("<div id=\"pdf_div"+airBottleJO.qpbh+"\" zzrqY=\""+airBottleJO.zzrq_y+"\" zzrqM=\""+airBottleJO.zzrq_m+"\" style=\"width:500px;height: 708.75px;font-size: 18px;margin:0 auto;border:#000 solid 1px;\">"
						+"<img id=\"qrcode_img\" alt=\"\" src=\""+airBottleJO.qrcode_crs_url+"\" style=\"width: 130px;height: 130px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
						+"<span id=\"cpxh_span\" style=\"width:100px;margin-top: "+cpxhTop+"px;margin-left: "+cpxhLeft+"px;position: absolute;\">"+airBottleJO.cpxh+"</span>"
						+"<span id=\"tybm_span\" style=\"width: 150px;margin-top: "+tybmTop+"px;margin-left: "+tybmLeft+"px;font-size:"+tybmFontSize+"px;font-weight: bold;position: absolute;\">"+airBottleJO.tybm+"</span>"
						+"<span id=\"qpbh_span\" style=\"width: 150px;margin-top: "+qpbhTop+"px;margin-left: "+qpbhLeft+"px;position: absolute;\">"+airBottleJO.qpbh+"</span>"
						+"<span id=\"gcrj_span\" style=\"width: 70px;margin-top: "+gcrjTop+"px;margin-left: "+gcrjLeft+"px;position: absolute;\">"+airBottleJO.gcrj+"</span>"
						+"<span id=\"ndbh_span\" style=\"width: 70px;margin-top: "+ndbhTop+"px;margin-left: "+ndbhLeft+"px;position: absolute;\">"+airBottleJO.ndbh+"</span>"
						+"<span id=\"zzrqY_span\" style=\"width: 50px;margin-top: "+zzrqYTop+"px;margin-left: "+zzrqYLeft+"px;position: absolute;\">"+airBottleJO.zzrq_y+"</span>"
						+"<span id=\"zzrqM_span\" style=\"width: 30px;margin-top: "+zzrqMTop+"px;margin-left: "+zzrqMLeft+"px;position: absolute;\">"+airBottleJO.zzrq_m+"</span>"
					+"</div>");
			}
		,"json");
	}
	
	
         
}
</script>
</head>
<body>
<div class="pro_div" id="pro_div">
	<div class="outputIndex_div" id="outputIndex_div"></div>
	<div class="outputCount_div" id="outputCount_div"></div>
	<div class="proBar_div" id="proBar_div">
		<div class="percent_div" id="percent_div"></div>
	</div>
</div>
<div style="margin-top: 10px;text-align: center;">
	<a id="output_but">导出为PDF</a>
</div>
<div id="previewPdf_div" style="width: 500px;margin:0 auto;margin-top: 10px;">
</div>
<div id="outputPdf_div" style="width: 500px;margin:0 auto;display: none;">
</div>
</body>
</html>