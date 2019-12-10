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
.opb_div{
	margin-top: 10px;
	text-align: center;
}
.previewPdf_div{
	width: 383px;
	margin:0 auto;
	margin-top: 10px;
}
.outputPdf_div{
	width: 383px;
	margin:0 auto;
	display: none;
}
.item_div{
	width:383px;
	height: 442.5px;
	font-size: 35px;
	margin:0 auto;
	border:#000 solid 1px;
}
.item_div .qrcode_img{
	width: 180px;
	height: 220px;
	margin-top: 217px;
	margin-left: 150px;
	position: absolute;
}
.item_div .cpxh_qc_span{
	margin-top: 20px;
	margin-left: 20px;
	position: absolute;
}
.item_div .qpbh_span{
	margin-top: 105px;
	margin-left: 20px;
	position: absolute;
}
.item_div .zl_span{
	margin-top: 199px;
	margin-left: 20px;
	position: absolute;
}
.item_div .scrj_span{
	margin-top: 293px;
	margin-left: 20px;
	position: absolute;
}
.item_div .zzrq_span{
	margin-top: 390px;
	margin-left: 20px;
	position: absolute;
}
</style>
<%@include file="js.jsp"%>
<!-- 
<script src="https://cdn.bootcss.com/jspdf/1.5.3/jspdf.debug.js"></script>
<script src="https://cdn.bootcss.com/html2canvas/0.5.0-beta4/html2canvas.min.js"></script>
 -->
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/jspdf.debug.js"></script>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/html2canvas.min.js"></script>
<script type="text/javascript">
var path='<%=basePath %>';
var outputIndex=0;
var outputCount=0;
var t;
$(function(){
	var jsonStr="";
	if('${param.action}'=="single"){
		jsonStr='${param.jsonStr}';
		initPreviewPdfDiv(jsonStr);
	}
	else{
		$.post("getPrePdfJsonByUuid",
			{uuid:'${param.uuid}'},
			function(result){
				jsonStr=result.data;
				initPreviewPdfDiv(jsonStr);
			}
		,"json");
	}
	
	$("#output_but").linkbutton({
		iconCls:"icon-back",
		onClick:function(){
			if('${param.action}'=="single"){
				singleOutputPdf();
			}
			else{
				batchOutputPdf();
			}
		}
	});
});

function singleOutputPdf(){
	var pdfDiv=$("#previewPdf_div div[id^='pdf_div']").eq(0);
	pdfDiv.css("border-color","#fff");
	var pdfDivId=pdfDiv.attr("id");
    var zzrqY=pdfDiv.attr("zzrqY");
    var zzrqM=pdfDiv.attr("zzrqM");
	var qpbh=pdfDivId.substring(7,pdfDivId.length);
	
	html2canvas(
       document.getElementById(pdfDivId),
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
               pdf.save(qpbh+zzrqY+zzrqM+'.pdf');
           	   pdfDiv.css("border-color","#000");
           },
           //背景设为白色（默认为黑色）
           background: "#fff"  
       }
    )
}

function batchOutputPdf(){
    outputIndex=0;
    outputCount=$("#previewPdf_div div[id^='pdf_div']").length;
	$("#previewPdf_div div[id^='pdf_div']").css("border-color","#fff");
	$("#outputPdf_div").css("display","block");
    $("#previewPdf_div").css("height","542.5px");
    $("#previewPdf_div div[id^='pdf_div']").css("margin-top","10px");
    $("#previewPdf_div div[id^='pdf_div']").css("display","none");
	createPdf();
}

function createPdf(){
	if(t!=undefined)
		clearTimeout(t);
	var preItemDiv=$("#previewPdf_div div[id^='pdf_div']").eq(outputIndex);
	preItemDiv.css("display","block");
	if(outputIndex>0){
		$("#previewPdf_div div[id^='pdf_div']").eq(outputIndex-1).css("display","none");
	}
	$("#outputPdf_div").append(preItemDiv.clone());
	var qpbh=preItemDiv.attr("id").substring(7);
	$("#outputPdf_div div[id^='pdf_div']").attr("id","pdf2_div"+qpbh);
	
	html2canvas(
       document.getElementById("pdf2_div"+qpbh),
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
               var zzrq=$("#previewPdf_div #zzrq_hid").val();
               pdf.save(qpbh+zzrq+'.pdf');
               outputIndex++;
        	   showProDiv(true);
        	   $("#outputPdf_div").empty();
               if(outputIndex<outputCount){
           	   	   t=setTimeout("createPdf()",3000);
               }
               else{
           	   	   setTimeout(function(){
                	   showProDiv(false);
           	   	   },3000);
            	   outputIndex=0;
            	   outputCount=0;
       		       $("#outputPdf_div").css("height","0px");
       			   $("#outputPdf_div").css("display","none");
          		   $("#previewPdf_div div[id^='pdf_div']").css("border-color","#000");
               }
           },
           //背景设为白色（默认为黑色）
           background: "#fff"  
       }
    )
}

function showProDiv(ifShow){
	if(ifShow){
		$("#pro_div").css("display","block");
		$("#pro_div #outputIndex_div").text("正在导出第"+outputIndex+"个Pdf");
		$("#pro_div #outputCount_div").text("共"+outputCount+"个");
		var pbdw=$("#proBar_div").css("width");
		pbdw=pbdw.substring(0,pbdw.length-2);
		$("#percent_div").css("width",outputIndex/outputCount*pbdw+"px");
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
    var zzrq=airBottleJA[0].zzrq_y+airBottleJA[0].zzrq_m;
    previewPdfDiv.append("<input type=\"hidden\" id=\"zzrq_hid\" value=\""+zzrq+"\"/>");
	for(var i=0;i<airBottleJA.length;i++){
		var airBottleJO=airBottleJA[i];
        var marginTop=0;
        if(i>0){
        	marginTop=20;
        }
		previewPdfDiv.append("<div class=\"item_div\" id=\"pdf_div"+airBottleJO.qpbh+"\" zzrqY=\""+airBottleJO.zzrq_y+"\" zzrqM=\""+airBottleJO.zzrq_m+"\" style=\"margin-top:"+marginTop+"px;\">"
								+"<img class=\"qrcode_img\" alt=\"\" src=\""+airBottleJO.qrcode_hgz_url+"\">"
								//+"<img class=\"qrcode_img\" alt=\"\" src=\""+path+"resource/images/qrcode.png\">"
								+"<span class=\"cpxh_qc_span\">"+airBottleJO.cpxh_qc+"</span>"
								+"<span class=\"qpbh_span\">"+airBottleJO.qpbh+"</span>"
								+"<span class=\"zl_span\">"+airBottleJO.zl+"</span>"
								+"<span class=\"scrj_span\">"+airBottleJO.scrj+"</span>"
								+"<span class=\"zzrq_span\">"+airBottleJO.zzrq_y+airBottleJO.zzrq_m+"</span>"
							+"</div>");
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
<div class="opb_div">
	<a id="output_but">导出为PDF</a>
</div>
<div class="previewPdf_div" id="previewPdf_div">
</div>
<div class="outputPdf_div" id="outputPdf_div">
</div>
</body>
</html>