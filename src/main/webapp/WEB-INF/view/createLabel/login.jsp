<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>库存标签二维码系统登录</title>
<%@include file="js.jsp"%>
<style>
.beg-login-box {
	width: 450px;
	height: 270px;
	margin: 10% auto;
	background-color: rgba(255, 255, 255, 0.407843);
	border-radius: 10px;
	color: aliceblue;
}

.beg-login-main {
	height: 185px;
	padding: 0px 90px 0px;
}

header {
	justify-content: center;
	display: flex;
	padding-top: 20px;
}

body {
	font-size: 12px;
	background-color: #000;
}

.beg-pull-right {
	float: right;
}

.beg-pull-left {
	float: left;
}
</style>
</head>
<body>
	<div class="beg-login-box">
		<header>
		<h1>库存标签二维码系统登录</h1>
		</header>
		<div class="beg-login-main">
			<form class="layui-form" method="post">
				<div class="layui-form-item">
					<label class="beg-login-icon"> <i class="layui-icon">&#xe612;</i>
					</label> <input type="text" name="userName" placeholder="请输入登录名"
						class="layui-input" lay-verify="required|userName"
						autocomplete="off" value="${sessionScope.user.userName }">
				</div>
				<div class="layui-form-item">
					<label class="beg-login-icon"> <i class="layui-icon">&#xe642;</i>
					</label> <input type="password" name="password" placeholder="请输入密码"
						class="layui-input" lay-verify="required|password_"
						autocomplete="off" value="${sessionScope.user.passWord }">
				</div>
				<div class="layui-form-item">
					<div class="beg-pull-left ">
						<button class="layui-btn layui-btn-primary" lay-submit=""
							lay-filter="login">
							<i class="layui-icon">&#xe650;</i> 登录
						</button>
					</div>
					<div class="beg-pull-right">
						<a class="layui-btn layui-btn-primary"
							href="<%=basePath%>createLabel/regist">注册新用户</a>
					</div>
					<div class="beg-clear"></div>
				</div>
			</form>
		</div>
	</div>
</body>
<script type="text/javascript" src="<%=basePath %>resource/js/MD5.js"></script>
<script type="text/javascript">
    //更换验证码
    var baseUrl="${pageContext.request.contextPath}"
    //form提交
    layui.use(['layer', 'form'], function () {
        var layer = layui.layer,
            $ = layui.jquery,
            form = layui.form;
        //监听提交按钮
        form.on('submit(login)', function (data) {
            $(data.elem).attr('class', 'layui-btn layui-btn-disabled');
            var url=baseUrl + "/createLabel/login"
            var params = {
                userName: data.field.userName,
                password: MD5(data.field.password).toUpperCase(),
                rememberMe : data.field.rememberMe,
            };
            $.post(url,params,function(result){
            	var json=JSON.parse(result); 
            	console.log(json)
            	if(json.status==0){
            		layer.msg(json.msg, {icon: 6});
            		window.location.href=baseUrl+json.url;
            	}else if(json.status==1){
            		layer.alert(json.msg,{icon:5})
            	}
            	return false;
            })
            return false;
        });

        //自定义验证规则
        form.verify({
            userName: function (value) {
                if (!new RegExp("^[a-zA-Z0-9_\u4e00-\u9fa5\\s·]+$").test(value)) {
                    return '用户名不能有特殊字符';
                }
                if (/(^\_)|(\__)|(\_+$)/.test(value)) {
                    return '用户名首尾不能出现下划线\'_\'';
                }
              //  if(!/^1[3|4|5|7|8][0-9]{9}$/.test(value)){
             //       return '请输入正确用户名（手机号）';
              //  }
            },
            verifyCode: function (value) {
                if (value === '') {
                    return '验证码不能为空'
                } else if (value.length > 4) {
                    return '请输入四个字母验证码'
                } else if (value.length < 4) {
                    return '请输入四个字母验证码'
                }
            }
        });
    });
</script>
</html>