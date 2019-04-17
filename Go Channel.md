# Go Channel

## CSP

> CSP用户描述两个对立的并发实体通过共享的通信管道(channel)进行通行的并发模型；
>
> CSP中channel是第一类对象，它不关注发送消息的实体，而关注与发送消息时使用的管道(channel)

## Golang CSP

> golang借用CSP模型的一些概念为之实现并发进行理论支持，其实从实际出发，go语言并没有完全实现CSP模型所有理论，仅借用了Process和Channel这两个概念，Process在go语言中相当于goroutine，是实际并发执行的实体，每个实体之间通过Channel管道实现数据共享

## Go并发模式

### communicating sequential processes(CSP) 

> Grouting + channel 模式

### shared memory multithreading

> 共享内存+多线程模式

## Goroutine

> 并发执行的最小活动单元，当go程序执行时，一个执行main function的goroutine就会被创建(main goroutine)



## Channel

> 不同goroutine之间通讯的管道
>
> send：并发执行的实体(goroutine)，此处为管道一端发送数据；
>
> receive：也是一个执行的实体(goroutine)，可以是main，也可以是groutine，此处用于管道另一端接受数据；
>
> Channel：上述管道Channel；
>
> Buffer：receive写入管道时，Channl中Buffer，如果没有则阻塞；

### 创建

> channel创建通过make创建， 第一个int为channel中传递的数据类型，代表只能传递int数据。第二个参数为管道缓存大小，通过缓存使用可以尽量避免组赛，提高应用性能；

````
ch := make(chan int, capacity)
````

### 缓存

> capacity为Channel的容纳最多的元素数量，代表Channel的缓存大小
>
> 如果没有设置capacity，或者设置为0，说明没有缓存，只有当send和receive同时都准备好了，都处于阻塞状态时才能通讯，简单理解就是当一个send处于阻塞(其实就是监听Channel)时，这是如果receive执行到 ``ch <- 1``向Channel的缓存中传递数据1，就不会阻塞；但是如果send不处于监听状态时，receive执行到向管道中传递数据，这是receive就会阻塞；（我的解释为只有当send处于监听状态时会产生一个缓存，当有这个缓存时，receive才可以向Channel中传递数据，通讯才可以。这是在创建Channel时设置缓存为0的情况）
>
> 
>
> 如果设置了capacity，就可能不发生阻塞，只有当缓存使用满了后就会和capacity为0的效果一样

### 单向

> 单向的Chanel好像没有什么意义，此处一笔带过

````
a := chan T //可以接受和发送类型为T的数据的Channel
a := chan<- float64 // 只可以用来发送float64类型数据的Channel
a := <-chan int //只可以用来接受int类型的数据的channel
````

### 语法

__发送__

> 向一个close的channel中发送数据回到run-time panic

````
ch <- 1 //向channel类型的ch传递int类型1数据
````

__接受__

> 只有recive端传递数据时才能接收到，否则一直处于阻塞状态；
>
> 从一个nil的channel中获取数据会一直阻塞状态；
>
> 从一个已经close的channel中回去数据，不会阻塞，会获取到这个channel的数据类型的初始值

````
a := <-ch //从ch中获取数据
````

__判断是否Close__

>可以使用一个额外的返回值来检查channel是否关闭，bool类型

````
a, ok := <-ch
````

__Range__



__Select__



__Timeout__



__Timer__



__Ticker__



__Close__

