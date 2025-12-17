//请求参数类型约束
//注册参数
export interface RegisterParams{
  phone: string,
  password: string,
  nickName: string
}
//登录参数
export interface LoginParams{
  phone:string,
  password:string
}

//收藏、取消收藏参数
export interface LikeParams {
  pid: string,
  token: string
}

//加入购物袋参数
export interface ShopbagParams {
  pid: string
  token: string
  count: number
}

//修改购物袋数量
export interface ShopbagCountParams{
  sid: string
  token: string
  count: number
}

//删除购物袋数据
export interface RemoveShopbagParams{
  sids: string
  token: string
}

// 用户信息参数
export interface UserInfoParams {
  token: string;
}

// 用户信息响应数据结构 - 根据user表定义
export interface UserInfoData {
  id?: number;
  user_id?: string;     // 用户唯一id
  nick_name?: string;   // 用户昵称
  phone?: string;       // 手机号
  user_img?: string;    // 用户头像
  user_bg?: string;     // 用户背景
  desc?: string;        // 个人简介
  vip?: number;         // vip状态
  is_remove?: number;   // 是否注销
  is_login?: number;    // 是否登录
  created_at?: string;
  updated_at?: string;
}

// API响应通用接口 - 完全避免any类型
export interface ApiResponse {
  code?: number;
  result?: ResultData;
  data?: UserInfoData | UserInfoData[] | Record<string, Object>;
  message?: string;
  msg?: string;
}

export interface ResultData {
  code: number;
  result?: UserInfoData | UserInfoData[] | Record<string, Object>;
  data?: UserInfoData | UserInfoData[] | Record<string, Object>;
  message?: string;
}

// 专门用于MinePage的用户信息类型
export interface MinePageUserInfo {
  name: string;        // 昵称
  message: string;     // 个人简介
  phone: string;       // 手机号
  avatar: string;      // 头像
  background: string;  // 背景图
}

export interface updateNickName{
  token: string;
  nickName: string;
}

export interface updatePassword{
  token: string;
  password: string;
  oldPassword: string;
}