# Go 反射

## 关于反射

* 检查类型结构，例如数据类型
* 通过反射分析结构体，属性，方法

## API

* reflect.TypeOf() 针对类型
  * Name() 类型名
  * Name().Kind() 基础类型 例如 Name() 为结构体类型 Name().Kind()就为struct
  * NumField 类型的属性
  * NumMethod 类型实现的方法
  * Field(n) 第N个属，后接.Name 属性名 .Type 属性类型
  * Method(n) 第N个方法，后接.Name 方法名 .Type 方法对象  这个对象.NumIn 返回的是参数个数，In(n)第N个参数
* reflect.ValueOf() 针对值
  * Field(n) 第N个属性的值，返回的是一个反射，需要 .interface() 转为"正射"
  * optValue.Elem() 获取地址value中的值value，意思就是这个值为指针所指向的值
  * optValue.Elem().CanSet() 检查地址value中的值value是否能改变
  * optValue.Elem().SetInt(999) 只能设置int类型，设置为999
  * optValue.Elem().SetString("jajaja") 只能设置string类型
  * Value.FieldByName("name") 获取value这个值的name属性值
  * value.Kind() 返回值的系统类型 struct、string、int等
  * oValue().Method(n) 返回值的第N个方法的值(此处方法的值是指令)，放回的值(指令)通过.Call([]reflect.Value(param1, param2))调用，[]relent.Value(param1, param2) 转为反射类型的切片