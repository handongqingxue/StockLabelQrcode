package com.stockLabelQrcode.entity;

import java.io.Serializable;

public class PreviewCRSPDF implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private float cpxh_left;//产品型号距离左边多远
	public float getCpxh_left() {
		return cpxh_left;
	}
	public void setCpxh_left(float cpxh_left) {
		this.cpxh_left = cpxh_left;
	}
	public float getCpxh_top() {
		return cpxh_top;
	}
	public void setCpxh_top(float cpxh_top) {
		this.cpxh_top = cpxh_top;
	}
	public float getTybm_left() {
		return tybm_left;
	}
	public void setTybm_left(float tybm_left) {
		this.tybm_left = tybm_left;
	}
	public float getTybm_top() {
		return tybm_top;
	}
	public void setTybm_top(float tybm_top) {
		this.tybm_top = tybm_top;
	}
	public float getTybm_font_size() {
		return tybm_font_size;
	}
	public void setTybm_font_size(float tybm_font_size) {
		this.tybm_font_size = tybm_font_size;
	}
	public float getQpbh_left() {
		return qpbh_left;
	}
	public void setQpbh_left(float qpbh_left) {
		this.qpbh_left = qpbh_left;
	}
	public float getQpbh_top() {
		return qpbh_top;
	}
	public void setQpbh_top(float qpbh_top) {
		this.qpbh_top = qpbh_top;
	}
	public float getGcrj_left() {
		return gcrj_left;
	}
	public void setGcrj_left(float gcrj_left) {
		this.gcrj_left = gcrj_left;
	}
	public float getGcrj_top() {
		return gcrj_top;
	}
	public void setGcrj_top(float gcrj_top) {
		this.gcrj_top = gcrj_top;
	}
	public float getNdbh_left() {
		return ndbh_left;
	}
	public void setNdbh_left(float ndbh_left) {
		this.ndbh_left = ndbh_left;
	}
	public float getNdbh_top() {
		return ndbh_top;
	}
	public void setNdbh_top(float ndbh_top) {
		this.ndbh_top = ndbh_top;
	}
	public float getZzrq_y_left() {
		return zzrq_y_left;
	}
	public void setZzrq_y_left(float zzrq_y_left) {
		this.zzrq_y_left = zzrq_y_left;
	}
	public float getZzrq_y_top() {
		return zzrq_y_top;
	}
	public void setZzrq_y_top(float zzrq_y_top) {
		this.zzrq_y_top = zzrq_y_top;
	}
	public float getZzrq_m_left() {
		return zzrq_m_left;
	}
	public void setZzrq_m_left(float zzrq_m_left) {
		this.zzrq_m_left = zzrq_m_left;
	}
	public float getZzrq_m_top() {
		return zzrq_m_top;
	}
	public void setZzrq_m_top(float zzrq_m_top) {
		this.zzrq_m_top = zzrq_m_top;
	}
	public float getQrcode_left() {
		return qrcode_left;
	}
	public void setQrcode_left(float qrcode_left) {
		this.qrcode_left = qrcode_left;
	}
	public float getQrcode_top() {
		return qrcode_top;
	}
	public void setQrcode_top(float qrcode_top) {
		this.qrcode_top = qrcode_top;
	}
	public float getLabel_type() {
		return label_type;
	}
	public void setLabel_type(float label_type) {
		this.label_type = label_type;
	}
	private float cpxh_top;//产品型号距离上边多远
	private float tybm_left;//统一编码距离左边多远
	private float tybm_top;//统一编码距离上边多远
	private float tybm_font_size;//统一编码字体大小
	private float qpbh_left;//气瓶编号距离左边多远
	private float qpbh_top;//气瓶编号距离上边多远
	private float gcrj_left;//公称容积距离左边多远
	private float gcrj_top;//公称容积距离上边多远
	private float ndbh_left;//内胆壁厚距离左边多远
	private float ndbh_top;//内胆壁厚距离上边多远
	private float zzrq_y_left;//制造日期年份距离左边多远
	private float zzrq_y_top;//制造日期年份距离上边多远
	private float zzrq_m_left;//制造日期月份距离左边多远
	private float zzrq_m_top;//制造日期月份距离上边多远
	private float qrcode_left;//二维码距离左边多远
	private float qrcode_top;//二维码距离上边多远
	private float label_type;//标签类型：1.中文标签、2.ISO标签、3.ECE标签

}
