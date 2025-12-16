// //封装用户首选项操作(本地存储操作)

import { preferences } from '@kit.ArkData'

let options: preferences.Options = { name: 'myStore' }

let context = getContext(this)

let dataPreferences: preferences.Preferences

function getPreferences(): preferences.Preferences {
  if (!dataPreferences) {
    dataPreferences = preferences.getPreferencesSync(context, options)
  }
  return dataPreferences
}

//本地存储的增删改查操作

//添加数据(修改数据)
export const addData = (key: string, value: number | string | boolean | number[] | string[] | boolean[]): void => {
  getPreferences()
  //添加数据
  dataPreferences.putSync(key, value)
  //刷新缓存区，就可以实现持久化存储
  dataPreferences.flushSync()
}

//获取数据
export const getData = (key: string): preferences.ValueType => {
  getPreferences()
  //如果key不存在，则默认返回 ‘’
  let result: preferences.ValueType = dataPreferences.getSync(key, '')
  return result
}

//删除单个数据
export const deleteData = (key: string): void => {
  getPreferences()
  dataPreferences.deleteSync(key)
  //刷新缓存区，就可以实现持久化存储
  dataPreferences.flushSync()
}




