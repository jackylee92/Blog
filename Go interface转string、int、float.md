# Go interface转string、int、float



```
func interface2String(inter interface{}) {

    switch inter.(type) {

    case string:
        fmt.Println("string", inter.(string))
        break
    case int:
        fmt.Println("int", inter.(int))
        break
    case float64:
        fmt.Println("float64", inter.(float64))
        break
    }

}
```