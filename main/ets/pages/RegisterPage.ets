import {router} from '@kit.ArkUI'
import {RegisterParams} from '../paramsInterface/paramsInterface'
import {userRegister} from '../api/api'


@Entry
@Component
struct RegisterPage {
  //定义手机号
  @State phone:string =''
  //定义密码
  @State password:string =''
  //定义昵称
  @State nickName:string=''

  private register =async() =>{
    console.log('注册')
    console.log('this.phone ==>', this.phone)
    console.log('this.password ==>',this.password)
    console.log('this.nickName ==>',this.nickName)
    //定义手机号正则，并校验手机号是否正确
    let phoneReg: RegExp = new RegExp('^1[3-9]\\d{9}$')
    if(!phoneReg.test(this.phone)){
      console.log('手机号格式错误')
      return
    }
    //定义密码正则，并校验密码是否正确
    let passwordReg: RegExp = new RegExp('^[A-Za-z][A-Za-z0-9]{5,15}$')
    if(!passwordReg.test(this.password)) {
      console.log('密码格式错误')
      return
    }
    //定义昵称正则，并校验昵称是否正确
    let nickNameReg: RegExp = new RegExp('^[A-Za-z\u4e00-\u9fa5]{1,20}$')
    if(!nickNameReg.test(this.nickName)) {
      console.log('昵称格式错误')
      return
    }
    //发起注册请求
    console.log('发起注册请求')
    let params: RegisterParams = {
      phone: this.phone,
      password: this.password,
      nickName: this.nickName
    }
    let data: Object = await userRegister(params)
    console.log('注册 data ==> ', JSON.stringify(data))
    //注册成功，跳转到登录页面
    if(Object(data).result.code == 100) {
      console.log('注册成功')
      //清空输入内容
      this.phone = ''
      this.password = ''
      this.nickName = ''
      router.pushUrl({
        url: 'pages/LoginPage'
      })
    }else if(Object(data).result.code == 102) {
      console.log('手机号已被注册')
    }else {
      console.log('注册失败')
    }
  }


  build() {
    Column() {

      Scroll() {
        Column() {
          // 品牌Logo+名称区域
          Column({ space: 10 }) {
            // Logo图片（名称：logo）
            Image($r('app.media.taobao'))
              .width(150)
              .height(120)
              .margin({ top: 20 })

            // 品牌名称
            Text('淘宝')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({top: 10})
          }
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 50 })

          // 手机号输入行
          Row() {
            Text('手机号')
              .fontSize(14)
              .fontColor('#333333')
              .width(60)

            // 手机号输入框
            TextInput({ placeholder: '输入手机号' ,text:this.phone})
              .width('calc(100% - 60vp)')
              .height(40)
              .backgroundColor('#f5f5f5')
              .borderRadius(5)
              .padding({ left: 10 })
              .onChange((value: string) => {
                this.phone = value
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 40 })

          // 密码输入行
          Row() {
            Text('密码')
              .fontSize(14)
              .fontColor('#333333')
              .width(60)

            // 密码输入框（type设为Password）
            TextInput({ placeholder: '输入密码' ,text:this.password})
              .width('calc(100% - 60vp)')
              .height(40)
              .backgroundColor('#f5f5f5')
              .borderRadius(5)
              .padding({ left: 10 })
              .type(InputType.Password)
              .onChange((value: string) => {
                this.password = value
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({top: 20})

          // 昵称输入行
          Row() {
            Text('昵称')
              .fontSize(14)
              .fontColor('#333333')
              .width(60)

            // 昵称输入框
            TextInput({ placeholder: '输入昵称' ,text:this.nickName})
              .width('calc(100% - 60vp)')
              .height(40)
              .backgroundColor('#f5f5f5')
              .borderRadius(5)
              .padding({ left: 10 })
              .onChange((value: string) => {
                this.nickName = value
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 20 })

          // 注册按钮（主题色背景）
          Column() {
            Text('注册')
              .fontSize(16)
              .fontColor('#ffffff')
          }
          .width('100%')
          .height(45)
          .backgroundColor('#0D33BA')
          .borderRadius(5)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .margin({top: 40})
          .onClick((): void => {
            this.register()
          })

          // 找回密码+注册行
          Row({}) {
            Text('已有账号，去登录')
              .fontSize(14)
              .fontColor('#666666')
              .onClick(() => {
                //跳转到登录页面
                router.pushUrl({
                  url: 'pages/LoginPage'
                })
              })

          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ top: 20 })

          // 提示信息区域
          Column({ space: 10 }) {
            Text('提示:')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333');

            Text('1、手机号为11位。')
              .fontSize(12)
              .fontColor('#666666')

            Text('2、密码由数字、字母组合，且必须以字母开头，6-16位。')
              .fontSize(12)
              .fontColor('#666666')

            Text('3、昵称由中英文组合，1-20位。')
              .fontSize(12)
              .fontColor('#666666')
          }
          .width('100%')
          .margin({ top: 40 })
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding({left: 10, right: 10})
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}