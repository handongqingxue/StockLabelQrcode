package com.stockLabelQrcode.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.stockLabelQrcode.util.JsonUtil;
import com.stockLabelQrcode.util.PlanResult;

import com.stockLabelQrcode.service.UtilService;

import com.stockLabelQrcode.entity.AccountMsg;
import com.stockLabelQrcode.entity.AirBottle;
import com.stockLabelQrcode.entity.PreviewCRSPDF;
import com.stockLabelQrcode.entity.PreviewCRSPDFSet;
import com.stockLabelQrcode.service.CreateLabelService;
import com.stockLabelQrcode.service.UserService;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

@Controller
@RequestMapping("/createLabel")
public class CreateLabelController {
	
	@Autowired
	private CreateLabelService createLabelService;
	@Autowired
	private UserService userService;
	@Autowired
	private UtilService utilService;
	
	/**
	 * 跳转至登录页面
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String login() {
		System.out.println("111111111111");
		return "/createLabel/login";
	}
	
	@RequestMapping(value="/login",method=RequestMethod.POST,produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String login(String userName,String password,String loginVCode,HttpServletRequest request) {
		System.out.println("===登录接口===");
		//返回值的json
		PlanResult plan=new PlanResult();
		HttpSession session=request.getSession();
		String verifyCode = (String) session.getAttribute("验证码");
		System.out.println("verifyCode==="+verifyCode);
		System.out.println("loginVCode==="+loginVCode);
		if(verifyCode.equals(loginVCode)) {
			//TODO在这附近添加登录储存信息步骤，将用户的账号以及密码储存到shiro框架的管理配置当中方便后续查询
			try {
				System.out.println("验证码一致");
				UsernamePasswordToken token = new UsernamePasswordToken(userName,password);  
				Subject currentUser = SecurityUtils.getSubject();  
				if (!currentUser.isAuthenticated()){
					//使用shiro来验证  
					token.setRememberMe(true);  
					currentUser.login(token);//验证角色和权限  
				}
			}catch (Exception e) {
				e.printStackTrace();
				plan.setStatus(1);
				plan.setMsg("登陆失败");
				return JsonUtil.getJsonFromObject(plan);
			}
			AccountMsg msg=(AccountMsg)SecurityUtils.getSubject().getPrincipal();
			session.setAttribute("user", msg);
			
			plan.setStatus(0);
			plan.setMsg("验证通过");
			plan.setUrl("/createLabel/toAirBottleList");
			return JsonUtil.getJsonFromObject(plan);
		}
		plan.setStatus(1);
		plan.setMsg("验证码错误");
		return JsonUtil.getJsonFromObject(plan);
	}

	//注册页面
	@RequestMapping(value = "/regist" , method = RequestMethod.GET)
	public String regist() {
		System.out.println("===注册页面===");
		return "/createLabel/regist";
	}
	
	//注册信息处理接口
	@RequestMapping(value = "/regist" , method = RequestMethod.POST,produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String subRegist(AccountMsg msg, HttpServletRequest request) {
		
		PlanResult plan=new PlanResult();
		int status=userService.saveUser(msg);
		if(status==2) {
			plan.setStatus(status);
			plan.setMsg("注册失败，用户已存在");
			return JsonUtil.getJsonFromObject(plan);
		}else if(status==0) {
			plan.setStatus(status);
			plan.setMsg("系统错误，请联系维护人员");
			return JsonUtil.getJsonFromObject(plan);
		}
		plan.setStatus(0);
		plan.setMsg("注册成功");
		plan.setData(msg);
		plan.setUrl("/createLabel/toAirBottleList");
		
		AccountMsg resultUser=userService.checkUser(msg);
		List<PreviewCRSPDF> pCrsPdflist=createLabelService.selectPreviewCRSPDF();
		PreviewCRSPDFSet pCrsPdfSet=null;
		for (PreviewCRSPDF pCrsPdf : pCrsPdflist) {
			pCrsPdfSet=new PreviewCRSPDFSet();
			pCrsPdfSet.setCpxh_left(pCrsPdf.getCpxh_left());
			pCrsPdfSet.setCpxh_top(pCrsPdf.getCpxh_top());
			pCrsPdfSet.setQpbh_left(pCrsPdf.getQpbh_left());
			pCrsPdfSet.setQpbh_top(pCrsPdf.getQpbh_top());
			pCrsPdfSet.setGcrj_left(pCrsPdf.getGcrj_left());
			pCrsPdfSet.setGcrj_top(pCrsPdf.getGcrj_top());
			pCrsPdfSet.setNdbh_left(pCrsPdf.getNdbh_left());
			pCrsPdfSet.setNdbh_top(pCrsPdf.getNdbh_top());
			pCrsPdfSet.setZzrq_left(pCrsPdf.getZzrq_left());
			pCrsPdfSet.setZzrq_top(pCrsPdf.getZzrq_top());
			pCrsPdfSet.setQrcode_left(pCrsPdf.getQrcode_left());
			pCrsPdfSet.setQrcode_top(pCrsPdf.getQrcode_top());
			pCrsPdfSet.setLabel_type(pCrsPdf.getLabel_type());
			pCrsPdfSet.setAccountNumber(resultUser.getId());
			
			int count=createLabelService.insertPreviewCRSPDFSet(pCrsPdfSet);
		}
		
		return JsonUtil.getJsonFromObject(plan);
	}
	
	/**
	 * 为登录页面获取验证码
	 * @param session
	 * @param identity
	 * @param response
	 */
	@RequestMapping("/login/captcha")
	public void getKaptchaImageByMerchant(HttpSession session, String identity, HttpServletResponse response) {
		utilService.getKaptchaImageByMerchant(session, identity, response);
	}
	
	@RequestMapping("/toAirBottleList")
	public String toAirBottleList() {
		
		return "/createLabel/airBottleList";
	}
	
	@RequestMapping("/toCreateBatch")
	public String toCreateBatch() {
		
		return "/createLabel/createBatch";
	}
	
	@RequestMapping("/toPreviewHGZPdf")
	public String toPreviewHGZPdf() {
		
		return "/createLabel/previewHGZPdf";
	}
	
	@RequestMapping("/toQrcodeHGZ")
	public String toQrcodeHGZ(String id,HttpServletRequest request) {
		
		AirBottle airBottle = createLabelService.getAirBottleById(id);
		
		request.setAttribute("airBottle", airBottle);
		return "/createLabel/qrcodeHGZ";
	}
	
	@RequestMapping(value="/selectCRSPdfSet")
	@ResponseBody
	public Map<String, Object> selectCRSPdfSet(Integer labelType, String accountNumber) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		PreviewCRSPDFSet crsPdfSet=createLabelService.selectCRSPdfSet(labelType,accountNumber);
		
		jsonMap.put("crsPdfSet", crsPdfSet);
		
		return jsonMap;
	}

	@RequestMapping(value="/insertAirBottleRecord")
	@ResponseBody
	public Map<String, Object> insertAirBottleRecord(AirBottle airBottle, String qpbhsStr) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		String[] qpbhArr = qpbhsStr.split(",");
		
		int count = 0;
		for (int i = 0; i < qpbhArr.length; i++) {
			airBottle.setQpbh(qpbhArr[i]);
			count += createLabelService.insertAirBottleRecord(airBottle);
		}
		
		if(count==qpbhArr.length) {
			jsonMap.put("message", "ok");
			jsonMap.put("info", "生成历史记录成功！");
		}
		else {
			jsonMap.put("message", "no");
			jsonMap.put("info", "生成历史记录失败！");
		}
		
		return jsonMap;
	}
	
	@RequestMapping(value="/checkAirBottleExistByQpbh")
	@ResponseBody
	public Map<String, Object> checkAirBottleExistByQpbh(String qpbh) {

		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		if(createLabelService.checkAirBottleExistByQpbh(qpbh)) {
			jsonMap.put("message", "no");
			jsonMap.put("info", "气瓶编号已存在！");
		}
		else {
			jsonMap.put("message", "ok");
		}
		
		return jsonMap;
	}
	
	@RequestMapping(value="/queryAirBottleList")
	@ResponseBody
	public Map<String, Object> queryAirBottleList(String qpbh,int page,int rows,String sort,String order) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		int count = createLabelService.queryAirBottleForInt(qpbh);
		List<AirBottle> abList = createLabelService.queryAirBottleList(qpbh, page, rows, sort, order);
		
		jsonMap.put("total", count);
		jsonMap.put("rows", abList);
		return jsonMap;
	}
	
	@RequestMapping(value="/updateAirBottleRecord",produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String updateAirBottleRecord(@RequestParam(value="excel_file",required=false) MultipartFile excel_file,String qpbhsStr) {
		
		PlanResult plan=new PlanResult();
		int count = 0;
		
        try {
        	String[] qpbhArr = qpbhsStr.split(",");
        	
			// 创建输入流，读取Excel  
			InputStream is = excel_file.getInputStream();  
			// jxl提供的Workbook类  
			Workbook wb = Workbook.getWorkbook(is);  
			// Excel的页签数量  
			int sheet_size = wb.getNumberOfSheets();  
			for (int index = 0; index < sheet_size; index++) {  
			    // 每个页签创建一个Sheet对象  
			    Sheet sheet = wb.getSheet(index);  
			    // sheet.getRows()返回该页的总行数  
			    for (int i = 1; i < sheet.getRows(); i++) {  
			    	/*
			        // sheet.getColumns()返回该页的总列数  
			        for (int j = 0; j < sheet.getColumns(); j++) {  
			            String cellinfo = sheet.getCell(j, i).getContents();  
			            System.out.print(cellinfo+"   ");  
			        }
			        System.out.println("  ");
			        */
			    	String qpbh = sheet.getCell(1, i).getContents();
			    	if(StringUtils.isEmpty(qpbh))
			    		continue;
			    	for (String qpbh1 : qpbhArr) {
				        if(qpbh.equals(qpbh1)) {
				        	String zl = sheet.getCell(2, i).getContents();
				        	String scrj = sheet.getCell(3, i).getContents();
				        	String qpzjxh = sheet.getCell(4, i).getContents();
				        	String qpzzdw = sheet.getCell(5, i).getContents();
					        System.out.println("zl==="+zl);
					        System.out.println("scrj==="+scrj);
					        System.out.println("qpzjxh==="+qpzjxh);
					        System.out.println("qpzzdw==="+qpzzdw);
					        
					        AirBottle airBottle=new AirBottle();
					        airBottle.setQpbh(qpbh);
					        airBottle.setZl(zl);
					        airBottle.setScrj(scrj);
					        airBottle.setQpzjxh(qpzjxh);
					        airBottle.setQpzzdw(qpzzdw);
					        count += createLabelService.updateAirBottle(airBottle);
				        }
					}
			    }  
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String json;
		if(count==0) {
			plan.setStatus(0);
			plan.setMsg("导入失败！");
			json=JsonUtil.getJsonFromObject(plan);
		}
		else {
			plan.setStatus(1);
			plan.setMsg("导入成功！");
			json=JsonUtil.getJsonFromObject(plan);
		}
		return json;
	}
	
	@RequestMapping(value="/goEditAirBottle")
	public String goEditAirBottle(HttpServletRequest request, String id) {
		
		AirBottle airBottle=createLabelService.getAirBottleById(id);
		request.setAttribute("airBottle", airBottle);
		return "/createLabel/editAirBottle";
	}
	
	@RequestMapping(value="/editAirBottle")
	@ResponseBody
	public Map<String, Object> editAirBottle(AirBottle airBottle) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		int count=createLabelService.editAirBottle(airBottle);
		if(count>0) {
			jsonMap.put("message", "ok");
			jsonMap.put("info", "编辑成功！");
		}
		else {
			jsonMap.put("message", "no");
			jsonMap.put("info", "编辑失败！");
		}
		return jsonMap;
	}
	
	@RequestMapping(value="/deleteAirBottle",produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String deleteAirBottle(String ids) {
		
		int count=createLabelService.deleteAirBottle(ids);
		PlanResult plan=new PlanResult();
		String json;
		if(count==0) {
			plan.setStatus(0);
			plan.setMsg("删除失败");
			json=JsonUtil.getJsonFromObject(plan);
		}
		else {
			plan.setStatus(1);
			plan.setMsg("删除成功");
			json=JsonUtil.getJsonFromObject(plan);
		}
		return json;
	}

}
