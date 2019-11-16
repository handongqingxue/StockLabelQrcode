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
			var previewPdfDiv=$("#previewPdf_div");
			previewPdfDiv.find("div[id^='pdf_div']").each(function(i){
 			   var pdfDivId=$(this).attr("id");
 			   var zzrq=$(this).attr("zzrq");
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
                           pdf.save(qpbh+zzrq+'.pdf');
                       },
                       //背景设为白色（默认为黑色）
                       background: "#fff"  
                   }
                )
 		   });
		}
	});
});

function initPreviewPdfDiv(jsonStr){
	var previewPdfDiv=$("#previewPdf_div");
	var airBottleJA=JSON.parse(jsonStr);
	for(var i=0;i<airBottleJA.length;i++){
		var airBottleJO=airBottleJA[i];
		previewPdfDiv.append("<div id=\"pdf_div"+airBottleJO.qpbh+"\" zzrq=\""+airBottleJO.zzrq+"\" style=\"width:400px;height: 300px;margin:0 auto;margin-top:10px;border:#000 solid 1px;\">"
								+"<img alt=\"\" src=\""+airBottleJO.qrcode_hgz_url+"\" style=\"width: 180px;height: 180px;margin-top: 80px;margin-left: 150px;position: absolute;\">"
								+"<span style=\"margin-top: 20px;margin-left: 20px;position: absolute;\">"+airBottleJO.cpxh+"</span>"
								+"<span style=\"margin-top: 60px;margin-left: 20px;position: absolute;\">"+airBottleJO.qpbh+"</span>"
								+"<span style=\"margin-top: 100px;margin-left: 20px;position: absolute;\">"+airBottleJO.zl+"</span>"
								+"<span style=\"margin-top: 140px;margin-left: 20px;position: absolute;\">"+airBottleJO.scrj+"</span>"
								+"<span style=\"margin-top: 180px;margin-left: 20px;position: absolute;\">"+airBottleJO.zzrq+"</span>"
							+"</div>");
	}
}
</script>
</head>
<body>
<div id="previewPdf_div" style="width: 410px;margin:0 auto;">
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
<div style="margin-top: 10px;text-align: center;">
	<a id="output_but">导出为PDF</a>
</div>
</body>
</html>