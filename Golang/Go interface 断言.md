# Go interface 断言

 **empty interface**

不带任何方法和参数的类型



如果一个类型实现某一个interface的所有方法，我们可以说这个类型实现了该interface，因为empty interface是一空interface，所以所有类型都实现了这个interface，一个interface可以被多个struct实现；

````
//1
type I interface {    
    Get() int
    Set(int)
}

//2
type S struct {
    Age int
}

func(s S) Get()int {
    return s.Age
}

func(s *S) Set(age int) {
    s.Age = age
}

//3
func f(i I){
    i.Set(10)
    fmt.Println(i.Get())
}

func main() {
    s := S{} 
    f(&s)  //4
}
````

上述代码解释：I为interface，S为实现了I的结构体

在21行，此处传一个interface类型I的，28行，此处使用&s为实现了I的interface的结构体，所以在f方法中可以通过I调用者的实现的方法



判断I的类型，需要使用类型断言，两种方法

````
if t, ok := i.(*S); ok {
    fmt.Println("s implements I", t)
}
````

````
switch t := i.(type) {
case *S:
    fmt.Println("i store *S", t)
case *R:
    fmt.Println("i store *R", t)
}
````

