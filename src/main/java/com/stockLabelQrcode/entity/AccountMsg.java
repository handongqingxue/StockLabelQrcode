package com.stockLabelQrcode.entity;

public class AccountMsg {
	private String id;//用户id
	private String userName;//用户名
	private String passWord;//密码
	private String nickName;//昵称
	private String passWord1;//备用密码
	private String phone;//电话号
	private String email;//邮箱
	private String gmt_create;//创建时间
	private String createUser;//创建人
	private String avatar_img;//用户头像
	private String companyName;//公司名称
	private String companyAddress;//公司地址
	private String postcode;
	private String quotient;
	private String fax;
	private String countCode;
	private String recordNumber;
	private String accountStatus;
	private String role;
	
	public AccountMsg(String userName,String passWord) {
		this.userName=userName;
		this.passWord=passWord;
	}
	
	public AccountMsg() {
		super();
	}
	
	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getAccountStatus() {
		return accountStatus;
	}
	public void setAccountStatus(String accountStatus) {
		this.accountStatus = accountStatus;
	}
	public String getAvatar_img() {
		return avatar_img;
	}
	public void setAvatar_img(String avatar_img) {
		this.avatar_img = avatar_img;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getCompanyAddress() {
		return companyAddress;
	}
	public void setCompanyAddress(String companyAddress) {
		this.companyAddress = companyAddress;
	}
	public String getPostcode() {
		return postcode;
	}
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}
	public String getQuotient() {
		return quotient;
	}
	public void setQuotient(String quotient) {
		this.quotient = quotient;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getCountCode() {
		return countCode;
	}
	public void setCountCode(String countCode) {
		this.countCode = countCode;
	}
	public String getRecordNumber() {
		return recordNumber;
	}
	public void setRecordNumber(String recordNumber) {
		this.recordNumber = recordNumber;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getPassWord() {
		return passWord;
	}
	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}
	public String getPassWord1() {
		return passWord1;
	}
	public void setPassWord1(String passWord1) {
		this.passWord1 = passWord1;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getGmt_create() {
		return gmt_create;
	}
	public void setGmt_create(String gmt_create) {
		this.gmt_create = gmt_create;
	}

	@Override
	public String toString() {
		return "AccountMsg [id=" + id + ", userName=" + userName + ", passWord=" + passWord + ", nickName=" + nickName
				+ ", passWord1=" + passWord1 + ", phone=" + phone + ", email=" + email + ", gmt_create=" + gmt_create
				+ ", createUser=" + createUser + ", avatar_img=" + avatar_img + ", companyName=" + companyName
				+ ", companyAddress=" + companyAddress + ", postcode=" + postcode + ", quotient=" + quotient + ", fax="
				+ fax + ", countCode=" + countCode + ", recordNumber=" + recordNumber + ", accountStatus="
				+ accountStatus + ", role=" + role + "]";
	}
	
	
	
}
