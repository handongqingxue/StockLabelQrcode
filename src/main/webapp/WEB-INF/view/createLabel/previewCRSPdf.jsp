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
var outputIndex=0;
var outputCount=0;
var pdfSize=10;
var t;
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
	outputIndex=0;
	outputCount=$("#previewPdf_div div[id^='pdf_div']").length;
    //outputIndex=0;
    //outputCount=Math.ceil(itemCount/pdfSize);
	$("#previewPdf_div div[id^='pdf_div']").css("border-color","#fff");
	$("#outputPdf_div").css("display","block");
    $("#previewPdf_div").css("height","708.75px");
    $("#previewPdf_div div[id^='pdf_div']").css("display","none");
    clonePreItemDiv();
    
    /*
	////
	$("#outputPdf_div").css("display","block");
	$("#previewPdf_div div[id^='pdf_div']").each(function(){
		$(this).css("border-color","#fff");
		$("#outputPdf_div").append($(this).clone());
	});
    $("#outputPdf_div").css("height",pdfHeight+"px");
	
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
                pdf.save($("#previewPdf_div #pch_hid").val()+'.pdf');
                $("#outputPdf_div").empty();
    		    $("#outputPdf_div").css("height","0px");
    			$("#outputPdf_div").css("display","none");
    			$("#previewPdf_div div[id^='pdf_div']").css("border-color","#000");
            },
            //背景设为白色（默认为黑色）
            background: "#fff"  
        }
     )
     */
}

function clonePreItemDiv(){
	if(t!=undefined)
		clearTimeout(t);
	var preItemDiv=$("#previewPdf_div div[id^='pdf_div']").eq(outputIndex);
	preItemDiv.css("display","block");
	if(outputIndex>0){
		$("#previewPdf_div div[id^='pdf_div']").eq(outputIndex-1).css("display","none");
	}
	$("#outputPdf_div").append(preItemDiv.clone());
	outputIndex++;
	if(outputIndex%pdfSize==0){
		console.log($("#outputPdf_div").html());
		createPdf();
	}
	showProDiv(true);
    if(outputIndex<outputCount){
	   	   t=setTimeout("clonePreItemDiv()",1000);
    }
    else{
       setTimeout(function(){
     	  showProDiv(false);
   	   },1000);
       outputIndex=0;
       outputCount=0;
       $("#outputPdf_div").css("height","0px");
	   $("#outputPdf_div").css("display","none");
	   $("#previewPdf_div div[id^='pdf_div']").css("border-color","#000");
    }
}

function createPdf(){
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
               pdf.save($("#previewPdf_div #pch_hid").val()+'.pdf');
               //outputIndex++;
        	   $("#outputPdf_div").empty();
           },
           //背景设为白色（默认为黑色）
           background: "#fff"  
       }
    )
}

function showProDiv(ifShow){
	if(ifShow){
		$("#pro_div").css("display","block");
		$("#pro_div #outputIndex_div").text("正在导出第"+outputIndex+"个气瓶");
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
						+"<img id=\"qrcode_img\" alt=\"\" src=\""+airBottleJO.qrcode_crs_url+"\" style=\"width: 80px;height: 80px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
						//+"<img id=\"qrcode_img\" alt=\"\" src=\""+path+"resource/images/qrcode.png\" style=\"width: 80px;height: 80px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
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