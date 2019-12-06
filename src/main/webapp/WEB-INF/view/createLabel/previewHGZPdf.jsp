<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>预览Pdf</title>
<%@include file="js.jsp"%>
<!-- 
<script src="https://cdn.bootcss.com/jspdf/1.5.3/jspdf.debug.js"></script>
<script src="https://cdn.bootcss.com/html2canvas/0.5.0-beta4/html2canvas.min.js"></script>
 -->
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/jspdf.debug.js"></script>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/html2canvas.min.js"></script>
<script type="text/javascript">
var path='<%=basePath %>';
var pdfHeight=0;
var outputIndex=0;
var outputCount=0;
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
	//pdfDiv.css("border-color","#fff");
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
           	   //pdfDiv.css("border-color","#000");
           },
           //背景设为白色（默认为黑色）
           background: "#fff"  
       }
    )
}

function batchOutputPdf(){
	$("#outputPdf_div").css("display","block");
	$("#previewPdf_div div[id^='pdf_div']").each(function(){
		//$(this).css("border-color","#fff");
		$("#outputPdf_div").append($(this).clone());
		
	});
	$("#outputPdf_div div[id^='pdf_div']").each(function(){
		var qpbh=$(this).attr("id").substring(7);
		$(this).attr("id","pdf2_div"+qpbh);
	});
    $("#outputPdf_div").css("height",pdfHeight+"px");
    outputIndex=0;
    outputCount=$("#outputPdf_div div[id^='pdf2_div']").length;
	createPdf();
}

function createPdf(){
	var qpbh=$("#previewPdf_div div[id^='pdf_div']").eq(outputIndex).attr("id").substring(7);
	
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
               if(outputIndex<outputCount){
           	   	   setTimeout("createPdf()",3000);
               }
               else{
           	   	   setTimeout(function(){
                	   showProDiv(false);
           	   	   },3000);
            	   outputIndex=0;
            	   outputCount=0;
            	   $("#outputPdf_div").empty();
       		       $("#outputPdf_div").css("height","0px");
       			   $("#outputPdf_div").css("display","none");
               }
   			//$("#previewPdf_div div[id^='pdf_div']").css("border-color","#000");
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
        //var pageHeight=708.75;
        var pageHeight=542.5;
        pdfHeight+=pageHeight;
        //332
        var marginTop=0;
        if(i>0){
        	marginTop=42;
        }
		previewPdfDiv.append("<div id=\"pdf_div"+airBottleJO.qpbh+"\" zzrqY=\""+airBottleJO.zzrq_y+"\" zzrqM=\""+airBottleJO.zzrq_m+"\" style=\"width:383px;height: "+pageHeight+"px;font-size: 30px;margin:0 auto;margin-top:"+marginTop+"px;border:#000 solid 1px;\">"
								+"<img alt=\"\" src=\""+airBottleJO.qrcode_hgz_url+"\" style=\"width: 180px;height: 180px;margin-top: 80px;margin-left: 150px;position: absolute;\">"
								+"<span style=\"margin-top: 20px;margin-left: 20px;position: absolute;\">"+airBottleJO.cpxh_qc+"</span>"
								+"<span style=\"margin-top: 105px;margin-left: 20px;position: absolute;\">"+airBottleJO.qpbh+"</span>"
								+"<span style=\"margin-top: 200px;margin-left: 20px;position: absolute;\">"+airBottleJO.zl+"</span>"
								+"<span style=\"margin-top: 305px;margin-left: 20px;position: absolute;\">"+airBottleJO.scrj+"</span>"
								+"<span style=\"margin-top: 460px;margin-left: 20px;position: absolute;\">"+airBottleJO.zzrq_y+airBottleJO.zzrq_m+"</span>"
							+"</div>");
	}
}
</script>
</head>
<body>
<div class="pro_div" id="pro_div" style="width: 100%;height: 100%;background-color: rgba(0,0,0,0.5);position: fixed;z-index: 1;display: none;">
	<div class="outputIndex_div" id="outputIndex_div" style="width: 300px;height: 50px;line-height: 50px;color: #fff;font-size: 30px;text-align:center;margin: 0 auto;margin-top: 250px;"></div>
	<div class="outputCount_div" id="outputCount_div" style="width: 300px;height: 50px;line-height: 50px;color: #fff;font-size: 30px;text-align:center;margin: 0 auto;margin-top: 30px;"></div>
	<div class="proBar_div" id="proBar_div" style="width: 1000px;height: 30px;line-height: 30px;background-color: #fff;margin: 0 auto;margin-top: 40px;">
		<div class="percent_div" id="percent_div" style="width: 0px;height: 30px;line-height: 30px;background-color: #00f;"></div>
	</div>
</div>
<div style="margin-top: 10px;text-align: center;">
	<a id="output_but">导出为PDF</a>
</div>
<div id="previewPdf_div" style="width: 383px;margin:0 auto;margin-top: 10px;">
	<!-- 
	<div id="pdf_div" style="width:400px;height: 300px;margin:0 auto;margin-top:10px;border:#000 solid 1px;">
		 <img alt="" src="<%=basePath %>/resource/images/qrcode.png" style="width: 180px;height: 180px;margin-top: 80px;margin-left: 150px;position: absolute;">
	     <span style="margin-top: 20px;margin-left: 20px;position: absolute;">356-70</span>
	     <span style="margin-top: 60px;margin-left: 20px;position: absolute;">CB190</span>
	     <span style="margin-top: 100px;margin-left: 20px;position: absolute;">70L</span>
	     <span style="margin-top: 140px;margin-left: 20px;position: absolute;">5.0</span>
	     <span style="margin-top: 180px;margin-left: 20px;position: absolute;">2019&nbsp;&nbsp;&nbsp;&nbsp;1</span>
	</div>
	 -->
</div>
<div id="outputPdf_div" style="width: 383px;margin:0 auto;display: none;">
</div>
</body>
</html>