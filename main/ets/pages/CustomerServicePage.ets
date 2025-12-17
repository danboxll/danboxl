import { router } from "@kit.ArkUI";

@Entry
@Component
export struct CustomerServicePage {
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

        Text('我的信息')
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

      // 内容区域
      Scroll() {
        Column() {
          Text('我的信息内容')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ top: 50 })
            .textAlign(TextAlign.Center);
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F2F2')
  }
}