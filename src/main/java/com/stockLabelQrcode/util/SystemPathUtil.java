package com.stockLabelQrcode.util;

import javax.servlet.http.HttpServletRequest;

public class SystemPathUtil {
    public static String getModelPath(HttpServletRequest request,String outFile){
        String path = request.getServletContext().getRealPath("/");
        path = path.replaceAll("\\\\", "/");
        String a=path+"WEB-INF/flt/"+outFile;
        return a;
    }
    public static String getPath(HttpServletRequest request){
        String path = request.getServletContext().getRealPath("/");
        path = path.replaceAll("\\\\", "/");
        return path;
    }
}
