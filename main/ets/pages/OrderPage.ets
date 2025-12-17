import { router } from "@kit.ArkUI";
@Entry
@Component
export struct OrderPage {
  private goBack = () => {
    router.back();
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.fanhui'))
          .width(24)
          .height(24)
          .margin({ right: 10 })
          .onClick(this.goBack);

        Text('我的订单')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        Text('')
          .width(34);
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 10, bottom: 10 })
      .backgroundColor('#FFFFFF');

      Divider()
        .strokeWidth(1)
        .color('#E5E5E5');

      // 订单内容区域
      Scroll() {
        Column() {
          Text('暂无订单')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ top: 50 })
            .textAlign(TextAlign.Center);

          Text('您还没有任何订单记录')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 10 })
            .textAlign(TextAlign.Center);
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')
        .height(300);
      }
      .width('100%')
      .layoutWeight(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5');
  }
}