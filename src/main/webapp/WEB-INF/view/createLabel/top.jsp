<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<style type="text/css">
.layui-layout-admin .layui-header{
	/*
	background-color:  #E7F4FD;
	*/
	background-color:  #20A0FF;
}
.layui-header a{
	color:#fff;
}
</style>
<div style="width:100%;height: 40px;line-height: 40px;">
	<span style="margin-left: 25px;">湖北三江航天江北机械工程有限公司</span>
</div>
<div class="layui-header ">
	<div class="layui-logo">
		<a>库存标签二维码系统</a>
	</div>
	<div style="margin-left: 250px;height: 40px;line-height: 40px;">
		<div style="width: 100px;text-align: center;font-size: 16px;"><a href="<%=basePath%>createLabel/toCreateBatch">首页</a></div>
		<div style="width: 150px;text-align: center;font-size: 16px;margin-top: -40px;margin-left: 100px;"><a href="<%=basePath%>createLabel/toAirBottleList">历史记录</a></div>
		<div style="width: 150px;text-align: center;font-size: 16px;margin-top: -40px;margin-left: 250px;"><a>导出Pdf</a></div>
	</div>
	<ul class="layui-nav layui-layout-right">
		<li class="layui-nav-item">
			<a href="javascript:;"> 
				<img src="http://t.cn/RCzsdCq" class="layui-nav-img">
				<span style="color: #fff;">${sessionScope.user.nickName }</span>
			</a>
		</li>
		<li class="layui-nav-item">
			<a style="color: #fff;" href="<%=basePath%>merchant/exit">退出</a>
		</li>
	</ul>
</div>