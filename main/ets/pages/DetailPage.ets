import {StepperComponent} from '../components/StepperComponent'
import { router } from '@kit.ArkUI'
import {  getProductDetail,like,cancelLike,getLike,addShopbag,getShopbagCount } from '../api/api'
import { LikeParams,ShopbagParams } from '../paramsInterface/paramsInterface'
import { getData} from '../utils/storage'

@Entry
@Component
struct DetailPage {
  //定义数量
  @State count:number=1

  //定义商品详情数据
  @State productDetailData : Object = Object({})

  //定义pid
  private pid:string =''
  //定义token
  private token:string =''
  //定义是否收藏
  @State isLike:boolean = false

  //定义购物袋数量
  @State shopbagCount:number =0

  //定义函数修改count
  public updateCount=(value:number): void => {
    console.log('商品详情页面 value ==>',value)
    let countValue : number = this.count +value
    if(countValue >= 1) {
      this.count = countValue
    }
  }

  //收藏，取消收藏
  private likeProduct = async()=> {
    //获取参数
    let params:LikeParams={
      pid: this.pid,
      token: this.token
    }
    let data: Object = Object({})
    if(this.isLike){
      //取消收藏
      data = await cancelLike(params)
    } else {
      //收藏
      data = await like(params)
    }
    console.log('收藏、取消收藏 data ==>',JSON.stringify(data))
    if(Object(data).result.code == 700){
      //未登录
      router.pushUrl({
        url: 'pages/LoginPage'
      })
    }else if(Object(data).result.code ==800){
    this.isLike = true
    }else if(Object(data).result.code == 900){
    this.isLike = false
    }
  }

  //加入购物袋
  private addShopbagData =async () =>{
    console.log('this.count ==>',this.count)
    console.log('this.pid ==>',this.pid)
    console.log('this.token ==>',this.token)

    let params:ShopbagParams={
      count: this.count,
      pid: this.pid,
      token: this.token
    }

    let data:Object = await addShopbag(params)
    console.log('data 加入购物袋==>',JSON.stringify(data))

    if(Object(data).result.code == 700){
      return router.pushUrl({
        url: 'pages/LoginPage'
      })
    }
    if(Object(data).result.code ==3000){
      this.shopbagCount += this.count
    }

  }

  async aboutToAppear(){
    //获取token
    this.token = getData('token6') as string

  //截取参数
    let pid: string = Object(router.getParams()).pid;
    console.log('商品详情页面 pid ==>',pid)

    this.pid = pid

    let params: LikeParams  ={
      pid:this.pid,
      token:this.token
    }

    let likeData: Object = await getLike(params)
    console.log('查询收藏商品 likeData ==> ', JSON.stringify(likeData))

    if(Object(likeData).result.code == 1000 && Object(likeData).result.result.length > 0){
      this.isLike = true
    }

    //查询购物袋数量

    let shopbagData: Object = await getShopbagCount(this.token)
    console.log('购物袋数量 ==>', JSON.stringify(shopbagData))
    if (Object(shopbagData).result.code == 4000) {
      this.shopbagCount = Object(shopbagData).result.result
    }


    let data: Object = await getProductDetail(pid)
    console.log('商品详情数据 data ==>',JSON.stringify(data))

    let result:Object = Object(data).result.result[0]

    //处理商品描述
    let descData:string[]=Object(result).desc.split('\n')

    let newDescData:string[]=[]
    descData.forEach((item:string)=>{
      if (item.trim()){
        newDescData.push(item)
    }
  })

    Object(result).descData=newDescData

    this.productDetailData=result

    console.log('this.productDetailData ==>',JSON.stringify(this.productDetailData))
  }



  build() {
    // 页面根容器：属性在{}后链式调用
    Column() {
      // 顶部栏：返回图标 + 标题
      Row() {
        // 返回图标（名称：left）
        Image($r('app.media.fanhui'))
          .width(26)
          .height(26)
          .position({ left: 0, top: 0 })
          .zIndex(2)
          .onClick(() =>{
            router.back()
          })
        // 标题文本
        Text('商品详情')
          .textAlign(TextAlign.Center)
          .width('100%')
      }
      .width('100%')
      .height(60)
      .backgroundColor('#fff')
      .padding({
        top: 15,
        bottom: 15,
        left: 10,
        right: 10
      })
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          // 商品图片区域
          Image(Object(this.productDetailData).largeImg) // 替换为实际商品图资源
            .width('100%')
          // 商品信息区域（白色背景）
          Column({ space: 10 }) {
            // 商品标签+名称+价格
            Column({ space: 10 }) {
              Row() {
                // 商品价格
                Text(`￥${Object(this.productDetailData).price}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#0D33BA');
                // 时令标签（主题色）
                if(Object(this.productDetailData).flag){
                  Text(Object(this.productDetailData).flag)
                    .fontSize(14)
                    .fontColor('#fff')
                    .backgroundColor('#0D33BA')
                    .padding({
                      left: 5,
                      right: 5,
                      top: 2,
                      bottom: 2
                    })
                    .borderRadius(2);
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ top: 10, bottom: 10 })
              .alignItems(VerticalAlign.Center)
              // 商品名称+英文名称
              Column({ space: 7 }) {
                Text(Object(this.productDetailData).name)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(Object(this.productDetailData).enname)
                  .fontSize(14)
                  .fontColor('#999')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            // 选择数量区域
            Row({ space: 10 }) {
              Text('选择数量')
                .fontSize(14)
                .fontColor('#333');
              // 数量选择组件（靠右）
              Column(){
                StepperComponent({count: this.count,onCountChange:this.updateCount})
              }
              .margin({right:20})
              // StepperComponent()
              //   .margin({ left: 'auto' });
              // Text('StepperComponent')
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 30 })
            // 商品描述区域
            Column({ space: 15 }) {
              Text('商品描述')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333')

              // 描述内容（带主题色圆点）
              ForEach(Object(this.productDetailData).descData,(item:string)=>{
                Row({ space: 5 }) {
                  Flex() {
                    // 圆点占位
                  }
                  .width(6)
                  .height(6)
                  .backgroundColor('#0D33BA')
                  .borderRadius(3)
                  .margin({right: 5})

                  Text(item)
                    .fontSize(14)
                    .fontColor('#666')
                    .width('calc(100% - 11vp)')
                }
                .alignItems(VerticalAlign.Center)
                .width('100%')
              })
              // Row({ space: 5 }) {
              //   Flex() {
              //     // 圆点占位
              //   }
              //   .width(6)
              //   .height(6)
              //   .backgroundColor('#0D33BA')
              //   .borderRadius(3)
              //
              //   Text('德芙巧克力-0000好吃')
              //     .fontSize(14)
              //     .fontColor('#666')
              // }
              // .alignItems(VerticalAlign.Center)
              // .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 30 })
          }
          .width('100%')
          .backgroundColor('#fff')
          .padding(10)
          .margin({ top: 10 })
        }
        .width('100%')
        .padding({bottom: 130})
      }

      // 底部操作栏（固定在底部）
      Row({ space: 0 }) {
        // 购物袋（图标：notbag）
        Column({ space: 2 }) {
          Image($r('app.media.gouwuche2'))
            .width(24)
            .height(24)

          Text('购物袋')
            .fontSize(12)
            .fontColor('#666')
          if (this.shopbagCount >0 ){
            Text(`${this.shopbagCount >= 100 ? '9+' : this.shopbagCount}`)
              .position({
                top:-3,
                right:12
              })
              .backgroundColor('#0E33B7')
              .fontSize(10)
              .fontColor('#fff')
              .width(16)
              .height(16)
              .textAlign(TextAlign.Center)
              .borderRadius('50%')
          }
        }
        .alignItems(HorizontalAlign.Center)
        .width(60)
        .onClick(():void =>{
          router.pushUrl({
            url:'pages/Index',
            params:{
              index: 2
            }
          })
        })

        // 收藏（图标：notlike）
        Column({ space: 2 }) {
          Image(this.isLike ? $r('app.media.yishoucang') : $r('app.media.weishoucang'))
            .width(24)
            .height(24);

          Text(this.isLike ? '取消收藏' : '收藏')
            .fontSize(12)
            .fontColor('#666');
        }
        .alignItems(HorizontalAlign.Center)
        .width(60)
        .onClick(():void => {
          this.likeProduct()
        })

        // 加入购物袋按钮（主题色）
        Text('加入购物袋')
          .width('calc(100% - 140vp)')
          .fontColor('#fff')
          .backgroundColor('#0D33BA')
          .padding(10)
          .borderRadius(5)
          .textAlign(TextAlign.Center)
          .margin({ left: 20 })
          .onClick((): void => {
            this.addShopbagData()
          })
      }
      .width('100%')
      .backgroundColor('#fff')
      .padding(10)
      .alignItems(VerticalAlign.Center)
      .position({ left: 0, bottom: 0 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2f2f2');
  }
}