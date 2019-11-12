package com.stockLabelQrcode.service;

import java.util.List;

import com.stockLabelQrcode.entity.AirBottle;
import com.stockLabelQrcode.entity.PreviewCRSPDF;
import com.stockLabelQrcode.entity.PreviewCRSPDFSet;

public interface CreateLabelService {

	List<PreviewCRSPDF> selectPreviewCRSPDF();

	int insertPreviewCRSPDFSet(PreviewCRSPDFSet pCrsPdfSet);

	PreviewCRSPDFSet selectCRSPdfSet(Integer labelType, String accountNumber);

	int insertAirBottleRecord(AirBottle airBottle);

	int queryAirBottleForInt(String qpbh);

	List<AirBottle> queryAirBottleList(String qpbh, int page, int rows, String sort, String order);

	int updateAirBottle(AirBottle airBottle);

	AirBottle getAirBottleById(String id);

	int editAirBottle(AirBottle airBottle);

	int deleteAirBottle(String ids);

	boolean checkAirBottleExistByQpbh(String qpbh);
	
	AirBottle getAirBottleByQpbh(String qpbh);
	
	int editPreviewCrsPdfSet(PreviewCRSPDFSet pCrsPdfSet);

}
