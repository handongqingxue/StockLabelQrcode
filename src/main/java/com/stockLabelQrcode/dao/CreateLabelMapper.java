package com.stockLabelQrcode.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.stockLabelQrcode.entity.AirBottle;
import com.stockLabelQrcode.entity.PreviewCRSPDF;
import com.stockLabelQrcode.entity.PreviewCRSPDFSet;
import com.stockLabelQrcode.entity.PreviewPdfJson;

public interface CreateLabelMapper {

	List<PreviewCRSPDF> selectPreviewCRSPDF();

	int insertPreviewCRSPDFSet(PreviewCRSPDFSet pCrsPdfSet);

	PreviewCRSPDFSet selectCRSPdfSet(@Param("labelType")Integer labelType, @Param("accountNumber")String accountNumber);

	int insertAirBottleRecord(AirBottle airBottle);

	int queryAirBottleForInt(@Param("qpbh")String qpbh);

	List<AirBottle> queryAirBottleList(@Param("qpbh")String qpbh, int start, int rows, String sort, String order);

	int queryBatchForInt(@Param("cpxh")String cpxh, @Param("qpbh")String qpbh, @Param("qpzjxh")String qpzjxh, @Param("zzrq_y")String zzrq_y, @Param("zzrq_m")String zzrq_m, @Param("qpzzdw")String qpzzdw);

	List<AirBottle> queryBatchList(@Param("cpxh")String cpxh, @Param("qpbh")String qpbh, @Param("qpzjxh")String qpzjxh, @Param("zzrq_y")String zzrq_y, 
			@Param("zzrq_m")String zzrq_m, @Param("qpzzdw")String qpzzdw, @Param("start")int start, @Param("rows")int rows, @Param("sort")String sort, @Param("order")String order);

	int updateAirBottle(AirBottle airBottle);

	AirBottle getAirBottleById(@Param("id")String id);

	AirBottle getAirBottleByQpbh(@Param("qpbh")String qpbh);

	int editAirBottle(AirBottle airBottle);

	int deleteAirBottleById(List<String> idList);

	int deleteAirBottleByQpbhs(List<String> qpbhList);
	
	List<AirBottle> selectAirBottleByQpbhs(List<String> qpbhList);

	int getAirBottleCountByQpbh(@Param("qpbh")String qpbh);

	int editPreviewCrsPdfSet(PreviewCRSPDFSet pCrsPdfSet);

	int insertPrePdfJson(PreviewPdfJson ppj);

	PreviewPdfJson selectPrePdfJsonByUuid(@Param("uuid")String uuid);

	List<String> getExistQpbhListByQpbhList(@Param("qpbhList")List<String> qpbhList);

}
