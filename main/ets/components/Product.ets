@Component
export  struct Product {
  @Prop pro:Object = Object({
    smallImg:'https://img.alicdn.com/imgextra/i3/2476861420/O1CN01B2v4wG1MMPLRkVhCz_!!2476861420.jpg_q50.jpg_.webp',
    name:'德芙巧克力',
    enname:'defu',
    price:'22.00',
    flag:'新品'
  })



  build() {
    Column(){
      Image(Object(this.pro).smallImg)
        .width('100%')
      Text(Object(this.pro).name)
        .margin({top:10})
        .maxLines(1)
        .textOverflow({overflow:TextOverflow.Ellipsis})
      Text(Object(this.pro).enname)
        .fontSize(14)
        .fontColor('#666')
        .maxLines(1)
        .textOverflow({overflow:TextOverflow.Ellipsis})
      Text(`￥${Object(this.pro).price}`)
        .margin({top:10})
        .fontColor('#0E33B7')
        .fontWeight(FontWeight.Bold)

      if(Object(this.pro).flag){
        Text(Object(this.pro).flag)
          .fontSize(12)
          .backgroundColor('#0E33B7')
          .position({
            right:0,
            top:0
          })
          .fontColor('#fff')
          .padding({
            left: 5,
            right: 5,
            top: 3,
            bottom: 3
          })
          .borderRadius({
            bottomLeft: 9
          })
      }
    }
    .width('100%')


    // Column(){
    //   Image('https://img.alicdn.com/imgextra/i3/2476861420/O1CN01B2v4wG1MMPLRkVhCz_!!2476861420.jpg_q50.jpg_.webp')
    //     .width('100%')
    //   Text('[新品]纵享丝滑德芙')
    //     .fontSize(12)
    //     .margin({top:10})
    //     .maxLines(1)
    //     .textOverflow({overflow:TextOverflow.Ellipsis})
    //   // Text('chocolate')
    //   //   .fontSize(12)
    //   //   .fontColor('#666')
    //   //   .maxLines(1)
    //   //   .textOverflow({overflow: TextOverflow.Ellipsis})
    //   Text('￥99.00')
    //     .fontColor('#f00')
    //     .fontSize(14)
    //     .margin({ top: 5 })
    //     .fontWeight(FontWeight.Bold)
    // }
    // .width('100%')

  }
}