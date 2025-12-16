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
  token: string
}
