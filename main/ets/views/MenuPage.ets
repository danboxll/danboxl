import {Product} from '../components/Product'
import {getType, getProductByType} from '../api/api'
import router from '@ohos.router'

@Component
export struct MenuPage{
  //定义商品类型数据
  @State typeData:Object[]=[]
  //定义选择的商品类型下标
  @State selectedTypeIndex:number =0
  //定义商品数据
  @State productData:Object[]=[]

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
    let data:Object = await getType();
    // console.log('商品类型数据 data ==>‘，JSON.stringify(data))
    this.typeData = Object(data).result.result;
    console.log('this.typeData ==>',JSON.stringify(this.typeData))
    //根据商品类型获取商品数据
    this.getProdyctDataByType();
  }

  //根据商品类型获取商品数据
  async getProdyctDataByType(){
    let typeId: string = Object(this.typeData [this.selectedTypeIndex]).typeId;
    console.log('typeId ==>',typeId)
    let data:Object = await getProductByType(typeId);
    console.log('根据商品类型获取商品数据 data ==>', JSON.stringify(data));
    this.productData =Object(data).result.result;
  }

  build() {
    Column() {
      //搜索框
      Column() {
        Search({ placeholder: '输入商品名称' })
          .onClick(() => {
            router.pushUrl({ url: 'pages/SearchPage' })
          })
      }
      .width('100%')
      .backgroundColor('#fff')
      .padding({ left: 10, right: 10 })



      //商品类型
      Row() {
        // 左侧分类菜单
        Column() {
          Scroll() {
            Column(){
              ForEach(this.typeData,(item:Object,index:number)=>{
                Column(){
                  Text(Object(item).type)
                    .fontColor(this.selectedTypeIndex == index ? '#0E33B7' : '#000')

                  if (this.selectedTypeIndex == index){
                    Column(){
                    }
                    .position({
                      left:0,
                      top:15
                    })
                    .width(4)
                    .height(30)
                    .backgroundColor('#0E33B7')
                  }
                }
                .width('100%')
                .height(60)
                .backgroundColor(this.selectedTypeIndex == index ? 'rgba(0,49,189,0.15)' : '#f2f2f2')
                .justifyContent(FlexAlign.Center)
                .onClick(() =>{
                  console.log('切换商品类型')
                  if (this.selectedTypeIndex == index){
                    return;
                  }
                  this.selectedTypeIndex = index;
                  //根据商品类型获取商品数据
                  this.getProdyctDataByType();

                })
              })
            }
            .width('100%')
          }
        }
        .width(80)
        .height('100%') // 继承父容器高度
        .backgroundColor('#f2f2f2')

        //商品列表
        Column() {
          Scroll(){
            Column() {
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.productData,(item: Object, index: number) =>{
                  Column(){
                    Product({pro:item})
                  }
                  .width('calc(50% - 5vp)')
                  .margin({right: index % 2 == 0 ? 10 : 0, bottom: 10})
                  .onClick(():void =>{
                    this.viewProductDetail(Object(item).pid)
                  })
                })

              }
              .width('100%')
              .padding({ left: 10, right: 10 })
            }
            .width('100%')
          }

        }
        .width('calc(100% - 80vp)')// 使用权重占据剩余空间
        .height('100%')
        .backgroundColor('#fff')
      }
      .width('100%')
      .height('100%')
      // .height('calc(100%-56vp)')
    }
    .width('100%')
    .height('100%')

  }
}