import { promptAction, router } from "@kit.ArkUI";

// 定义用户信息接口
interface UserInfo {
  name?: string;
  avatar?: string;
}

// 定义功能列表项接口
interface FunctionItem {
  id: number;
  icon: Resource;
  title: string;
  arrow: boolean;
  route: string;
}

@Component
export struct MinePage {

  @State isLoggedIn: boolean = false;
  @State userInfo: UserInfo = {};

  aboutToAppear() {
    console.log('MinePage aboutToAppear');
    // TODO: 检查登录状态，从storage获取
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

  build() {
    Column() {
      // 顶部区域：登录按钮或头像
      if (!this.isLoggedIn) {
        Button('登录')
          .width('80%')
          .height(40)
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/LoginPage' });
          })
      } else {
        Image($r('app.media.touxiang'))
          .width(50)
          .height(50)
          .margin({ top: 20, bottom: 20 })
          .borderRadius(25)
      }

      // 功能列表
      Scroll() {
        Column() {
          List() {
            ForEach(this.functionList, (item: FunctionItem) => {
              ListItem() {
                Row() {
                  Image(item.icon)
                    .width(24)
                    .height(24)
                    .margin({ right: 10 })
                  Text(item.title)
                    .fontSize(16)
                    .layoutWeight(1)
                  if (item.arrow) {
                    Image($r('app.media.youjiantou'))
                      .width(16)
                      .height(16)
                  }
                }
                .width('100%')
                .padding({ left: 20, right: 20, top: 15, bottom: 15 })
                .onClick(() => {
                  router.pushUrl({ url: item.route })
                })
              }
            })
          }
          .width('100%')
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')

      // 底部：退出登录按钮
      if (this.isLoggedIn) {
        Button('退出登录')
          .width('80%')
          .height(40)
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            this.isLoggedIn = false;
            console.log('退出登录');
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F2F2')
  }
}