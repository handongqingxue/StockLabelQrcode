package com.stockLabelQrcode.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Util {

	//第一种实现
    public final static String MD5Encode(String s) {
        char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};       
        try {
            byte[] btInput = s.getBytes();
            // 获得MD5摘要算法的 MessageDigest 对象
            MessageDigest mdInst = MessageDigest.getInstance("MD5");
            // 使用指定的字节更新摘要
            mdInst.update(btInput);
            // 获得密文
            byte[] md = mdInst.digest();
            // 把密文转换成十六进制的字符串形式
            int j = md.length;
            char str[] = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                str[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(str);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    //第二种实现
    public final static String MD5(String str) {//项目中的
        try {
              MessageDigest md5 = MessageDigest.getInstance("MD5");
              md5.update(str.getBytes());
              byte b[] = md5.digest();

              StringBuffer sb = new StringBuffer("");
              for (int n = 0; n < b.length; n++) {
                int i = b[n];
                if (i < 0) i += 256;
                if (i < 16) sb.append("0");
                sb.append(Integer.toHexString(i));
              }
              return sb.toString();  //32位加密
            } catch (NoSuchAlgorithmException e) {
              e.printStackTrace();
              return null;
            }
    }
    public static void main(String[] args) {
        System.out.println(MD5Util.MD5Encode("111"));
        System.out.println(MD5Util.MD5("111"));
    }
}
