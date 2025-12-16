import {HomePage} from '../views/HomePage'
import {MenuPage} from '../views/MenuPage'
import {ShopbagPage} from '../views/ShopbagPage'
import {MinePage} from '../views/MinePage'

import { router } from "@kit.ArkUI"

interface TabbarItem {
  inactiveIcon:Resource,
  activeIcon:Resource,
  title:string
}

@Entry
@Component
struct Index {
  @State selectedIndex: number = 0
  @State tabbarData:TabbarItem[]= [
    {
      inactiveIcon:$r('app.media.home'),
      activeIcon:$r('app.media.home_active'),
      title:'首页'
    },
    {
      inactiveIcon:$r('app.media.fenlei1'),
      activeIcon:$r('app.media.fenlei2'),
      title:'分类'
    },
    {
      inactiveIcon:$r('app.media.gouwuche1'),
      activeIcon:$r('app.media.gouwuche2'),
      title:'购物车'
    },
    {
      inactiveIcon:$r('app.media.my'),
      activeIcon:$r('app.media.home_active'),
      title:'我的'
    }
  ]
  @Builder
  tabbarContent(item:TabbarItem, index:number) {
    Column(){
      Image(this.selectedIndex == index ? item.activeIcon : item.inactiveIcon)
        .width(26)
      Text(item.title)
        .fontSize(14)
        .margin({top:2})
        .fontColor(this.selectedIndex == index ?'#0E33B7':'#646567')
  }
  }

  aboutToAppear(): void {
    let index:number = Object(router.getParams()).index
    console.log('index==>', index)
    if (index !== undefined) {
      this.selectedIndex = index
    }
  }

  build() {
    Column() {
      Tabs() {
        ForEach(this.tabbarData, (item: TabbarItem, index: number) => {
          TabContent() {
            if(this.selectedIndex==0){
              //显示HomePage
              HomePage()
            }else if(this.selectedIndex==1) {
              //显示MenuPage
              MenuPage()
            }else if(this.selectedIndex==2){
                //显示ShopbagPage
              ShopbagPage()
            } else {
              //显示MinePage
              MinePage()
            }
          }
          .tabBar(this.tabbarContent(item,index))
        })
      }
      .barPosition(BarPosition.End)
      .barBackgroundColor('#fff')
      .onChange((value: number) => {
        //console.log('value ==>',，value);
        this.selectedIndex = value;
      })
    }
    .width('100%')
    .height('100%')
    .background('#f2f2f2')
  }
}