@Component
export struct StepperComponent {
  //定义接收父组件数据的属性
  @Prop count:number = 1

  //定义接收父组件传递的函数
  public onCountChange=(value:number):void =>{
    console.log('子组件调用的')
  }

  build(){
    Row({ space:10 }) {
      //减数量图标(名称:reduce)
      Image($r('app.media.jiahao'))
        .width(24)
        .height(24)
        .opacity(this.count > 1 ? 1 : 0.5)
        .onClick(():void => {
          this.onCountChange(-1)
        })
      //数量显示
      Text(`${this.count}`)
        .width(24)
        .fontSize(14)
        .fontColor('#333')
        .textAlign(TextAlign.Center)

      //加数量图标(名称:add)
      Image($r('app.media.jiahao'))
        .width(24)
        .height(24)
        .onClick(():void =>{
          this.onCountChange(1)
        })
    }
    .alignItems(VerticalAlign.Center);
  }}