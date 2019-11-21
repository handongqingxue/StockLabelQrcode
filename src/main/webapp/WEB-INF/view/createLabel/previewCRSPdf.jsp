<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>预览Pdf</title>
<%@include file="js.jsp"%>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/jspdf.debug.js"></script>
<script type="text/javascript" src="<%=basePath %>resource/js/pdf/html2canvas.min.js"></script>
<script type="text/javascript">
var path='<%=basePath %>';
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
			var previewPdfDiv=$("#previewPdf_div");
			previewPdfDiv.find("div[id^='pdf_div']").each(function(i){
 			   var pdfDivId=$(this).attr("id");
 			   var zzrqY=$(this).attr("zzrqY");
 			   var zzrqM=$(this).attr("zzrqM");
 			   var qpbh=pdfDivId.substring(7,pdfDivId.length);
		   	   $("#"+pdfDivId).css("border","0px");
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
	        			   $("#"+pdfDivId).css("border","#000 solid 1px");
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
		
		$.ajaxSetup({async:false});
		$.post("selectCRSPdfSet",
			{labelType:airBottleJO.label_type,accountNumber:'${sessionScope.user.id}'},
			function(data){
				//console.log(data);
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
	
				previewPdfDiv.append("<div id=\"pdf_div"+airBottleJO.qpbh+"\" zzrqY=\""+airBottleJO.zzrq_y+"\" zzrqM=\""+airBottleJO.zzrq_m+"\" style=\"width:500px;height: 300px;margin:0 auto;margin-top:10px;border:#000 solid 1px;\">"
						+"<img id=\"qrcode_img\" alt=\"\" src=\""+airBottleJO.qrcode_crs_url+"\" style=\"width: 120px;height: 120px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
						+"<span id=\"cpxh_span\" style=\"margin-top: "+cpxhTop+"px;margin-left: "+cpxhLeft+"px;position: absolute;\">"+airBottleJO.cpxh+"</span>"
						+"<span id=\"qpbh_span\" style=\"margin-top: "+qpbhTop+"px;margin-left: "+qpbhLeft+"px;position: absolute;\">"+airBottleJO.qpbh+"</span>"
						+"<span id=\"gcrj_span\" style=\"margin-top: "+gcrjTop+"px;margin-left: "+gcrjLeft+"px;position: absolute;\">"+airBottleJO.gcrj+"</span>"
						+"<span id=\"ndbh_span\" style=\"margin-top: "+ndbhTop+"px;margin-left: "+ndbhLeft+"px;position: absolute;\">"+airBottleJO.ndbh+"</span>"
						+"<span id=\"zzrqY_span\" style=\"margin-top: "+zzrqYTop+"px;margin-left: "+zzrqYLeft+"px;position: absolute;\">"+airBottleJO.zzrq_y+"</span>"
						+"<span id=\"zzrqM_span\" style=\"margin-top: "+zzrqMTop+"px;margin-left: "+zzrqMLeft+"px;position: absolute;\">"+airBottleJO.zzrq_m+"</span>"
					+"</div>");
			}
		,"json");
	}
}
</script>
</head>
<body>
<div id="previewPdf_div" style="width: 410px;margin:0 auto;">
</div>
<div style="margin-top: 10px;text-align: center;">
	<a id="output_but">导出为PDF</a>
</div>
</body>
</html>