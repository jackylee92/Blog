# Go Map

## Map 初始化问题

> assignment to entry in nil map

__错误写法__ 

````
var m map[string]string
m["result"] = "result"
````

> 上面的第一行代码并没有对map进行一个初始化，而却对其进行写入操作，就是对空指针的引用，这将会造成一个painc。所以，得记得用make函数对其进行分配内存和初始

__正确写法__

````
m := make(map[string]string)
m["result"] = "result"
````

## golang中的map并不是并发安全的

> 在开多个goruntine向map中写，在goroutine过多时会产生错误,也就是map并发写入出错.

````
fatal error: concurrent map writes

goroutine 75 [running]:
runtime.throw(0x13b2011, 0x15)
````

解决方案：

> 可以自建map锁，通过自定义get、set方法来对锁进行控制

````
// M
type M struct {
    Map    map[string]string
    lock sync.RWMutex // 加锁
}

// Set ...
func (m *M) Set(key, value string) {
    m.lock.Lock()
    defer m.lock.Unlock()
    m.Map[key] = value
}

// Get ...
func (m *M) Get(key string) string {
    return m.Map[key]
}
````

