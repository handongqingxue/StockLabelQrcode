<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<title>Insert title here</title>
</head>
<body>
<div style="width:100%;height: 300px;margin:0 auto;margin-top:10px;">
     <span style="margin-top: 20px;margin-left: 20px;position: absolute;">${requestScope.airBottle.cpxh }</span>
     <span style="margin-top: 60px;margin-left: 20px;position: absolute;">${requestScope.airBottle.qpbh }</span>
     <span style="margin-top: 100px;margin-left: 20px;position: absolute;">${requestScope.airBottle.zl }</span>
     <span style="margin-top: 140px;margin-left: 20px;position: absolute;">${requestScope.airBottle.scrj }</span>
     <span style="margin-top: 180px;margin-left: 20px;position: absolute;">${requestScope.airBottle.zzrq }</span>
     <span style="margin-top: 220px;margin-left: 20px;position: absolute;">${requestScope.airBottle.qpzzdw }</span>
     <span style="margin-top: 260px;margin-left: 20px;position: absolute;">支架型号：${requestScope.airBottle.qpzjxh }</span>
</div>
</body>
</html>