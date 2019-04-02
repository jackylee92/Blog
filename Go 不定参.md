# Go 不定参

## 传

>  传递的可以是一个切片，也可以普通传递，但传递的数据类型要一致

```
param := []string
funcName("nihao",param...)

funcName("nihao","hello","hi")
```

## 接

> 接到的param是一个切片

```
func funcName(name string, param ...interface{})
```

