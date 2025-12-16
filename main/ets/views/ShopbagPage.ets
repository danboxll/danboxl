import { StepperComponent } from '../components/StepperComponent'
import  {router }from '@kit.ArkUI'
import { getAllShopbagData, updateShopbagCount,removeShopbagData }from '../api/api'
import { getData } from '../utils/storage'
import { ShopbagCountParams,RemoveShopbagParams } from '../paramsInterface/paramsInterface'
import { beforeItSpecified } from '@ohos/hypium'

@Component
export struct ShopbagPage {
  //定义所有购物袋数据
  @State shopbagData: Object[]=[]
  //定义token
  private token:string =''
  //定义是否状态状态
  @State isEdit: boolean =false
  //定义选择购物袋的sid
  private selectedShopbagSid:string[]=[]
  //定义勾选商品的总金额
  @State total:string ='0.00'


  //单选
  private selectOne =(sid:string):void =>{
    console.log('sid ==>',sid)
    let index : number = this.selectedShopbagSid.indexOf(sid)
    if (index == -1) {
      // 如果sid不存在，则添加
      this.selectedShopbagSid.push(sid)
    } else {
       // 如果sid存在，则删除
      this.selectedShopbagSid.splice(index,1)
    }
    console.log('this.selectedshopbagSid ==>', JSON.stringify(this.selectedShopbagSid))

    //修改当前商品的勾选状态
    for(let i = 0 ; i < this.shopbagData.length; i++){
      if(Object(this.shopbagData[i]).sid == sid){
        console.log('进来')
        Object(this.shopbagData[i]).isSelected = index == -1
        break
      }
    }
    console.log('单选 this,shopbgaData', JSON.stringify(this.shopbagData))

    //计算勾选商品的总金额
    this.sum()
  }


  //全选
  private selectAll=()=> {
    if (this.selectedShopbagSid.length == 0) {
      this.shopbagData.forEach((item: Object) =>{
        this.selectedShopbagSid.push(Object(item).sid)
      })
    } else {
      this.selectedShopbagSid = []
    }
    console.log('this.selectedShopbagSid ==>', JSON.stringify(this.selectedShopbagSid))

    this.shopbagData.forEach((item: Object) =>{
      Object(item).isSelected = this.selectedShopbagSid.length >0
    })
    console.log('单选 this,shopbgaData', JSON.stringify(this.shopbagData))

    //计算勾选商品的总金额
    this.sum()
  }

  //修改购物袋数量
  private  updataCount = async (value: number,index: number) =>{
    console.log('修改购物袋数量')
    console.log('value ==> ', value)
    console.log('index ==> ', index)

    let countValue: number = Object(this.shopbagData[index]).count + value
    if(countValue >= 1 ){
      let sid:string =Object(this.shopbagData[index]).sid
      let params: ShopbagCountParams ={
        sid,
        token: this.token,
        count: countValue
      }
      let data: Object = await updateShopbagCount(params)
      console.log('修改购物袋数量 data ==>',JSON.stringify(data))

      if(Object(data).result.code == 700){
        return router.pushUrl({
          url:'pages/LoginPage'
        })
      }
      if(Object(data).result.code == 6000){
        Object(this.shopbagData[index]).count = countValue
        this.shopbagData = [...this.shopbagData]

        this.sum()
      }
    }
  }
  //删除购物袋数据
  private removeShopbag = async () => {
    //1.删除数据库的数据
    //2.删除页面的数据
    //3.删除selectedShopbagsid数组的数据
      let params: RemoveShopbagParams = {
        sids: JSON.stringify(this.selectedShopbagSid),
        token: this.token
      }
      let data: Object = await removeShopbagData(params)
      console.log('删除购物袋数据 data ==>', JSON.stringify(data))

      if (Object(data).result.code == 700) {
        return router.pushUrl({
          url: 'pages/LoginPage'
        })
      }
      if (Object(data).result.code == 7000) {
        //删除页面的购物袋数据
        this.selectedShopbagSid.forEach((sid: string) =>{
          for(let i = 0; i < this.shopbagData.length; i++){
            if(Object(this.shopbagData[i]).sid == sid){
              this.shopbagData.splice(i,1)
              break
            }
          }
        })
        this.shopbagData =[...this.shopbagData]
        this.selectedShopbagSid = []

        this.total = '0.00'
      }
    }

    //计算勾选商品的总金额
  private sum = () => {
    let total: number = 0
    this.shopbagData.forEach((item: Object) => {
      if (this.selectedShopbagSid.indexOf(Object(item).sid) >  -1) {
        total += Object(item).price * Object(item).count
      }
    })
    this.total = total.toFixed(2)
    console.log('总金额 ==>', this.total)
  }


  async aboutToAppear(){
    this.token = getData('token6') as string

    let data: Object = await getAllShopbagData(this.token)
    console.log('购物袋数据 data ==>', JSON.stringify(data))

    if (Object(data).result.code == 700) {
      //未登录，跳转到登录页面
      router.pushUrl({
        url: 'pages/LoginPage'
      })
    }
    if (Object(data).result.code == 5000) {
      let result: Object[]  = Object(data).result.result
      //添加一个单选属性
      Object(result).forEach((item: Object) =>{
        Object(item).isSelected = false
      })
      this.shopbagData = result
    }
  }

  build() {
    // 页面根容器：背景#f2f2f2、垂直布局
    Column() {

      Scroll() {
        Column() {
          Column() {
            // 顶部背景图（名称：shopbag_bg）
            Image($r('app.media.gouwuche1'))
              .width('100%')

            Text(this.isEdit ? '完成' : '编辑')
              .width(64)
              .height(36)
              .backgroundColor('rgba(15,51,183,0.85)')
              .fontColor('#fff')
              .textAlign(TextAlign.Center)
              .position({
                right: 0,
                top: 16
              })
              .borderRadius({
                topLeft: 18,
                bottomLeft: 18
              })
              .onClick((): void =>{
                this.isEdit = !this.isEdit
              })
          }
          .width('100%')

          // 商品列表容器
          Column({ space: 10 }) {
            // 商品项1：满杯百香果
            ForEach(this.shopbagData, (item: Object,index :number) => {
              Row({ space: 10 }) {
                //复选框
                Checkbox({group:'checkboxGroup'})
                  .size({ width:20,height:20 })
                  .selectedColor('#0E33B7')
                  .onClick(():void => {
                  this.selectOne(Object(item).sid)
                })

                Column() {
                  // 商品图片
                  Image(Object(item).smallImg)
                    .width(80)
                    .height(80)
                    .borderRadius(5)
                  if (Object(item).flag) {
                    Text(Object(item).flag)
                      .fontSize(10)
                      .backgroundColor('#0E33B7')
                      .position({
                        right: 0,
                        top: 0
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
                .width(80)
                .height(80)

                Column() {
                  // 商品信息
                  Column({ space: 5 }) {
                    Text(Object(item).name)
                      .fontSize(14)
                      .fontColor('#333333')
                    Text(Object(item).enname)
                      .fontSize(12)
                      .fontColor('#999999')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .width('100%')

                  // 价格+数量组件
                  Row({ space: 8 }) {
                    Text(`￥${Object(item).price}`)
                      .fontSize(14)
                      .fontColor('#0E33B7')
                      .fontWeight(FontWeight.Bold)
                    StepperComponent({ count: Object(item).count, onCountChange: (value: number) => {
                      this.updataCount(value,index)
                    }})
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width('100%')
                }
                .height(80)
                .justifyContent(FlexAlign.SpaceBetween)
                .width('calc(100% - 130vp)')
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .padding(10)
              .alignItems(VerticalAlign.Center)
              .borderRadius(10)
            })
          }
          .width('100%')
          .padding(10)

        }
        .width('100%')
        .padding({ bottom: 60 })
      }

      // 底部操作栏（固定在页面底部）
      Row({ space: 10 }) {
        Row() {
          // 全选复选框
          CheckboxGroup({ group:'checkboxGroup'})
            .size({ width:20,height:20 })
            .selectedColor('#0E33B7')
            .onClick(():void =>{
              this.selectAll()
            })

          Text('全选')
            .fontSize(14)
            .fontColor('#333333')
            .margin({ left: 10 })
        }

        if(this.isEdit){
          Text('删除选择')
            .fontSize(16)
            .fontColor('#ffffff')
            .backgroundColor('#0E33B7')
            .padding({
              left:10,
              right:10,
              top:10,
              bottom:10
            })
            .borderRadius(5)
            .onClick((): void =>{
              this.removeShopbag()
            })
        }else{
          Row(){
            Text('合计:')
              .fontSize(14)
              .fontColor('#333333')
            Text(`￥${this.total}`)
              .fontColor('#0E33B7')
              .margin({right: 10})
              .fontWeight(FontWeight.Bold)

            Text('提交订单')
                .fontSize(16)
                .fontColor('#ffffff')
                .backgroundColor('#0E33B7')
                .padding({
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10
                })
                .borderRadius(5);
          }
        }

      }
      .width('100%')
      .backgroundColor('#ffffff')
      .padding(10)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .position({
        left: 0,
        bottom: 0
      })
      .borderWidth({ bottom: 1 })
      .borderColor({ bottom: '#f2f2f2' })
      .borderStyle({ bottom: BorderStyle.Solid })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2f2f2');
  }
}