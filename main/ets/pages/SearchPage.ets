import {Product} from '../components/Product'
import {searchProduct} from '../api/api'
import { addData, getData,deleteData} from '../utils/storage'
import {router} from '@kit.ArkUI'

@Entry
@Component
struct SearchPage {
  //定义商品数据
  @State productData:Object[]=[]
  //定义搜索历史
  @State historyData: string[]=[]
  //定义搜索历史的最大数量
  private maxCount:number=10
  //搜索关键字
  @State keyword:string =''

  private previousKeyword = ''

  @State selectedTagIndex: number = -1;

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

  aboutToAppear(): void {
    let historyData6: string[] = getData('historyData6') as string[]
    console.log('historyData6 ==>', JSON.stringify(historyData6))
    if(historyData6){
      this.historyData = historyData6;
    }
  }

  build() {
    // 页面外层容器：背景色#f2f2f2，占满全屏
    Column() {
      // 顶部搜索栏：返回图标 + 搜索框 + 搜索按钮
      Row() {
        // 返回图标（名称：left）
        Image($r('app.media.fanhui'))
          .width(24)
          .height(24)
          .margin({ right: 10 })
          .onClick(() => {
            // 添加点击事件，返回上一个页面
            router.back()
          });

        // 搜索组件
        Search({ placeholder: '输入商品名称' })
          .width('calc(100% - 34vp)')
          .height(40)
          .borderRadius(20)
          .searchButton('搜索')
          .onChange((value: string)=> {
            this.keyword = value
          })
          .onSubmit(async(value:string) =>{
            console.log('value ==>', value)
            if(!value){
              console.log('搜索关键字不能为空')
              return;
            }
            if (this.previousKeyword == value) {
              console.log('重复提交搜索')
              return;
            }
            //记录当前搜索关键字
            this.previousKeyword = value
            //取消选中搜索历史标签
            this.selectedTagIndex =-1;

            let data:Object = await searchProduct(value)
            console.log('data ==>',JSON.stringify(data))
            this.productData = Object(data).result.result

            //判断是否已经存在该搜索关键字
            if(this.historyData.indexOf(value)> -1){
              console.log('已经存在该搜索关键字')
              this.keyword =''
              return;
            }

            //判断搜索历史是否已满
            if(this.maxCount == this.historyData.length){
              //在数组头部删除一个元素
              this.historyData.shift()}
            //保存搜索历史
            this.historyData.push(value)
            //将搜索历史写入到用户首选项中
            addData('historyData6',this.historyData)
            //清空搜索框的内容
            this.keyword=''
          })

      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor('#fff')
      .padding({left: 10, right: 10})

      if(this.historyData.length > 0) {
        // 最近搜索区域
        Column() {
          // 最近搜索标题栏：文字 + 删除图标（名称：delete）
          Row() {
            Text('最近搜索')
              .fontSize(16)
              .fontWeight(FontWeight.Bold);
            Image($r('app.media.shanchu'))
              .width(20)
              .height(20)
              .onClick(() => {
                this.historyData = []
                deleteData('historyData6')
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .width('100%')


          // 最近搜索标签
          Flex({
            wrap: FlexWrap.Wrap
          }) {
            ForEach(this.historyData, (item: string, index: number) => {
              Text(item)
                .fontSize(14)
                .backgroundColor(this.selectedTagIndex == index ? 'rgba(0,49,189,0.15)' : '#f2f2f2')
                .fontColor(this.selectedTagIndex == index ? '#0E33B7' : '#000')
                .padding({
                  left: 12,
                  right: 12,
                  top: 6,
                  bottom: 6
                })
                .borderRadius(15)
                .margin({ right: 20, bottom: 20 })
                .onClick(async () => {
                  if (this.selectedTagIndex == index) {
                    return;
                  }
                  this.selectedTagIndex = index;
                  console.log('item ==> ', item)
                  let data: Object = await searchProduct(item)
                  this.productData = Object(data).result.result
                  this.previousKeyword = item

                })
            })

          }
          .width('100%')
          .margin({ top: 20, bottom: 20 })
        }
        .width('100%')
        .backgroundColor('#fff')
        .padding({ left: 10, right: 10, top: 20 })
      }

      // 商品列表区域（使用Product组件）
      //商品列表, 默认横向排列
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.productData,(item:Object,index: number)=>{
          Column(){
            Product({pro:item})
          }
          .width('calc(50% - 5vp)')
          .backgroundColor('#fff')
          .margin({ bottom: 10,right:index % 2 == 0 ? 10 : 0})
          .borderRadius(10)
          .padding(10)
          .onClick(():void =>{
            this.viewProductDetail(Object(item).pid)
          })
        })
      }
      .width('100%')
      .padding(10)


    }
    .backgroundColor('#f2f2f2')
    .width('100%')
    .height('100%')
  }
}