package com.stockLabelQrcode.service;

import java.util.List;

import com.stockLabelQrcode.entity.AccountMsg;

public interface UserService {
	//检查账户信息
	public AccountMsg checkUser(AccountMsg user);
	//用户注册保存
	public int saveUser(AccountMsg msg);
	//用户之间的传递操作
	/**
	 * 查询商户数量
	 * @return
	 */
	public int queryAccountForInt();
	/**
	 * 查询商户信息
	 * @param page
	 * @param rows
	 * @param sort
	 * @param order
	 * @return
	 */
	public List<AccountMsg> queryAccountList(int page, int rows, String sort, String order);
	/**
	 * 更新商户状态
	 * @param id
	 * @param status
	 * @return
	 */
	public int updateAccountStatus(String id, String status);
}
