# GO知识点

## Go new、make区别

* new

用来初始化一个对象，并且返回该对象的首地址．其自身是一个指针．可用于初始化任何类型

* make

返回一个初始化的实例，返回的是一个实例，而不是指针，其只能用来初始化：slice,map和channel三种类型

## 字符串对比

* 数字类型字符串可以对比大小

````
a = "111"
b := "222"
if a > b {
	log.Println("a大")
}else{
	log.Println("b大")
}
````

>  输出：a大

* 日期类型字符串可以对比大小

````
a := "2020-01-01"
b := "2021-01-01"
if a > b {
	log.Println("a大")
}else{
	log.Println("b大")
}
````
>输出：b大

##  数组排序

* 对象(二维)数组根据属性排序

````
type sortTool []map[string]int
func (p sortTool) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }
func (p sortTool) Len() int           { return len(p) }
func (p sortTool) Less(i, j int) bool {
	return p[i]["a"] < p[j]["a"]
}
func testSort(){
	list := sortTool{
		{
			"a": 1,
		},
		{
			"a": 3,
		},
		{
			"a": 2,
		},
	}

	sort.Sort(list)
	log.Println(list)
````

> 输出：[map[a:1] map[a:2] map[a:3]]

## 两经纬度点距离

````
// 获取距离 单位米
func GetDistance(lat1, lat2, lng1, lng2 float64) float64 {
	radius := 6371000.0 //6378137.0
	rad := math.Pi / 180.0
	lat1 = lat1 * rad
	lng1 = lng1 * rad
	lat2 = lat2 * rad
	lng2 = lng2 * rad
	theta := lng2 - lng1
	dist := math.Acos(math.Sin(lat1)*math.Sin(lat2) + math.Cos(lat1)*math.Cos(lat2)*math.Cos(theta))
	return dist * radius
}
````

## 数字字符串扩大100倍

````
import (
	"strings"
	"math/big""
)
// 字符串金额扩大100倍
func amountExpand100(amount string) (string){
	amountArr := strings.Split(amount, ".")
	if len(amountArr) == 1 {
		amount = amount +".00"
	}else if len(amountArr) == 2 && len(amountArr[1]) == 1 {
		amount = amount + "0"
	}
	r := new(big.Rat)
	r.SetString(amount + "*100")
	return r.FloatString(0)
}
````

## 读取文件

````
import (
	"os"
	"io/ioutil"
)
func ReadAll(filePth string) (string, error) {
	f, err := os.Open(filePth)
	if err != nil {
		return "", err
	}

	data, err := ioutil.ReadAll(f)
	return string(data), err
}
````

## 唯一ID生成

````
import "github.com/rs/xid"
func getId()(){
	guid := xid.New()
	println(guid.String())
}
````

## 不定参

 * 传递的可以是一个切片，也可以普通传递，但传递的数据类型要一致

```
param := []string
funcName("nihao",param...)

funcName("nihao","hello","hi")
```

* 接到的param是一个切片

```
func funcName(name string, param ...interface{})
```

## 一个包中可以多个init

下面写法是能编译通过的，按照文件再按照函数位置顺序执行init

````
import (
	"log"
)
func main(){
}

func init(){
	log.Println("1")
}

func init(){
	log.Println("2")
}

func init(){
	log.Println("3")
}
````

> 输出：
>
> 2020/02/29 12:57:43 1
> 2020/02/29 12:57:43 2
> 2020/02/29 12:57:43 3

## 类型转换与类型断言

https://www.cnblogs.com/zrtqsk/p/4157350.html



##  int、int64区别

> int在32位机器上就是int32，在64位机器上就是int64，不知道有没有记错。超过了int的上限就用int64，不然会溢出

__范围:__

```
uint8       the set of all unsigned  8-bit integers (0 to 255)
uint16      the set of all unsigned 16-bit integers (0 to 65535)
uint32      the set of all unsigned 32-bit integers (0 to 4294967295)
uint64      the set of all unsigned 64-bit integers (0 to 18446744073709551615)

int8        the set of all signed  8-bit integers (-128 to 127)
int16       the set of all signed 16-bit integers (-32768 to 32767)
int32       the set of all signed 32-bit integers (-2147483648 to 2147483647)
int64       the set of all signed 64-bit integers (-9223372036854775808 to 9223372036854775807)

float32     the set of all IEEE-754 32-bit floating-point numbers
float64     the set of all IEEE-754 64-bit floating-point numbers
```

