package com.stockLabelQrcode.entity;

import java.io.Serializable;

public class AirBottle implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int id;//主键
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCpxh() {
		return cpxh;
	}
	public void setCpxh(String cpxh) {
		this.cpxh = cpxh;
	}
	public String getCpxh_qc() {
		return cpxh_qc;
	}
	public void setCpxh_qc(String cpxh_qc) {
		this.cpxh_qc = cpxh_qc;
	}
	public String getQpbh() {
		return qpbh;
	}
	public void setQpbh(String qpbh) {
		this.qpbh = qpbh;
	}
	public String getGcrj() {
		return gcrj;
	}
	public void setGcrj(String gcrj) {
		this.gcrj = gcrj;
	}
	public String getNdbh() {
		return ndbh;
	}
	public void setNdbh(String ndbh) {
		this.ndbh = ndbh;
	}
	public String getZl() {
		return zl;
	}
	public void setZl(String zl) {
		this.zl = zl;
	}
	public String getScrj() {
		return scrj;
	}
	public void setScrj(String scrj) {
		this.scrj = scrj;
	}
	public String getQpzjxh() {
		return qpzjxh;
	}
	public void setQpzjxh(String qpzjxh) {
		this.qpzjxh = qpzjxh;
	}
	public String getZzrq_y() {
		return zzrq_y;
	}
	public void setZzrq_y(String zzrq_y) {
		this.zzrq_y = zzrq_y;
	}
	public String getZzrq_m() {
		return zzrq_m;
	}
	public void setZzrq_m(String zzrq_m) {
		this.zzrq_m = zzrq_m;
	}
	public String getQpzzdw() {
		return qpzzdw;
	}
	public void setQpzzdw(String qpzzdw) {
		this.qpzzdw = qpzzdw;
	}
	public String getQrcode_crs_url() {
		return qrcode_crs_url;
	}
	public void setQrcode_crs_url(String qrcode_crs_url) {
		this.qrcode_crs_url = qrcode_crs_url;
	}
	public String getQrcode_hgz_url() {
		return qrcode_hgz_url;
	}
	public void setQrcode_hgz_url(String qrcode_hgz_url) {
		this.qrcode_hgz_url = qrcode_hgz_url;
	}
	public int getLabel_type() {
		return label_type;
	}
	public void setLabel_type(int label_type) {
		this.label_type = label_type;
	}
	public Boolean getInput() {
		return input;
	}
	public void setInput(Boolean input) {
		this.input = input;
	}
	private String cpxh;//产品型号（简称）
	private String cpxh_qc;//产品型号（全称）
	private String qpbh;//气瓶编号
	private String gcrj;//公称容积
	private String ndbh;//内胆壁厚
	private String zl;//重量
	private String scrj;//实测容积
	private String qpzjxh;//气瓶支架型号
	private String zzrq_y;//制造日期年份
	private String zzrq_m;//制造日期月份
	private String qpzzdw;//气瓶制造单位
	private String qrcode_crs_url;//缠绕式二维码链接
	private String qrcode_hgz_url;//合格证式二维码链接
	private int label_type;//标签类型：1.中文标签、2.ISO标签、3.ECE标签
	private Boolean input;

}
