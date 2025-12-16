import { Product } from "../components/Product"
import {getProductByFlags} from  '../api/api'
import { it } from "@ohos/hypium"
import { router } from "@kit.ArkUI"

@Component
export struct HomePage{

  @State flags: string[] = ['新品','热销','推荐','折扣']
  @State selectedFlagIndex: number = 0
  private allProductData :Object[] = []
  private bannerFlag: string = '新品'

  @State bannerData :Object[] = []
  @State currentFlagProductData: Object[] = []

  private viewProductDetail(pid:string) {
    console.log('跳转到商品详情')
    router.pushUrl({
      url: 'pages/DetailPage',
      //携带参数
      params: {
        pid
      }
    })
  }

  async aboutToAppear() {
    let data:Object = await getProductByFlags(this.flags);

    this.allProductData = Object(data).result.result;
    console.log('商品标志的商品数据 data ==> ', JSON.stringify(data));

    let bannerProduct:Object[] = [];
    let currentFlag: string = this.flags[this.selectedFlagIndex]
    let currentFlagProduct: Object[] = []

    this.allProductData.forEach((item:Object)=> {
      //筛选默认选择的商品标志的商品数据
      if (Object(item).flag == this.bannerFlag) {
        bannerProduct.push(item);
      }
      //筛选默认选择的商品标志的商品数据
      if(Object(item).flag == currentFlag){
        currentFlagProduct.push(item)
      }
    })

    this.bannerData = bannerProduct;
    console.log('轮播图的新品数据 this.bannerData ==>',JSON.stringify(this.bannerData))

    this.currentFlagProductData = currentFlagProduct;
    console.log('筛选默认选择的商品数据 this.currentFlagProductData ==>', JSON.stringify(this.currentFlagProductData))
  }

  onFlagClick(index: number): void {
    if (this.selectedFlagIndex === index) {
      console.log('点击了相同的商品标志')
      return;
    }

    console.log('切换标志 index ==>', index)
    this.selectedFlagIndex = index

    let currentFlag: string = this.flags[index];
    let currentFlagProduct: Object[] = [];

    this.allProductData.forEach((item: Object) => {
      if (Object(item).flag == currentFlag) {
        currentFlagProduct.push(item)
      }
    })

    this.currentFlagProductData = currentFlagProduct;
  }

  build() {
    Column(){
      Scroll(){
        Column(){
          // 搜索栏
          Column(){
            Search({placeholder:"请输入商品名称"})
              .onClick(() => {
                router.pushUrl({ url: 'pages/SearchPage' })
              })
          }
          .width('100%')
          .background('#fff')
          .padding({left:10, right:10})

          // 轮播图
          Swiper(){
            ForEach(this.bannerData, (item: Object) => {
              Image(Object(item).largeImg)
                .width('80%')
                .height(200)
                .objectFit(ImageFit.Contain)
                .onClick((): void=>{
                  this.viewProductDetail(Object(item).pid)
                })
            })
          }
          .indicator(new DotIndicator().selectedColor('#0E33B7').color('#999'))
          .autoPlay(true)
          .interval(2000)
          .height(220)
          .margin({ top: 10, bottom: 10 })

          // 标志选择
          Row() {
            ForEach(this.flags, (item: string, index: number) => {
              Column(){
                Text(item)
                  .width(70)
                  .height(70)
                  .backgroundColor(this.selectedFlagIndex == index ? '#00CEC9' : '#f2f2f2')
                  .fontColor(this.selectedFlagIndex == index ? '#fff' : '#000')
                  .borderRadius(35)
                  .textAlign(TextAlign.Center)
                  .onClick(() => {
                    this.onFlagClick(index)
                  })
              }
              .width('25%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
            })
          }
          .width('100%')
          .backgroundColor('#fff')
          .padding({ top: 10, bottom: 10 })

          // 商品列表
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(this.currentFlagProductData, (item: Object, index: number) => {
              Column() {
                Product({ pro: Object(item) })
              }
              .width('49%')
              .backgroundColor('#fff')
              .margin({ bottom: 10 })
              .borderRadius(10)
              .padding(10)
              .shadow({ radius: 4, color: '#00000010', offsetX: 1, offsetY: 1 })
              .onClick((): void=>{
                this.viewProductDetail(Object(item).pid)
              })
            })
          }
          .width('100%')
          .padding(10)
        }
        .width('100%')
      }
      .width('100%')
      .scrollBar(BarState.On) // 开启滚动条
      .scrollBarColor('#999999') // 设置滚动条颜色
      .scrollBarWidth(4) // 设置滚动条宽度
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2f2f2')
  }
}