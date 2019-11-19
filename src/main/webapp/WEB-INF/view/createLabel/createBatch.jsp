<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>创建批次界面</title>
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
	$("#add_div").dialog({
		title:"创建批次",
		width:setFitWidthInParent("body"),
		height:setFitHeightInParent(".layui-side"),
		top:80,
		left:200,
		buttons:[
           {text:"中文标签",id:"chinese_but",iconCls:"icon-ok",handler:function(){
        	   previewPDF(1);
           }},
           {text:"ISO标签",id:"iso_but",iconCls:"icon-ok",handler:function(){
        	   previewPDF(2);
           }},
           {text:"ECE标签",id:"ece_but",iconCls:"icon-ok",handler:function(){
        	   previewPDF(3);
           }},
           {text:"导出为PDF",id:"export_pdf_but",iconCls:"icon-ok",handler:function(){
        	   if(checkCPXH()){
        		   if(checkQpQsBh()){
        			   if(checkQpJsBh()){
        				   if(checkGCRJ()){
        					   if(checkNDBH()){
        						   if(checkZZRQY()){
	        						   if(checkZZRQM()){
							        	   if(checkPreviewPdfHtml()){
							        		   var qpqsbh=$("#qpqsbh_inp").val();
							        		   var qpjsbh=$("#qpjsbh_inp").val();
							        		   var qpqsbhPre=qpqsbh.substring(0,7);
							        		   var qpqsbhSuf=qpqsbh.substring(7,qpqsbh.length);
							        		   qpjsbh=qpjsbh.substring(7,qpjsbh.length);
							        		   //var zzrq=$("#zzrq_inp").val().replace(/\s*/g,'');
							        		   var zzrqY=$("#zzrqY_inp").val();
							        		   var zzrqM=$("#zzrqM_inp").val();
							        		   var outputPdfDiv=$("#outputPdf_div");
							        		   for(var i = qpqsbhSuf;i <= qpjsbh;i++){
							                       var qpbhSuf;
							                       qpbhSuf=i+"";
							                       if(qpbhSuf.length==2)
							                    	    qpbhSuf="0"+i;
							                       else if(qpbhSuf.length==1)
							                    	    qpbhSuf="00"+i;
							                       var qpbh=qpqsbhPre+qpbhSuf;
							                       if(!checkQpbhExist(qpbh))
							                    	   continue;
							        			   outputPdfDiv.append("<div id=\"pdf_div"+qpbh+"\" style=\"width:500px;height: 300px;border:#000 solid 1px;\">"+$("#pdf_div").html()+"</div>");
							        		   }
							        		   
							        		   var qpbhsStr="";
							        		   var qrcodeCRSUrlsStr="";
							        		   var qrcodeHGZUrlsStr="";
							        		   outputPdfDiv.find("div[id^='pdf_div']").each(function(i){
							        			   var pdfDivId=$(this).attr("id");
							        			   var qpbh=pdfDivId.substring(7,pdfDivId.length);
							        			   qpbhsStr+=","+qpbh;
							        			   qrcodeCRSUrlsStr+=","+$("#pdf_div #qrcode_img").attr("src");
							        			   qrcodeHGZUrlsStr+=","+$("#pdf_div #qrcodeHGZUrl_hid").val();
							        			   
							        			   createCRSQrcode(qpbh,pdfDivId);
							        			   createHGZQrcode(qpbh,pdfDivId);
							
												   //console.log($(this).find("img[id='qrcode_img']").attr("src"));
												   
							        			   //removeChinesePdfLabel($(this));
							        			   
							        			   $(this).find("span[id='qpbh_span']").text(qpbh);
							        			   //if(pdfDivId=="pdf_divCB19001002")
							        				   //return false;
						        			   	   $("#pdf_div").css("border","0px");
							        			   $("#pdf_div").empty();
							        			   $("#pdf_div").append($("#"+pdfDivId).html());
							        			   //console.log($("#pdf_div").html());
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
								   	                           //var imgWidth = 800;
								   	                           //var imgHeight = 500;
								   	    
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
										        			   $("#pdf_div").css("border","#000 solid 1px");
								   	                       },
								   	                       //背景设为白色（默认为黑色）
								   	                       background: "#fff"  
								   	                   }
								   	                )
								   	                
							        		   });
	
							       			   qpbhsStr=qpbhsStr.substring(1);
							       			   qrcodeCRSUrlsStr=qrcodeCRSUrlsStr.substring(1);
							       			   qrcodeHGZUrlsStr=qrcodeHGZUrlsStr.substring(1);
							       			   
							       			   if(qpbhsStr!=""){
								  	               editPreviewCrsPdfSet();
								  	               
								        		   var cpxh=$("#cpxh_inp").val();
								       			   var gcrj=$("#gcrj_inp").val();
								       			   var ndbh=$("#ndbh_inp").val();
								       			   var label_type=$("#pdf_div #labelType_hid").val();
								       			
								        		   $.post("insertAirBottleRecord",
								       				   {cpxh:cpxh,qpbhsStr:qpbhsStr,qrcodeCRSUrlsStr:qrcodeCRSUrlsStr,
								        			   qrcodeHGZUrlsStr:qrcodeHGZUrlsStr,gcrj:gcrj,ndbh:ndbh,zzrq_y:zzrqY,zzrq_m:zzrqM,label_type:label_type},
								       				   function(data){
								        			   		alert(data.info);
								        		   	   }
								        		   ,"json");
							       			   }
							        	   	}
	        						    }
        						    }
        					    }
        				    }
        			    }
        		    }
        	    }
           }}
        ]
	});
	
	$("#add_div table").css("width","1000px");
	$("#add_div table").css("magin","-100px");
	$("#add_div table td").css("padding-left","50px");
	$("#add_div table td").css("padding-right","20px");
	$("#add_div table td").css("font-size","15px");
	
	$("#add_div table tr").each(function(){
		$(this).find("td").eq(0).css("color","#006699");
		$(this).find("td").eq(0).css("border-right","#CAD9EA solid 1px");
		$(this).find("td").eq(0).css("font-weight","bold");
		$(this).find("td").eq(0).css("background-color","#F5FAFE");
	});

	$("#add_div table tr").mousemove(function(){
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
	
	$("#chinese_but").css("left","5%");
	$("#chinese_but").css("position","absolute");
	
	$("#iso_but").css("left","30%");
	$("#iso_but").css("position","absolute");
	
	$("#ece_but").css("left","55%");
	$("#ece_but").css("position","absolute");
	
	$("#export_pdf_but").css("left","75%");
	$("#export_pdf_but").css("position","absolute");
	
	$(".dialog-button").css("background-color","#fff");
	$(".dialog-button .l-btn-text").css("font-size","20px");
});

function removeChinesePdfLabel(pdfDiv){
   pdfDiv.find("#cpxhTit1_span").remove();
   pdfDiv.find("#cpxhTit2_span").remove();
   pdfDiv.find("#qpbhTit1_span").remove();
   pdfDiv.find("#cpbzh_span").remove();
   pdfDiv.find("#czjz_span").remove();
   pdfDiv.find("#gcrjTit_span").remove();
   pdfDiv.find("#gcgzyl_span").remove();
   pdfDiv.find("#sysyyl_span").remove();
   pdfDiv.find("#gndsjbhTit1_span").remove();
   pdfDiv.find("#gndsjbhTit2_span").remove();
   pdfDiv.find("#sjsynx_span").remove();
   pdfDiv.find("#zzxkzbh_span").remove();
   pdfDiv.find("#zzrqTit1_span").remove();
   pdfDiv.find("#zzrqTit2_span").remove();
   pdfDiv.find("#zzrqTit3_span").remove();
   pdfDiv.find("#gsmc_span").remove();
   pdfDiv.find("#fwrx_span").remove();
}

function createCRSQrcode(qpbh,pdfDivId){
   var url=path+"createLabel/toQrcodeInfo?action=crs&qpbh="+qpbh;
   $.post("createQrcode",
	   {url:url,qpbh:qpbh},
	   function(data){
		   $("#"+pdfDivId).find("img[id='qrcode_img']").attr("src",data.qrcodeUrl);
   	   }
   ,"json");
}

function createHGZQrcode(qpbh,pdfDivId){
	var url=path+"createLabel/toQrcodeInfo?action=hgz&qpbh="+qpbh;
    $.post("createQrcode",
	   {url:url,qpbh:qpbh},
	   function(data){
		   $("#"+pdfDivId).find("#qrcodeHGZUrl_hid").val(data.qrcodeUrl);
   	   }
    ,"json");
}

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
    
    var zzrqYLeft=$("#pdf_div #zzrqY_span").css("margin-left");
    zzrqYLeft=zzrqYLeft.substring(0,zzrqYLeft.length-2);
    var zzrqYTop=$("#pdf_div #zzrqY_span").css("margin-top");
    zzrqYTop=zzrqYTop.substring(0,zzrqYTop.length-2);
    var zzrqMLeft=$("#pdf_div #zzrqM_span").css("margin-left");
    zzrqMLeft=zzrqMLeft.substring(0,zzrqMLeft.length-2);
    var zzrqMTop=$("#pdf_div #zzrqM_span").css("margin-top");
    zzrqMTop=zzrqMTop.substring(0,zzrqMTop.length-2);
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
    	ndbh_left:ndbhLeft,ndbh_top:ndbhTop,zzrq_y_left:zzrqYLeft,zzrq_y_top:zzrqYTop,zzrq_m_left:zzrqMLeft,zzrq_m_top:zzrqMTop,qrcode_left:qrcodeLeft,qrcode_top:qrcodeTop},
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
			var zzrqYLeft=crsPdfSet.zzrq_y_left;
			var zzrqYTop=crsPdfSet.zzrq_y_top;
			var zzrqMLeft=crsPdfSet.zzrq_m_left;
			var zzrqMTop=crsPdfSet.zzrq_m_top;
			var qrcodeLeft=crsPdfSet.qrcode_left;
			var qrcodeTop=crsPdfSet.qrcode_top;
			
			var cpxh=$("#cpxh_inp").val();
			var qpqsbh=$("#qpqsbh_inp").val();
			var gcrj=$("#gcrj_inp").val();
			var ndbh=$("#ndbh_inp").val();
			var zzrqY=$("#zzrqY_inp").val();
			var zzrqM=$("#zzrqM_inp").val();
			
			var previewPDFTd=$("#previewPDF_td");
			previewPDFTd.empty();
			previewPDFTd.append("<div id=\"pdf_div\" style=\"width:500px;height: 300px;font-size: 18px;border:#000 solid 1px;\">"
									+"<input id=\"id_hid\" type=\"hidden\" value=\""+id+"\"/>"
									+"<input id=\"labelType_hid\" type=\"hidden\" value=\""+labelType+"\"/>"
									+"<input id=\"qrcodeHGZUrl_hid\" type=\"hidden\" />"
									+"<img id=\"qrcode_img\" alt=\"\" src=\""+path+"/resource/images/qrcode.png\" style=\"width: 120px;height: 120px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
									+"<span id=\"cpxh_span\" style=\"margin-top: "+cpxhTop+"px;margin-left: "+cpxhLeft+"px;position: absolute;\">"+cpxh+"</span>"
									+"<span id=\"qpbh_span\" style=\"margin-top: "+qpbhTop+"px;margin-left: "+qpbhLeft+"px;position: absolute;\">"+qpqsbh+"</span>"
									+"<span id=\"gcrj_span\" style=\"margin-top: "+gcrjTop+"px;margin-left: "+gcrjLeft+"px;position: absolute;\">"+gcrj+"</span>"
									+"<span id=\"ndbh_span\" style=\"margin-top: "+ndbhTop+"px;margin-left: "+ndbhLeft+"px;position: absolute;\">"+ndbh+"</span>"
									+"<span id=\"zzrqY_span\" style=\"margin-top: "+zzrqYTop+"px;margin-left: "+zzrqYLeft+"px;position: absolute;\">"+zzrqY+"</span>"
									+"<span id=\"zzrqM_span\" style=\"margin-top: "+zzrqMTop+"px;margin-left: "+zzrqMLeft+"px;position: absolute;\">"+zzrqM+"</span>"
								+"</div>");
			/*
			if(labelType==1){
				previewPDFTd.append("<div id=\"pdf_div\" style=\"width:500px;height: 300px;border:#000 solid 1px;\">"
										+"<input id=\"id_hid\" type=\"hidden\" value=\""+id+"\"/>"
										+"<input id=\"labelType_hid\" type=\"hidden\" value=\""+labelType+"\"/>"
										+"<input id=\"qrcodeHGZUrl_hid\" type=\"hidden\" />"
										+"<img id=\"qrcode_img\" alt=\"\" src=\""+path+"/resource/images/qrcode.png\" style=\"width: 120px;height: 120px;margin-top: "+qrcodeTop+"px;margin-left: "+qrcodeLeft+"px;position: absolute;\">"
										+"<span id=\"cpxhTit1_span\" style=\"margin-top: 24px;margin-left: 120px;position: absolute;\">CNG2-G-</span>"
										+"<span id=\"cpxh_span\" style=\"margin-top: "+cpxhTop+"px;margin-left: "+cpxhLeft+"px;position: absolute;\">"+cpxh+"</span>"
										+"<span id=\"cpxhTit2_span\" style=\"margin-top: 24px;margin-left: 280px;position: absolute;\">-20B</span>"
										+"<span id=\"qpbhTit1_span\" style=\"margin-top: 68px;margin-left: 20px;position: absolute;\">气瓶编号:</span>"
										+"<span id=\"qpbh_span\" style=\"margin-top: "+qpbhTop+"px;margin-left: "+qpbhLeft+"px;position: absolute;\">"+qpqsbh+"</span>"
										+"<span id=\"cpbzh_span\" style=\"margin-top: 97px;margin-left: 20px;position: absolute;\">产品标准号:Q/Ng301(GB24160.MOD)</span>"
										+"<span id=\"czjz_span\" style=\"margin-top: 128px;margin-left: 20px;position: absolute;\">充装介质:CNG</span>"
										+"<span id=\"gcrjTit_span\" style=\"margin-top: 128px;margin-left: 250px;position: absolute;\">公称容积:</span>"
										+"<span id=\"gcrj_span\" style=\"margin-top: "+gcrjTop+"px;margin-left: "+gcrjLeft+"px;position: absolute;\">"+gcrj+"</span>"
										+"<span id=\"gcgzyl_span\" style=\"margin-top: 156px;margin-left: 20px;position: absolute;\">公称工作压力:20MPa:</span>"
										+"<span id=\"sysyyl_span\" style=\"margin-top: 156px;margin-left: 250px;position: absolute;\">水压试验压力:30MPa:</span>"
										+"<span id=\"gndsjbhTit1_span\" style=\"margin-top: 186px;margin-left: 20px;position: absolute;\">锅内胆设计壁厚:</span>"
										+"<span id=\"ndbh_span\" style=\"margin-top: "+ndbhTop+"px;margin-left: "+ndbhLeft+"px;position: absolute;\">"+ndbh+"</span>"
										+"<span id=\"gndsjbhTit2_span\" style=\"margin-top: 186px;margin-left: 190px;position: absolute;\">mm</span>"
										+"<span id=\"sjsynx_span\" style=\"margin-top: 186px;margin-left: 250px;position: absolute;\">设计使用年限:15年</span>"
										+"<span id=\"zzxkzbh_span\" style=\"margin-top: 215px;margin-left: 20px;position: absolute;\">制造许可证编号:TS2210A53</span>"
										+"<span id=\"zzrqTit1_span\" style=\"margin-top: 215px;margin-left: 290px;position: absolute;\">制造日期:</span>"
										+"<span id=\"zzrq_span\" style=\"margin-top: "+zzrqTop+"px;margin-left: "+zzrqLeft+"px;position: absolute;\">"+zzrq+"</span>"
										+"<span id=\"zzrqTit2_span\" style=\"margin-top: 215px;margin-left: 410px;position: absolute;\">年</span>"
										+"<span id=\"zzrqTit3_span\" style=\"margin-top: 215px;margin-left: 460px;position: absolute;\">月</span>"
										//+"<span id=\"gsmc_span\" style=\"margin-top: 240px;margin-left: 120px;position: absolute;\">湖北三江航天江北机械工程有限公司</span>"
										//+"<span id=\"fwrx_span\" style=\"margin-top: 266px;margin-left: 180px;position: absolute;\">服务热线：4001-066-980</span>"
									+"</div>");
			}
			*/
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

function checkQpbhExist(qpbh){
	var bool=false;
	$.ajaxSetup({async:false});
	$.post("checkAirBottleExistByQpbh",
		{qpbh:qpbh},
		function(data){
			if(data.message=="no"){
				bool=false;
			}
			else
				bool=true;
		}
	,"json");
	return bool;
}

function focusCPXH(){
	var cpxh = $("#cpxh_inp").val();
	if(cpxh=="产品型号不能为空"){
		$("#cpxh_inp").val("");
		$("#cpxh_inp").css("color", "#555555");
	}
}

//验证产品型号
function checkCPXH(){
	var cpxh = $("#cpxh_inp").val();
	if(cpxh==null||cpxh==""||cpxh=="产品型号不能为空"){
		$("#cpxh_inp").css("color","#E15748");
    	$("#cpxh_inp").val("产品型号不能为空");
    	return false;
	}
	else
		return true;
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

function focusGCRJ(){
	var gcrj = $("#gcrj_inp").val();
	if(gcrj=="公称容积不能为空"){
		$("#gcrj_inp").val("");
		$("#gcrj_inp").css("color", "#555555");
	}
}

//验证公称容积
function checkGCRJ(){
	var gcrj = $("#gcrj_inp").val();
	if(gcrj==null||gcrj==""||gcrj=="公称容积不能为空"){
		$("#gcrj_inp").css("color","#E15748");
    	$("#gcrj_inp").val("公称容积不能为空");
    	return false;
	}
	else
		return true;
}

function focusNDBH(){
	var ndbh = $("#ndbh_inp").val();
	if(ndbh=="内胆壁厚不能为空"){
		$("#ndbh_inp").val("");
		$("#ndbh_inp").css("color", "#555555");
	}
}

//验证内胆壁厚
function checkNDBH(){
	var ndbh = $("#ndbh_inp").val();
	if(ndbh==null||ndbh==""||ndbh=="内胆壁厚不能为空"){
		$("#ndbh_inp").css("color","#E15748");
    	$("#ndbh_inp").val("内胆壁厚不能为空");
    	return false;
	}
	else
		return true;
}

//验证制造日期年份
function checkZZRQY(){
	var zzrqY = $("#zzrqY_inp").val();
	if(zzrqY==null||zzrqY==""){
    	alert("制造日期年份不能为空");
    	return false;
	}
	else
		return true;
}

//验证制造日期月份
function checkZZRQM(){
	var zzrqM = $("#zzrqM_inp").val();
	if(zzrqM==null||zzrqM==""){
    	alert("制造日期月份不能为空");
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
	var addDivWidth=$("#add_div").css("width");
	addDivWidth=addDivWidth.substring(0,addDivWidth.length-2);
	var pwWidth=$(".panel.window").css("width");
	pwWidth=pwWidth.substring(0,pwWidth.length-2);
	return ((addDivWidth-pwWidth)/2)+"px";
}
</script>
</head>
<body>
<div class="layui-layout layui-layout-admin">
	<%@include file="top.jsp"%>
	<%@include file="left.jsp"%>
	<div id="add_div">
		<form id="form1" name="form1" method="post" action="editGoods" enctype="multipart/form-data">
			<table>
				<tr style="height: 45px;">
					<td style="width:40%;">产品型号：</td>
					<td>
						<input id="cpxh_inp" name="" type="text" maxlength="20" placeholder="例如:356-70" onfocus="focusCPXH()" onblur="checkCPXH()"/>
						<span style="color: #f00;">*</span>
					</td>
				</tr>
				<tr style="height: 45px;">
					<td>气瓶起始编号：</td>
					<td>
						<input id="qpqsbh_inp" name="" type="text" maxlength="20" placeholder="例如:CB19001001" value="CB19001001" onfocus="focusQpQsBh()" onblur="checkQpQsBh()"/>
						<span style="color: #f00;">*</span>
					</td>
				</tr>
				<tr style="height: 45px;">
					<td>气瓶结束编号：</td>
					<td>
						<input id="qpjsbh_inp" name="" type="text" maxlength="20" placeholder="例如:CB19001003" value="CB19001002" onfocus="focusQpJsBh()" onblur="checkQpJsBh()"/>
						<span style="color: #f00;">*</span>
					</td>
				</tr>
				<tr style="height: 45px;">
					<td>公称容积：</td>
					<td>
						<input id="gcrj_inp" name="" type="text" maxlength="20" placeholder="例如:70L" onfocus="focusGCRJ()" onblur="checkGCRJ()"/>
						<span style="color: #f00;">*</span>
					</td>
				</tr>
				<tr style="height: 45px;">
					<td>内胆壁厚：</td>
					<td>
						<input id="ndbh_inp" name="" type="text" maxlength="20" placeholder="例如:5.0" onfocus="focusNDBH()" onblur="checkNDBH()"/>
						<span style="color: #f00;">*</span>
					</td>
				</tr>
				<tr style="height: 45px;">
					<td>制造日期：</td>
					<td>
						<input id="zzrqY_inp" name="" type="text" size="6" maxlength="4" placeholder="例如:2019" onblur="checkZZRQY()"/>
						年
						<span style="color: #f00;">*</span>
						<input id="zzrqM_inp" name="" type="text" size="3" maxlength="2" placeholder="例如:11" onblur="checkZZRQM()"/>
						月
						<span style="color: #f00;">*</span>
					</td>
				</tr>
				<tr style="height: 360px;">
					<td>
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
							制造日期（年）：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqY_span','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqY_span','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqY_span','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqY_span','right')">右移</a>
						</div>
						<div style="height: 45px;">
							制造日期（月）：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqM_span','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqM_span','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqM_span','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('zzrqM_span','right')">右移</a>
						</div>
						<div style="height: 45px;">
							二维码：
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','up')">上移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','down')">下移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','left')">左移</a>
							<a class="easyui-linkbutton" onclick="resetPDFHtmlLocation('qrcode_img','right')">右移</a>
						</div>
					</td>
					<td id="previewPDF_td">
					</td>
					<!-- 
					<div id="pdf_div" style="width:500px;height: 300px;border:#000 solid 1px;">
						 <img alt="" src="<%=basePath %>/resource/images/qrcode.png" style="width: 80px;height: 80px;margin-top: 10px;margin-left: 300px;position: absolute;">
					     <span style="margin-top: 20px;margin-left: 150px;position: absolute;">356-70</span>
					     <span style="margin-top: 40px;margin-left: 90px;position: absolute;">CB190</span>
					     <span style="margin-top: 90px;margin-left: 210px;position: absolute;">70L</span>
					     <span style="margin-top: 140px;margin-left: 120px;position: absolute;">5.0</span>
					     <span style="margin-top: 190px;margin-left: 210px;position: absolute;">2019&nbsp;&nbsp;&nbsp;&nbsp;1</span>
					</div>
					 -->
				</tr>
			</table>
			<div id="outputPdf_div" style="display: none;">
			</div>
		</form>
	</div>
	<%@include file="foot.jsp"%>
</div>
</body>
</html>