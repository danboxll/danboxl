// src/main/ets/api/api.ts
import { http } from '@kit.NetworkKit'
import { RegisterParams, LoginParams, LikeParams, ShopbagParams,ShopbagCountParams,
  RemoveShopbagParams,UserInfoParams,UserInfoData,
  updateNickName,
  updatePassword} from '../paramsInterface/paramsInterface'

let httpRequest = http.createHttp()

// 请求基础路径
// 只能是本机设备访问
let baseUrl: string = 'http://127.0.0.1:7001'

export const getProductByFlags = async (flags: string[]) => {
  return await httpRequest.request(`${baseUrl}/flagProducts`, {
    method: http.RequestMethod.GET,
    extraData: {
      flags: JSON.stringify(flags)
    },
    expectDataType: http.HttpDataType.OBJECT
  })
}

export const getType = async () => {
  return await httpRequest.request(`${baseUrl}/type`, {
    // 请求类型
    method: http.RequestMethod.GET,
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

export const getProductByType = async (typeId: string) => {
  return await httpRequest.request(`${baseUrl}/typeProducts`, {
    method: http.RequestMethod.GET,
    extraData: {
      typeId: typeId
    },
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 搜索商品
export const searchProduct = async (name: string) => {
  return await httpRequest.request(`${baseUrl}/search`, {
    method: http.RequestMethod.GET,
    extraData: {
      name: name
    },
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 获取商品详情
export const getProductDetail = async (pid: string) => {
  return await httpRequest.request(`${baseUrl}/productDetail`, {
    method: http.RequestMethod.GET,
    extraData: {
      pid: pid
    },
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 注册
export const userRegister = async (params: RegisterParams) => {
  return await httpRequest.request(`${baseUrl}/register`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: {
      'Content-Type': 'application/json'
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 登录
export const userLogin = async (params: LoginParams) => {
  return await httpRequest.request(`${baseUrl}/login`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: {
      'Content-Type': 'application/json'
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 收藏
export const like = async (params: LikeParams) => {
  return await httpRequest.request(`${baseUrl}/like`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: { 'Content-Type': 'application/json' },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 取消收藏
export const cancelLike = async (params: LikeParams) => {
  return await httpRequest.request(`${baseUrl}/notlike`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: { 'Content-Type': 'application/json' },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 查询收藏商品
export const getLike = async (params: LikeParams) => {
  return await httpRequest.request(`${baseUrl}/findlike`, {
    // 请求类型
    method: http.RequestMethod.GET,
    // 如果是POST请求，参数可以为一个对象
    extraData: {
      pid: params.pid,
      token: params.token
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 加入购物袋
export const addShopbag = async (params: ShopbagParams) => {
  return await httpRequest.request(`${baseUrl}/addShopcart`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: { 'Content-Type': 'application/json' },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 查询购物袋数量
export const getShopbagCount = async (token: string) => {
  return await httpRequest.request(`${baseUrl}/shopcartCount`, {
    // 请求类型
    method: http.RequestMethod.GET,
    // 如果是POST请求，参数可以为一个对象
    extraData: {
      token
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

// 获取所有购物袋数据
export const getAllShopbagData = async (token: string) => {
  return await httpRequest.request(`${baseUrl}/findAllShopcart`, {
    // 请求类型
    method: http.RequestMethod.GET,
    // 如果是POST请求，参数可以为一个对象
    extraData: {
      token
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

//修改购物袋数量
export const updateShopbagCount = async (params: ShopbagCountParams) => {
  return await httpRequest.request(`${baseUrl}/modifyShopcartCount`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: {
      'Content-Type': 'application/json' },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

//删除购物袋数据
export const removeShopbagData = async (params: RemoveShopbagParams) => {
  return await httpRequest.request(`${baseUrl}/deleteShopcart`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: {
      'Content-Type': 'application/json'
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

//获取登录用户信息
export const getUserInfo = async (token: string) => {
  return await httpRequest.request(`${baseUrl}/findMy`, {
    // 请求类型
    method: http.RequestMethod.GET,
    // 如果是POST请求，参数可以为一个对象
    extraData: {
      token
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}
//个人资料接口
//   请求地址：http://127.0.0.1:7001/findAccountInfo
//   请求类型： GET
//   请求参数： {
//     token: token字符串
//   }
export const getUserInfoData = async (token: string) => {
  return await httpRequest.request(`${baseUrl}/findAccountInfo`, {
    // 请求类型
    method: http.RequestMethod.GET,
    // 如果是POST请求，参数可以为一个对象
    extraData: {
      token
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}
//修改昵称接口
//   请求地址：http://127.0.0.1:7001/updateNickName
//   请求类型： POST
//   请求参数： {
//     token: token字符串,
//     nickName: 你的昵称
//   }
export const setUserInfoData = async (params: updateNickName) => {
  return await httpRequest.request(`${baseUrl}/updateNickName`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: {
      'Content-Type': 'application/json'
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

//修改简介接口
//   请求地址：http://127.0.0.1:7001/updateDesc
//   请求类型： POST
//   请求参数： {
//     token: token字符串,
//     desc: 简介
//   }
export const setUserDesc = async (params: updateNickName) => {
  return await httpRequest.request(`${baseUrl}/updateDesc`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: {
      'Content-Type': 'application/json'
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}

//修改密码接口
//   请求地址：http://127.0.0.1:7001/updatePassword
//   请求类型： POST
//   请求参数： {
//     token: token字符串,
//     password: 新密码
//     oldPassword: 旧密码
//   }

export const setUserPassword = async (params: updatePassword) => {
  return await httpRequest.request(`${baseUrl}/updatePassword`, {
    // 请求类型
    method: http.RequestMethod.POST,
    // 如果是POST请求，参数可以为一个对象
    extraData: JSON.stringify(params),
    // 请求头
    header: {
      'Content-Type': 'application/json'
    },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.OBJECT
  })
}