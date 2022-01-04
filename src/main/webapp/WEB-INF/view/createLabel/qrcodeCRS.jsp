<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<title>缠绕式标签</title>
<style>
.main_div{
	width:100%;
	height: 300px;
	margin:10px auto 0;
}
.main_div span{
	margin-left: 20px;
	position: absolute;
}
.main_div .cpxh_span{
	margin-top: 20px;
}
.main_div .cpxh_qc_span{
	margin-top: 60px;
}
.main_div .qpbh_span{
	margin-top: 100px;
}
.main_div .zl_span{
	margin-top: 140px;
}
.main_div .scrj_span{
	margin-top: 180px;
}
.main_div .zzrq_span{
	margin-top: 220px;
}
.main_div .qpzzdw_span{
	margin-top: 260px;
}
.main_div .qpzjxh_span{
	margin-top: 300px;
}
</style>
</head>
<body>
<div class="main_div">
     <span class="cpxh_span">${requestScope.airBottle.cpxh }</span>
     <span class="cpxh_qc_span">${requestScope.airBottle.cpxh_qc }</span>
     <span class="qpbh_span">${requestScope.airBottle.qpbh }</span>
     <span class="zl_span">${requestScope.airBottle.zl }</span>
     <span class="scrj_span">${requestScope.airBottle.scrj }</span>
     <span class="zzrq_span">${requestScope.airBottle.zzrq_y }${requestScope.airBottle.zzrq_m }</span>
     <span class="qpzzdw_span">${requestScope.airBottle.qpzzdw }</span>
     <span class="qpzjxh_span">支架型号：${requestScope.airBottle.qpzjxh }</span>
</div>
</body>
</html>