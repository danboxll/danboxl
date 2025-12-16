import { promptAction, router } from "@kit.ArkUI";


// 声明路由参数类型
interface RouteParams {
  source: string;
  orderType?: string;
}

// 定义用户信息接口
interface UserInfo {
  avatar: Resource;
  nickName: string;
  phone: string;
  isLogin: boolean;
}

// 定义订单状态接口
interface OrderStats {
  pendingPayment: number;
  pendingDelivery: number;
  pendingReceipt: number;
  pendingComment: number;
}

// 定义功能列表项接口
interface FunctionItem {
  id: number;
  icon: Resource;
  title: string;
  arrow: boolean;
  route: string;
}

@Entry
@Component
export struct MinePage {
  // 定义用户信息
  @State userInfo: UserInfo = {
    avatar: $r('app.media.touxiang'), // 用户头像图标（使用已有图标）
    nickName: '用户昵称',
    phone: '138****8888',
    isLogin: false
  }

  // 定义订单状态数据
  @State orderStats: OrderStats = {
    pendingPayment: 0,  // 待付款
    pendingDelivery: 0, // 待发货
    pendingReceipt: 0,  // 待收货
    pendingComment: 0   // 待评价
  }

  // 定义功能列表数据
  @State functionList: FunctionItem[] = [
    {
      id: 1,
      icon: $r('app.media.home'), // 首页图标（使用已有图标）
      title: '我的信息',
      arrow: true,
      route: 'pages/CustomerServicePage' // 需要创建CustomerServicePage页面
    },
    {
      id: 2,
      icon: $r('app.media.gouwuche2'), // 购物车图标（使用已有图标）
      title: '我的订单',
      arrow: true,
      route: 'pages/OrderPage' // 需要创建OrderPage页面
    },
    {
      id: 3,
      icon: $r('app.media.weishoucang'), // 收藏图标（使用已有图标）
      title: '我的收藏',
      arrow: true,
      route: 'pages/CollectPage' // 需要创建CollectPage页面
    },
    {
      id: 4,
      icon: $r('app.media.gouwuche1'), // 购物袋图标（使用已有图标）
      title: '收货地址',
      arrow: true,
      route: 'pages/AddressPage' // 需要创建AddressPage页面
    },
    {
      id: 5,
      icon: $r('app.media.fenlei1'), // 分类图标（使用已有图标）
      title: '关于我们',
      arrow: true,
      route: 'pages/AboutPage' // 需要创建AboutPage页面
    }
  ]

  // 关于我们弹窗是否显示
  @State showAboutDialog: boolean = true

  // 退出登录弹窗是否显示
  @State showLogoutDialog: boolean = true

  // ... 其他方法保持不变 ...

  build() {
    Column() {
      // ... 顶部用户信息区域保持不变 ...

      // 订单状态区域
      Column() {
        // 订单状态标题
        Row() {
          Text('我的订单')
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)

          Text('查看全部')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ left: 'auto' })

          Image($r('app.media.youjiantou')) // 右箭头图标
            .width(12)
            .height(12)
            .margin({ left: 5 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ bottom: 15 })
        .onClick(() => {
          this.viewOrderDetail('all')
        })

        // ... 订单状态四个入口保持不变 ...
      }
      .width('90%')
      .backgroundColor('#ffffff')
      .padding(15)
      .margin({ top: 15 })
      .borderRadius(10)
      .shadow({ radius: 4, color: '#00000010', offsetX: 1, offsetY: 1 })

      // 功能列表区域
      Column() {
        ForEach(this.functionList, (item: FunctionItem) => {
          Column() {
            Row() {
              // 功能图标
              Image(item.icon)
                .width(20)
                .height(20)
                .margin({ right: 12 })

              // 功能标题
              Text(item.title)
                .fontSize(16)
                .fontColor('#333333')
                .layoutWeight(1)

              // 右侧箭头（如果有）
              if (item.arrow) {
                Image($r('app.media.youjiantou')) // 右箭头图标
                  .width(12)
                  .height(12)
              }
            }
            .width('100%')
            .height(50)
            .alignItems(VerticalAlign.Center)
            .onClick(() => {
              this.navigateToPage(item.route)
            })

            // 分割线（除了最后一个）
            if (item.id < this.functionList.length) {
              Divider()
                .color('#f2f2f2')
                .strokeWidth(1)
                .margin({ left: 32, right: 0 })
            }
          }
        })
      }
      .width('90%')
      .backgroundColor('#ffffff')
      .padding({ left: 15, right: 15 })
      .margin({ top: 15 })
      .borderRadius(10)
      .shadow({ radius: 4, color: '#00000010', offsetX: 1, offsetY: 1 })

      // ... 其他部分保持不变 ...
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2f2f2')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  // 跳转到功能页面
  navigateToPage(route: string) {
    try {
      router.pushUrl({
        url: route,
        params: { source: 'MinePage' } // 添加来源参数
      }).then(() => {
        console.debug(`[路由监控] 成功跳转至 ${route}`)
      }).catch((err: Error) => {
        console.error(`[路由错误] 代码:${err} 信息:${err.message}`)
        // 添加Toast提示用户
        promptAction.showToast({
          message: '功能正在开发中，敬请期待',
          duration: 3000
        })
      })
    } catch (error) {
      console.error(`[系统异常] ${error.code} ${error.message}`)
    }
  }

  // 查看订单详情
  viewOrderDetail(type: string) {
    const targetRoute = 'pages/OrderPage'
    try {
      router.pushUrl({
        url: targetRoute,
        params: { orderType: type } // 传递订单类型参数
      }).then(() => {
        console.log('Order page navigation success')
      }).catch((err: Error) => {
        console.error('Order page navigation failed:', err.message)
      })
    } catch (error) {
      console.error('Order navigation error:', error.message)
    }
  }
}