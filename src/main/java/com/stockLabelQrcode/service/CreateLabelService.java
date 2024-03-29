package com.stockLabelQrcode.service;

import java.util.List;

import com.stockLabelQrcode.entity.AirBottle;
import com.stockLabelQrcode.entity.PreviewCRSPDF;
import com.stockLabelQrcode.entity.PreviewCRSPDFSet;
import com.stockLabelQrcode.entity.PreviewPdfJson;

public interface CreateLabelService {

	/**
	 * 查询预览缠绕式pdf模板的默认配置参数
	 * @return
	 */
	List<PreviewCRSPDF> selectPreviewCRSPDF();

	/**
	 * 根据不同用户，生成缠绕式pdf模板参数设置（注册完成后生成）
	 * @param pCrsPdfSet
	 * @return
	 */
	int insertPreviewCRSPDFSet(PreviewCRSPDFSet pCrsPdfSet);

	/**
	 * 根据格式，查询缠绕式pdf模板方位参数配置
	 * @param labelType
	 * @param accountNumber
	 * @return
	 */
	PreviewCRSPDFSet selectCRSPdfSet(Integer labelType, String accountNumber);

	/**
	 * 插入历史记录
	 * @param airBottle
	 * @return
	 */
	int insertAirBottleRecord(AirBottle airBottle);

	/**
	 * 查询气瓶历史记录条数
	 * @param qpbh
	 * @return
	 */
	int queryAirBottleForInt(String qpbh);

	/**
	 * 查询气瓶历史记录
	 * @param qpbh
	 * @param page
	 * @param rows
	 * @param sort
	 * @param order
	 * @return
	 */
	List<AirBottle> queryAirBottleList(String qpbh, int page, int rows, String sort, String order);

	/**
	 * 查询批次条数
	 * @param cpxh
	 * @param qpbh
	 * @param qpzjxh
	 * @param zzrq_y
	 * @param zzrq_m
	 * @param qpzzdw
	 * @return
	 */
	int queryBatchForInt(String cpxh, String qpbh, String qpzjxh, String zzrq_y, String zzrq_m, String qpzzdw);

	/**
	 * 查询批次记录
	 * @param cpxh
	 * @param qpbh
	 * @param qpzjxh
	 * @param zzrq_y
	 * @param zzrq_m
	 * @param qpzzdw
	 * @param page
	 * @param rows
	 * @param sort
	 * @param order
	 * @return
	 */
	List<AirBottle> queryBatchList(String cpxh, String qpbh, String qpzjxh, String zzrq_y, String zzrq_m, String qpzzdw, int page,
			int rows, String sort, String order);

	/**
	 * 根据导入的excel产品信息，更新历史记录里未填写的信息
	 * @param airBottle
	 * @return
	 */
	int updateAirBottle(AirBottle airBottle);

	int updateAirBottle(List<AirBottle> airBottleList);

	/**
	 * 根据id，获得气瓶信息
	 * @param id
	 * @return
	 */
	AirBottle getAirBottleById(String id);

	/**
	 * 编辑气瓶信息
	 * @param airBottle
	 * @return
	 */
	int editAirBottle(AirBottle airBottle);

	/**
	 * 删除气瓶
	 * @param ids
	 * @return
	 */
	int deleteAirBottleById(String ids);

	int deleteAirBottleByQpbhs(String qpbhs);

	List<AirBottle> selectAirBottleByQpbhs(String qpbhsStr);

	/**
	 * 根据气瓶编号，验证该气瓶是否已存在
	 * @param qpbh
	 * @return
	 */
	boolean checkAirBottleExistByQpbh(String qpbh);
	
	/**
	 * 根据编号获得气瓶信息
	 * @param qpbh
	 * @return
	 */
	AirBottle getAirBottleByQpbh(String qpbh);
	
	/**
	 * 重新设置预览pdf模板里的方位参数
	 * @param pCrsPdfSet
	 * @return
	 */
	int editPreviewCrsPdfSet(PreviewCRSPDFSet pCrsPdfSet);

	int insertPrePdfJson(PreviewPdfJson ppj);

	PreviewPdfJson selectPrePdfJsonByUuid(String uuid);

	List<String> getExistQpbhListByQpbhs(String qpbhs);

	List<AirBottle> getQrcodeUrlByQpbhs(String qpbhs);

	List<AirBottle> getQrcodeUrlByQpbhPre(String qpbhPre);

	int updateQrcodeSrcUrl(List<AirBottle> airBottleList, List<String> qpbhList, int qrcodeFlag);

}
