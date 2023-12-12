package com.stockLabelQrcode.util.qrcode;

import java.text.SimpleDateFormat;
import java.util.Map;

import javax.swing.filechooser.FileSystemView;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
 
import javax.imageio.ImageIO;
import javax.swing.filechooser.FileSystemView;
 
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.stockLabelQrcode.entity.AirBottle;

public class Qrcode {

	public static void main(String[] args) {
        String url = "http://localhost:8088/GoodsPublic/merchant/main/show?goodsNumber=321";
        String path = FileSystemView.getFileSystemView().getHomeDirectory() + File.separator + "testQrcode";
        String fileName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".jpg";
        createQrCode(url, path, fileName);
    }
 
    public static String createQrCode(String url, String path, String fileName) {
        try {
            Map<EncodeHintType, String> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            BitMatrix bitMatrix = new MultiFormatWriter().encode(url, BarcodeFormat.QR_CODE, 400, 400, hints);
            
            File folder=new File(path);
            if(!folder.exists())
            	folder.mkdir();
            
            File file = new File(path, fileName);
            if (file.exists() || ((file.getParentFile().exists() || file.getParentFile().mkdirs()) && file.createNewFile())) {
                writeToFile(bitMatrix, "jpg", file);
                System.out.println("文件路径=" + file);
            }
 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 
    static void writeToFile(BitMatrix matrix, String format, File file) throws IOException {
        BufferedImage image = toBufferedImage(matrix);
        if (!ImageIO.write(image, format, file)) {
            throw new IOException("Could not write an image of format " + format + " to " + file);
        }
    }
 
    static void writeToStream(BitMatrix matrix, String format, OutputStream stream) throws IOException {
        BufferedImage image = toBufferedImage(matrix);
        if (!ImageIO.write(image, format, stream)) {
            throw new IOException("Could not write an image of format " + format);
        }
    }
 
    private static final int BLACK = 0xFF000000;
    private static final int WHITE = 0xFFFFFFFF;
 
    private static BufferedImage toBufferedImage(BitMatrix matrix) {
        int width = matrix.getWidth();
        int height = matrix.getHeight();
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                image.setRGB(x, y, matrix.get(x, y) ? BLACK : WHITE);
            }
        }
        return image;
    }

	public static Map<String, Object> putInFolder(String qpbh, String qrcodeSrcUrl) {
		// TODO Auto-generated method stub
		Map<String, Object> resultMap=new HashMap<String, Object>();
		
		int qpbhStartLoc = qrcodeSrcUrl.indexOf(qpbh);
		int qpbhEndLoc = qpbhStartLoc+qpbh.length();
		String yyyyMM = qrcodeSrcUrl.substring(qpbhEndLoc, qpbhEndLoc+6);
		
		File yyyyMMFolder=new File("D:/resource/StockLabelQrcode/"+yyyyMM);
		if(!yyyyMMFolder.exists())
			yyyyMMFolder.mkdir();
		
		String qrcodeFlag = null;
		if(qrcodeSrcUrl.contains(AirBottle.CRS_TEXT))
			qrcodeFlag = AirBottle.CRS_TEXT;
		else if(qrcodeSrcUrl.contains(AirBottle.HGZ_TEXT))
			qrcodeFlag = AirBottle.HGZ_TEXT;
		
		int qrcodeFlagStartLoc = qrcodeSrcUrl.indexOf(qrcodeFlag);
		String slqStr = qrcodeSrcUrl.substring(0, qrcodeFlagStartLoc);
		String imgName = qrcodeSrcUrl.substring(qrcodeFlagStartLoc, qrcodeSrcUrl.length());
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
		if(success) {
			resultMap.put("success", success);
			resultMap.put("qrcodeSrcUrl", qrcodeSrcUrlNew);
		}
		else {
			resultMap.put("success", success);
		}
		
		return resultMap;
	}
}
