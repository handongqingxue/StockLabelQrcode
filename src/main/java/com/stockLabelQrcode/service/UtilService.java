package com.stockLabelQrcode.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public interface UtilService {
	public void getKaptchaImageByMerchant(HttpSession session, String identity, HttpServletResponse response);
}
