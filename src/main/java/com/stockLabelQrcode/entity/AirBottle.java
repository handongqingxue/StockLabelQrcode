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
	public String getZzrq() {
		return zzrq;
	}
	public void setZzrq(String zzrq) {
		this.zzrq = zzrq;
	}
	public String getQpzzdw() {
		return qpzzdw;
	}
	public void setQpzzdw(String qpzzdw) {
		this.qpzzdw = qpzzdw;
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
	private String cpxh;//产品型号
	private String qpbh;//气瓶编号
	private String gcrj;//公称容积
	private String ndbh;//内胆壁厚
	private String zl;//重量
	private String scrj;//实测容积
	private String qpzjxh;//气瓶支架型号
	private String zzrq;//制造日期
	private String qpzzdw;//气瓶制造单位
	private int label_type;//标签类型：1.中文标签、2.ISO标签、3.ECE标签
	private Boolean input;

}
