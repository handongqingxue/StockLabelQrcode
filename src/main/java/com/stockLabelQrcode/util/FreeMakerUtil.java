package com.stockLabelQrcode.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

public class FreeMakerUtil {
	public static Template getHTML(String name,HttpServletRequest request) {
		try {
			//通过Freemarker的Configuration读取相应的ftl
			Configuration configuration = new Configuration();//这里是对应的你使用jar包的版本号：<version>2.3.23</version>
			String path=SystemPathUtil.getPath(request);
			configuration.setDefaultEncoding("GBK");
			configuration.setDirectoryForTemplateLoading(new File(path+"WEB-INF/flt/")); //如果是maven项目可以使用这种方式
			System.out.println(path+"WEB-INF/flt/");
			Template template = configuration.getTemplate(name);
			template.setEncoding("GBK");
			return template;
		} catch (IOException e) {
			e.printStackTrace();
		}

		return null;
	}
	public static void print(String name,Map<String, Object> root,HttpServletRequest request){
		//通过Template可以将模版文件输出到相应的文件流
		Template template = FreeMakerUtil.getHTML(name,request);
		try {
			template.process(root, new PrintWriter(System.out));//在控制台输出内容
		} catch (TemplateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public static String fprint(String name, Map<String, Object> root, String outFile,HttpServletRequest request) {
		BufferedWriter bw=null;
		try {
			String url = request.getScheme()+"://"+ request.getServerName()+request.getRequestURI()+"?"+request.getQueryString();
			System.out.println("获取全路径（协议类型：//域名/项目名/命名空间/action名称?其他参数）url="+url);
			String url2=request.getScheme()+"://"+ request.getServerName();//+request.getRequestURI();
			System.out.println("协议名：//域名="+url2);


			System.out.println("获取项目名="+request.getContextPath());
			System.out.println("获取参数="+request.getQueryString());
			System.out.println("获取全路径="+request.getRequestURL());

			
			// 通过一个文件输出流，就可以写到相应的文件中，此处用的是绝对路径
			String path=SystemPathUtil.getModelPath(request,outFile);
			FileOutputStream fos= new FileOutputStream(path);
			OutputStreamWriter osw =new OutputStreamWriter(fos, "utf-8");
			bw =new BufferedWriter(osw, 1024);
			Template temp = FreeMakerUtil.getHTML(name,request);
			temp.process(root, bw);
			return path+outFile;
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TemplateException e) {
			e.printStackTrace();
		} finally {
			try {
				if (bw != null)
					bw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
