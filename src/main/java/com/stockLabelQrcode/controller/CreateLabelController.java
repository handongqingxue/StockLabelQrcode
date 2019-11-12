package com.stockLabelQrcode.controller;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.stockLabelQrcode.entity.AccountMsg;
import com.stockLabelQrcode.entity.AirBottle;
import com.stockLabelQrcode.entity.PreviewCRSPDF;
import com.stockLabelQrcode.entity.PreviewCRSPDFSet;
import com.stockLabelQrcode.service.CreateLabelService;
import com.stockLabelQrcode.service.UserService;
import com.stockLabelQrcode.service.UtilService;
import com.stockLabelQrcode.util.JsonUtil;
import com.stockLabelQrcode.util.PlanResult;
import com.stockLabelQrcode.util.qrcode.Qrcode;

import jxl.Sheet;
import jxl.Workbook;

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
		return "/createLabel/login";
	}
	
	/**
	 * 调用登录接口登录
	 * @param userName
	 * @param password
	 * @param loginVCode
	 * @param request
	 * @return
	 */
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

	/**
	 * 跳转到注册页面
	 * @return
	 */
	@RequestMapping(value = "/regist" , method = RequestMethod.GET)
	public String regist() {
		System.out.println("===注册页面===");
		return "/createLabel/regist";
	}
	
	/**
	 * 注册信息处理接口
	 * @param msg
	 * @param request
	 * @return
	 */
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
	
	/**
	 * 跳转到历史记录查询页面
	 * @return
	 */
	@RequestMapping("/toAirBottleList")
	public String toAirBottleList() {
		
		return "/createLabel/airBottleList";
	}
	
	/**
	 * 跳转到创建批次页面
	 * @return
	 */
	@RequestMapping("/toCreateBatch")
	public String toCreateBatch() {
		
		return "/createLabel/createBatch";
	}
	
	/**
	 * 跳转到预览生成的合格证pdf页面
	 * @return
	 */
	@RequestMapping("/toPreviewHGZPdf")
	public String toPreviewHGZPdf() {
		
		return "/createLabel/previewHGZPdf";
	}

	/**
	 * 扫码后跳转到产品信息页面
	 * @param action
	 * @param qpbh
	 * @param request
	 * @return
	 */
	@RequestMapping("/toQrcodeInfo")
	public String toQrcodeInfo(String action,String qpbh,HttpServletRequest request) {
		
		//http://localhost:8088/GoodsPublic/createLabel/toQrcode?action=crs&qpbh=CB19001006
		AirBottle airBottle = createLabelService.getAirBottleByQpbh(qpbh);
		
		request.setAttribute("airBottle", airBottle);
		String url=null;
		if("crs".equals(action))
			url="/createLabel/qrcodeCRS";
		else if("hgz".equals(action))
			url="/createLabel/qrcodeHGZ";
		return url;
	}
	
	/**
	 * 根据格式，查询缠绕式pdf模板方位参数配置
	 * @param labelType
	 * @param accountNumber
	 * @return
	 */
	@RequestMapping(value="/selectCRSPdfSet")
	@ResponseBody
	public Map<String, Object> selectCRSPdfSet(Integer labelType, String accountNumber) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		PreviewCRSPDFSet crsPdfSet=createLabelService.selectCRSPdfSet(labelType,accountNumber);
		
		jsonMap.put("crsPdfSet", crsPdfSet);
		
		return jsonMap;
	}

	/**
	 * 插入历史记录
	 * @param airBottle
	 * @param qpbhsStr
	 * @return
	 */
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
	
	/*
	@RequestMapping("/toQrcodeHGZ")
	public String toQrcodeHGZ(String id,HttpServletRequest request) {
		
		AirBottle airBottle = createLabelService.getAirBottleById(id);
		
		request.setAttribute("airBottle", airBottle);
		return "/createLabel/qrcodeHGZ";
	}
	*/
	
	/**
	 * 根据气瓶编号，验证该气瓶是否已存在
	 * @param qpbh
	 * @return
	 */
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
	
	/**
	 * 查询历史记录
	 * @param qpbh
	 * @param page
	 * @param rows
	 * @param sort
	 * @param order
	 * @return
	 */
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
	
	/**
	 * 编辑导入的产品记录信息
	 * @param excel_file
	 * @param qpbhsStr
	 * @return
	 */
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
	
	/**
	 * 跳转到编辑气瓶信息页面
	 * @param request
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/goEditAirBottle")
	public String goEditAirBottle(HttpServletRequest request, String id) {
		
		AirBottle airBottle=createLabelService.getAirBottleById(id);
		request.setAttribute("airBottle", airBottle);
		return "/createLabel/editAirBottle";
	}
	
	/**
	 * 编辑气瓶信息
	 * @param airBottle
	 * @return
	 */
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
	
	/**
	 * 删除气瓶信息
	 * @param ids
	 * @return
	 */
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

	/**
	 * 重新设置预览pdf模板里的方位参数
	 * @param pCrsPdfSet
	 * @return
	 */
	@RequestMapping(value="/editPreviewCrsPdfSet")
	@ResponseBody
	public Map<String, Object> editPreviewCrsPdfSet(PreviewCRSPDFSet pCrsPdfSet) {

		Map<String, Object> jsonMap = new HashMap<String, Object>();
		try {
			int count=createLabelService.editPreviewCrsPdfSet(pCrsPdfSet);
			if(count>0) {
				jsonMap.put("message", "ok");
				jsonMap.put("info", "编辑成功！");
			}
			else {
				jsonMap.put("message", "no");
				jsonMap.put("info", "编辑失败！");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			return jsonMap;
		}
	}
	
	/**
	 * 生成二维码
	 * @param url
	 * @param qpbh
	 * @return
	 */
	@RequestMapping(value="/createQrcode")
	@ResponseBody
	public Map<String, Object> createQrcode(String url, String qpbh) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		String fileName = qpbh+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".jpg";
		String avaPath="/GoodsPublic/upload/"+fileName;
		String path = "D:/resource";
        Qrcode.createQrCode(url, path, fileName);
        
        jsonMap.put("qrcodeUrl", avaPath);
		
		return jsonMap;
	}

}
