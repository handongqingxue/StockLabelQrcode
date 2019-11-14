package com.stockLabelQrcode.service.serviceImpl;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.stockLabelQrcode.dao.CreateLabelMapper;
import com.stockLabelQrcode.entity.AirBottle;
import com.stockLabelQrcode.entity.PreviewCRSPDF;
import com.stockLabelQrcode.entity.PreviewCRSPDFSet;
import com.stockLabelQrcode.service.CreateLabelService;

@Service
public class CreateLabelServiceImpl implements CreateLabelService {

	@Autowired
	private CreateLabelMapper createLabelDao;
	
	@Override
	public List<PreviewCRSPDF> selectPreviewCRSPDF() {
		// TODO Auto-generated method stub
		return createLabelDao.selectPreviewCRSPDF();
	}

	@Override
	public int insertPreviewCRSPDFSet(PreviewCRSPDFSet pCrsPdfSet) {
		// TODO Auto-generated method stub
		return createLabelDao.insertPreviewCRSPDFSet(pCrsPdfSet);
	}

	@Override
	public PreviewCRSPDFSet selectCRSPdfSet(Integer labelType, String accountNumber) {
		// TODO Auto-generated method stub
		return createLabelDao.selectCRSPdfSet(labelType,accountNumber);
	}

	@Override
	public int insertAirBottleRecord(AirBottle airBottle) {
		// TODO Auto-generated method stub
		return createLabelDao.insertAirBottleRecord(airBottle);
	}

	@Override
	public int queryAirBottleForInt(String qpbh) {
		// TODO Auto-generated method stub
		return createLabelDao.queryAirBottleForInt(qpbh);
	}

	@Override
	public List<AirBottle> queryAirBottleList(String qpbh, int page, int rows, String sort, String order) {
		// TODO Auto-generated method stub
		return createLabelDao.queryAirBottleList(qpbh, (page-1)*rows, rows, sort, order);
	}

	@Override
	public int queryBatchForInt(String cpxh, String qpbh, String qpzjxh, String zzrq, String qpzzdw) {
		// TODO Auto-generated method stub
		return createLabelDao.queryBatchForInt(cpxh, qpbh, qpzjxh, zzrq, qpzzdw);
	}

	@Override
	public List<AirBottle> queryBatchList(String cpxh, String qpbh, String qpzjxh, String zzrq, String qpzzdw, int page,
			int rows, String sort, String order) {
		// TODO Auto-generated method stub
		return createLabelDao.queryBatchList(cpxh, qpbh, qpzjxh, zzrq, qpzzdw, (page-1)*rows, rows, sort, order);
	}

	@Override
	public int updateAirBottle(AirBottle airBottle) {
		// TODO Auto-generated method stub
		return createLabelDao.updateAirBottle(airBottle);
	}

	@Override
	public AirBottle getAirBottleById(String id) {
		// TODO Auto-generated method stub
		return createLabelDao.getAirBottleById(id);
	}

	@Override
	public int editAirBottle(AirBottle airBottle) {
		// TODO Auto-generated method stub
		return createLabelDao.editAirBottle(airBottle);
	}

	@Override
	public int deleteAirBottleById(String ids) {
		// TODO Auto-generated method stub
		int count=0;
		List<String> idList = Arrays.asList(ids.split(","));
		count=createLabelDao.deleteAirBottleById(idList);
		return count;
	}

	@Override
	public int deleteAirBottleByQpbhs(String qpbhs) {
		// TODO Auto-generated method stub
		int count=0;
		List<String> qpbhList = Arrays.asList(qpbhs.split(","));
		count=createLabelDao.deleteAirBottleByQpbhs(qpbhList);
		return count;
	}

	@Override
	public boolean checkAirBottleExistByQpbh(String qpbh) {
		// TODO Auto-generated method stub
		int count=createLabelDao.getAirBottleCountByQpbh(qpbh);
		return count>0?true:false;
	}

	@Override
	public AirBottle getAirBottleByQpbh(String qpbh) {
		// TODO Auto-generated method stub
		return createLabelDao.getAirBottleByQpbh(qpbh);
	}
	
	@Override
	public int editPreviewCrsPdfSet(PreviewCRSPDFSet pCrsPdfSet) {
		// TODO Auto-generated method stub
		return createLabelDao.editPreviewCrsPdfSet(pCrsPdfSet);
	}

}