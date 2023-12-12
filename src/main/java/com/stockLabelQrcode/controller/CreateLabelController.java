package com.stockLabelQrcode.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.json.JSONArray;
import org.json.JSONObject;
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
import com.stockLabelQrcode.entity.PreviewPdfJson;
import com.stockLabelQrcode.service.CreateLabelService;
import com.stockLabelQrcode.service.UserService;
import com.stockLabelQrcode.service.UtilService;
import com.stockLabelQrcode.util.JsonUtil;
import com.stockLabelQrcode.util.PlanResult;
import com.stockLabelQrcode.util.qrcode.Qrcode;

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
	public String login(String userName,String password,HttpServletRequest request) {
		System.out.println("===登录接口===");
		//返回值的json
		PlanResult plan=new PlanResult();
		HttpSession session=request.getSession();
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
		plan.setUrl("/createLabel/toCreateBatch");
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
		plan.setUrl("/createLabel/toCreateBatch");
		
		AccountMsg resultUser=userService.checkUser(msg);
		List<PreviewCRSPDF> pCrsPdflist=createLabelService.selectPreviewCRSPDF();
		PreviewCRSPDFSet pCrsPdfSet=null;
		for (PreviewCRSPDF pCrsPdf : pCrsPdflist) {
			pCrsPdfSet=new PreviewCRSPDFSet();
			pCrsPdfSet.setCpxh_left(pCrsPdf.getCpxh_left());
			pCrsPdfSet.setCpxh_top(pCrsPdf.getCpxh_top());
			pCrsPdfSet.setTybm_left(pCrsPdf.getTybm_left());
			pCrsPdfSet.setTybm_top(pCrsPdf.getTybm_top());
			pCrsPdfSet.setTybm_font_size(pCrsPdf.getTybm_font_size());
			pCrsPdfSet.setQpbh_left(pCrsPdf.getQpbh_left());
			pCrsPdfSet.setQpbh_top(pCrsPdf.getQpbh_top());
			pCrsPdfSet.setGcrj_left(pCrsPdf.getGcrj_left());
			pCrsPdfSet.setGcrj_top(pCrsPdf.getGcrj_top());
			pCrsPdfSet.setNdbh_left(pCrsPdf.getNdbh_left());
			pCrsPdfSet.setNdbh_top(pCrsPdf.getNdbh_top());
			pCrsPdfSet.setZzrq_y_left(pCrsPdf.getZzrq_y_left());
			pCrsPdfSet.setZzrq_y_top(pCrsPdf.getZzrq_y_top());
			pCrsPdfSet.setZzrq_m_left(pCrsPdf.getZzrq_m_left());
			pCrsPdfSet.setZzrq_m_top(pCrsPdf.getZzrq_m_top());
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
	
	@RequestMapping(value="/exit")
	public String exit(HttpSession session) {
		System.out.println("退出接口");
		 Subject currentUser = SecurityUtils.getSubject();       
	       currentUser.logout();    
		return "/createLabel/login";
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
	 * 跳转到历史记录查询页面
	 * @return
	 */
	@RequestMapping("/toAirBottleList")
	public String toAirBottleList() {
		
		return "/createLabel/airBottleList";
	}
	
	/**
	 * 跳转到导入检测数据页面
	 * @return
	 */
	@RequestMapping("/toInputExcel")
	public String toIndex() {
		
		return "/createLabel/inputExcel";
	}
	
	/**
	 * 跳转到导出Pdf页面
	 * @return
	 */
	@RequestMapping("/toOutputPdf")
	public String toOutputPdf() {
		
		return "/createLabel/outputPdf";
	}
	
	/**
	 * 跳转到预览生成的缠绕式pdf页面
	 * @return
	 */
	@RequestMapping("/toPreviewCRSPdf")
	public String toPreviewCRSPdf() {
		
		return "/createLabel/previewCRSPdf";
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
	 * 跳转到批次查询页面
	 * @return
	 */
	@RequestMapping("/toBatchList")
	public String toBatchList() {
		
		return "/createLabel/batchList";
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
		String url=null;
		System.out.println("airBottle==="+airBottle);
		if(airBottle==null) {
			request.setAttribute("message", "气瓶已被删除");
			url="/createLabel/warn";
		}
		else {
			String cjljdz = airBottle.getCjljdz();
			if(StringUtils.isEmpty(cjljdz)) {
				request.setAttribute("airBottle", airBottle);
				if("crs".equals(action))
					url="/createLabel/qrcodeCRS";
				else if("hgz".equals(action))
					url="/createLabel/qrcodeHGZ";
			}
			else
				url="redirect:"+cjljdz;
		}
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
	public Map<String, Object> insertAirBottleRecord(AirBottle airBottle, String qpbhsStr, String qrcodeCRSUrlsStr, String qrcodeHGZUrlsStr) {
		
		System.out.println("insertAirBottleRecord.......");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		String[] qpbhArr = qpbhsStr.split(",");
		String[] qrcodeCRSUrlArr = qrcodeCRSUrlsStr.split(",");
		String[] qrcodeHGZUrlArr = qrcodeHGZUrlsStr.split(",");
		
		int count = 0;
		for (int i = 0; i < qpbhArr.length; i++) {
			airBottle.setQpbh(qpbhArr[i]);
			airBottle.setQrcode_crs_url(qrcodeCRSUrlArr[i]);
			airBottle.setQrcode_hgz_url(qrcodeHGZUrlArr[i]);
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
	
	@RequestMapping(value="/getExistQpbhListByQpbhs")
	@ResponseBody
	public Map<String, Object> getExistQpbhListByQpbhs(String qpbhs) {

		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		List<String> qpbhList=createLabelService.getExistQpbhListByQpbhs(qpbhs);
		
		jsonMap.put("existQpbhList", qpbhList);
		
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
	
	@RequestMapping(value="/queryBatchList")
	@ResponseBody
	public Map<String, Object> queryBatchList(String cpxh,String qpbh,String qpzjxh,String zzrq_y,String zzrq_m,String qpzzdw,int page,int rows,String sort,String order) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		int count = createLabelService.queryBatchForInt(cpxh, qpbh, qpzjxh, zzrq_y, zzrq_m, qpzzdw);
		List<AirBottle> batchList = createLabelService.queryBatchList(cpxh, qpbh, qpzjxh, zzrq_y, zzrq_m, qpzzdw, page, rows, sort, order);
		
		jsonMap.put("total", count);
		jsonMap.put("rows", batchList);
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
	public String updateAirBottleRecord(String qpbhsStr,String qpJAStr) {
		
		PlanResult plan=new PlanResult();
		int count = 0;
		
        try {
        	String[] qpbhArr = qpbhsStr.split(",");//这是上方表格里选中的数据
        	JSONArray qpJA = new JSONArray(qpJAStr);//这是下方Excel表格里的数据
        	
			    for (int i = 0; i < qpJA.length(); i++) {  
			    	JSONObject qpJO = (JSONObject)qpJA.get(i);
			    	String qpbh1 = qpJO.get("qpbh").toString();
			    	if(StringUtils.isEmpty(qpbh1))
			    		continue;
			    	for (String qpbh : qpbhArr) {
				        if(qpbh.equals(qpbh1)) {
				        	String cpxh_qc = qpJO.get("cpxh_qc").toString();
				        	String zl = qpJO.get("zl").toString().replaceAll("\"", "");
				        	String scrj = qpJO.get("scrj").toString().replaceAll("\"", "");
				        	String qpzjxh = qpJO.get("qpzjxh").toString();
				        	String qpzzdw = qpJO.get("qpzzdw").toString();
				        	String cjljdz = qpJO.get("cjljdz").toString();
				        	String tybm = qpJO.get("tybm").toString();
				        	/*
					        System.out.println("zl==="+zl);
					        System.out.println("scrj==="+scrj);
					        System.out.println("qpzjxh==="+qpzjxh);
					        System.out.println("qpzzdw==="+qpzzdw);
					        System.out.println("cjljdz==="+cjljdz);
					        System.out.println("tybm==="+tybm);
					        */
					        
					        AirBottle airBottle=new AirBottle();
					        airBottle.setQpbh(qpbh);
					        airBottle.setCpxh_qc(cpxh_qc);
					        airBottle.setZl(zl);
					        airBottle.setScrj(scrj);
					        airBottle.setQpzjxh(qpzjxh);
					        airBottle.setQpzzdw(qpzzdw);
					        airBottle.setCjljdz(cjljdz);
					        airBottle.setTybm(tybm);
					        count += createLabelService.updateAirBottle(airBottle);
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
	
	@RequestMapping(value="/loadExcelData",produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String loadExcelData(@RequestParam(value="excel_file",required=false) MultipartFile excel_file) {
		PlanResult plan=new PlanResult();
		String json=null;
		try {
			System.out.println(excel_file.getSize());
			// 创建输入流，读取Excel  
			InputStream is = excel_file.getInputStream();  
			// jxl提供的Workbook类  
			Workbook wb = Workbook.getWorkbook(is);  
			// Excel的页签数量  
			int sheet_size = wb.getNumberOfSheets();  
			
			List<AirBottle> abList=new ArrayList<AirBottle>();
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
			    	String cpxh_qc = sheet.getCell(0, i).getContents();
			    	String qpbh = sheet.getCell(1, i).getContents();
		        	String zl = sheet.getCell(2, i).getContents().replaceAll("\"", "");
		        	String scrj = sheet.getCell(3, i).getContents().replaceAll("\"", "");
		        	String qpzjxh = sheet.getCell(4, i).getContents();
		        	String qpzzdw = sheet.getCell(5, i).getContents();
		        	String cjljdz = sheet.getCell(6, i).getContents();
			        System.out.println("zl==="+zl);
			        System.out.println("scrj==="+scrj);
			        System.out.println("qpzjxh==="+qpzjxh);
			        System.out.println("qpzzdw==="+qpzzdw);
			        System.out.println("cjljdz==="+cjljdz);
			        
			        AirBottle airBottle=new AirBottle();
			        airBottle.setCpxh_qc(cpxh_qc);
			        airBottle.setQpbh(qpbh);
			        airBottle.setZl(zl);
			        airBottle.setScrj(scrj);
			        airBottle.setQpzjxh(qpzjxh);
			        airBottle.setQpzzdw(qpzzdw);
			        airBottle.setCjljdz(cjljdz);
			        if(!StringUtils.isEmpty(cjljdz))
			        	airBottle.setTybm(cjljdz.substring(cjljdz.lastIndexOf("/")+1, cjljdz.length()));
			        abList.add(airBottle);
			    }  
			}
			plan.setStatus(1);
			plan.setData(abList);
			json=JsonUtil.getJsonFromObject(plan);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			plan.setStatus(0);
			plan.setMsg("查询失败！");
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
	 * 根据id删除气瓶信息
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/deleteAirBottleById",produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String deleteAirBottleById(String ids) {
		
		int count=createLabelService.deleteAirBottleById(ids);
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
	 * 根据气瓶编号删除气瓶信息
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/deleteAirBottleByQpbhs",produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String deleteAirBottleByQpbhs(String qpbhsStr) {
		
		int count=createLabelService.deleteAirBottleByQpbhs(qpbhsStr);
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
	 * 根据气瓶编号查询气瓶信息
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/selectAirBottleByQpbhs",produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String selectAirBottleByQpbhs(String qpbhsStr) {

		PlanResult plan=new PlanResult();
		String json;
		
		List<AirBottle> abList = createLabelService.selectAirBottleByQpbhs(qpbhsStr);
		if(abList.size()==0) {
			plan.setStatus(0);
			plan.setMsg("获取预览信息失败！");
			json=JsonUtil.getJsonFromObject(plan);
		}
		else {
			String uuid = UUID.randomUUID().toString().replaceAll("-", "");
			
			PreviewPdfJson ppj=new PreviewPdfJson();
			ppj.setUuid(uuid);
			ppj.setData(new JSONArray(abList).toString());
			int i=createLabelService.insertPrePdfJson(ppj);
			
			plan.setStatus(1);
			plan.setData(uuid);;
			json=JsonUtil.getJsonFromObject(plan);
		}
		return json;
	}
	
	@RequestMapping(value="/getPrePdfJsonByUuid",produces="plain/text; charset=UTF-8")
	@ResponseBody
	public String getPrePdfJsonByUuid(String uuid) {

		PlanResult plan=new PlanResult();
		String json;

		PreviewPdfJson ppf = createLabelService.selectPrePdfJsonByUuid(uuid);
		plan.setData(ppf.getData());
		json=JsonUtil.getJsonFromObject(plan);
		
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
	public Map<String, Object> createQrcode(String url, String action, String qpbh) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		String time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		//System.out.println("time="+time);
		String folderName = time.substring(0, 6);
		String fileName = action+qpbh+ time + ".jpg";
		String avaPath="/StockLabelQrcode/upload/"+folderName+"/"+fileName;
		String path = "D:/resource/StockLabelQrcode/"+folderName;
		Qrcode.createQrCode(url, path, fileName);
        
        jsonMap.put("qrcodeUrl", avaPath);
		
		return jsonMap;
	}
	
	@RequestMapping(value="/putQrocdeInFolder")
	@ResponseBody
	public Map<String, Object> putQrocdeInFolder(HttpServletRequest request) {
		
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		
		List<String> qpbhCrsList=new ArrayList<String>();
		List<String> qpbhHgzList=new ArrayList<String>();
		
		List<AirBottle> airBottleCrsList=new ArrayList<AirBottle>();
		List<AirBottle> airBottleHgzList=new ArrayList<AirBottle>();
		
		AirBottle airBottleCrs=null;
		AirBottle airBottleHgz=null;

		List<AirBottle> airBottleList=null;
		int updateFlag=Integer.valueOf(request.getParameter("updateFlag"));
		if(updateFlag==1) {
			String qpbhs=request.getParameter("qpbhs");
			System.out.println("qpbhs="+qpbhs);
			airBottleList=createLabelService.getQrcodeUrlByQpbhs(qpbhs);
		}
		else if(updateFlag==2) {
			String qpbhPre = request.getParameter("qpbhPre");
			System.out.println("qpbhPre="+qpbhPre);
			airBottleList=createLabelService.getQrcodeUrlByQpbhPre(qpbhPre);
		}
		System.out.println("airBottleListSize="+airBottleList.size());
		for (AirBottle airBottle : airBottleList) {
			String qpbh = airBottle.getQpbh();
			String qrcode_crs_url = airBottle.getQrcode_crs_url();
			String qrcode_hgz_url = airBottle.getQrcode_hgz_url();
			
			System.out.println("qrcode_crs_url.length()="+qrcode_crs_url.length());
			if(qrcode_crs_url.length()==56) {
				Map<String,Object> resultMap=Qrcode.putInFolder(qpbh,qrcode_crs_url);
				Boolean success = Boolean.valueOf(resultMap.get("success").toString());
				if(success) {
					qpbhCrsList.add(qpbh);
					
					airBottleCrs=new AirBottle();
					airBottleCrs.setQpbh(qpbh);
					airBottleCrs.setQrcode_crs_url(resultMap.get("qrcodeSrcUrl").toString());
					
					airBottleCrsList.add(airBottleCrs);
				}
			}
			System.out.println("qrcode_hgz_url.length()="+qrcode_hgz_url.length());
			if(qrcode_hgz_url.length()==56) {
				Map<String,Object> resultMap=Qrcode.putInFolder(qpbh,qrcode_hgz_url);
				Boolean success = Boolean.valueOf(resultMap.get("success").toString());
				if(success) {
					qpbhHgzList.add(qpbh);
					
					airBottleHgz=new AirBottle();
					airBottleHgz.setQpbh(qpbh);
					airBottleHgz.setQrcode_hgz_url(resultMap.get("qrcodeSrcUrl").toString());
					
					airBottleHgzList.add(airBottleHgz);
				}
			}
		}

		System.out.println("qpbhCrsList.size()==="+qpbhCrsList.size());
		if(qpbhCrsList.size()>0) {
			int countCrs=createLabelService.updateQrcodeSrcUrl(airBottleCrsList,qpbhCrsList,AirBottle.CRS);
			System.out.println("countCrs==="+countCrs);
		}
		System.out.println("qpbhHgzList.size()==="+qpbhHgzList.size());
		if(qpbhHgzList.size()>0) {
			int countHgz=createLabelService.updateQrcodeSrcUrl(airBottleHgzList,qpbhHgzList,AirBottle.HGZ);
			System.out.println("countHgz==="+countHgz);
		}
		
		return jsonMap;
	}
	
	public static void main(String[] args) {
		String qrcodeSrcUrl="/StockLabelQrcode/upload/crsCB2339900120231202235930.jpg";
		System.out.println("qrcodeSrcUrl="+qrcodeSrcUrl.length());
		if(qrcodeSrcUrl.length()==56) {
			String qpbh="CB23399001";
			int qpbhStartLoc = qrcodeSrcUrl.indexOf(qpbh);
			int qpbhEndLoc = qpbhStartLoc+qpbh.length();
			String yyyyMM = qrcodeSrcUrl.substring(qpbhEndLoc, qpbhEndLoc+6);
			
			File yyyyMMFolder=new File("D:/resource/StockLabelQrcode/"+yyyyMM);
			if(!yyyyMMFolder.exists())
				yyyyMMFolder.mkdir();
			
			String crs = "crs";
			int crsStartLoc = qrcodeSrcUrl.indexOf(crs);
			String slqStr = qrcodeSrcUrl.substring(0, crsStartLoc);
			String imgName = qrcodeSrcUrl.substring(crsStartLoc, qrcodeSrcUrl.length());
			String qrcodeSrcUrlNew = slqStr+yyyyMM+"/"+imgName;
			System.out.println("imgName="+imgName);
			System.out.println("qrcodeSrcUrlNew="+qrcodeSrcUrlNew);
			
			File oldFile=new File("D:/resource/StockLabelQrcode/"+imgName);
			File newFile=new File("D:/resource/StockLabelQrcode/"+yyyyMM+"/"+imgName);
			File dateFolder = new File("D:/resource/StockLabelQrcode/"+yyyyMM);
			if(!dateFolder.exists())
				dateFolder.mkdir();
			boolean success = oldFile.renameTo(newFile);
			System.out.println("success=="+success);
		}
		/*
		File file1=new File("D:/resource/StockLabelQrcode/crsCB2339900120231202235930.jpg");
		File file2=new File("D:/resource/StockLabelQrcode/202312/crsCB2339900120231202235930.jpg");
		File dateFolder = new File("D:/resource/StockLabelQrcode/202312");
		if(!dateFolder.exists())
			dateFolder.mkdir();
		boolean success = file1.renameTo(file2);
		System.out.println("success=="+success);
		*/
	}

}
