<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<script type="text/javascript">

</script>
<style type="text/css">
.side {
	position: fixed;
	top: 50px;
	bottom: 0;
	height: 100%;
	justify-content: center;
	display: flex;
}

.head {
	align-items: center;
	position: relative;
	height: 50px;
	background-color: #20A0FF !important;
}

.headTitle, .headTitle>h1 {
	padding-left: 15px;
	margin: 0px auto;
}
.layui-nav .layui-nav-item a{
	color:#000;
}
.layui-nav .layui-nav-item .pointer-img{
	margin-top: 18px;
	margin-left: 18px;
	position: absolute;
}
.layui-nav .first-level{
    font-size: 15px;
	font-weight: bold;
	background-color: #E7F4FD;
}
.layui-nav,.layui-side{
	background-color: #FAFDFE;
}
.layui-side{
	border-right:#86B9D6 solid 1px;
}
</style>
<div class="layui-side ">
	<div class="layui-side-scroll">
		<ul class="layui-nav layui-nav-tree layui-inline" lay-filter="demo"
			style="margin-right: 10px;height: 800px;overflow-y:scroll;">
			<div style="width: 92%; margin: 0 auto; margin-top: 20px;border: #CAD9EA solid 1px;background-color: #F5FAFE;">
				<li class="layui-nav-item first-level">
					<a>
						产品管理
					</a>
				</li>
				<div style="width:100%;height: 1px;background-color: #CAD9EA;"></div>
				<li class="layui-nav-item">
					<img class="pointer-img" alt="" src="<%=basePath%>resource/images/ico_3.gif" />
					<a href="<%=basePath%>createLabel/toCreateBatch">
						&nbsp;&nbsp;&nbsp;创建批次
					</a>
				</li>
				<div style="width:100%;height: 1px;background-color: #CAD9EA;"></div>
				<li class="layui-nav-item">
					<img class="pointer-img" alt="" src="<%=basePath%>resource/images/ico_3.gif" />
					<a href="<%=basePath%>createLabel/toAirBottleList">
						&nbsp;&nbsp;&nbsp;历史记录
					</a>
				</li>
				<div style="width:100%;height: 1px;background-color: #CAD9EA;"></div>
				<li class="layui-nav-item">
					<img class="pointer-img" alt="" src="<%=basePath%>resource/images/ico_3.gif" />
					<a href="<%=basePath%>createLabel/toInputExcel">
						&nbsp;&nbsp;&nbsp;导入检测数据
					</a>
				</li>
				<li class="layui-nav-item first-level">
					<a>
						产品查询
					</a>
				</li>
				<div style="width:100%;height: 1px;background-color: #CAD9EA;"></div>
				<li class="layui-nav-item">
					<img class="pointer-img" alt="" src="<%=basePath%>resource/images/ico_3.gif" />
					<a href="<%=basePath%>createLabel/toBatchList">
						&nbsp;&nbsp;&nbsp;批次查询
					</a>
				</li>
			</div>
		</ul>
	</div>
</div>