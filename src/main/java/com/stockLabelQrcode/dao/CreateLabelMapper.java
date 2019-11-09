package com.stockLabelQrcode.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.stockLabelQrcode.entity.AirBottle;
import com.stockLabelQrcode.entity.PreviewCRSPDF;
import com.stockLabelQrcode.entity.PreviewCRSPDFSet;

public interface CreateLabelMapper {

	List<PreviewCRSPDF> selectPreviewCRSPDF();

	int insertPreviewCRSPDFSet(PreviewCRSPDFSet pCrsPdfSet);

	PreviewCRSPDFSet selectCRSPdfSet(@Param("labelType")Integer labelType, @Param("accountNumber")String accountNumber);

	int insertAirBottleRecord(AirBottle airBottle);

	int queryAirBottleForInt(@Param("qpbh")String qpbh);

	List<AirBottle> queryAirBottleList(@Param("qpbh")String qpbh, int start, int rows, String sort, String order);

	int updateAirBottle(AirBottle airBottle);

	AirBottle getAirBottleById(@Param("id")String id);

	int editAirBottle(AirBottle airBottle);

	int deleteAirBottle(List<String> idList);

	int getAirBottleCountByQpbh(@Param("qpbh")String qpbh);

}
