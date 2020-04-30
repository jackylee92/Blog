# Go Channel、Goroutine、Time

## CSP

> CSP用与描述两个对立的并发实体通过共享的通信管道(channel)进行通行的并发模型；
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

for循环中使用goroutine需要注意

> 错误使用：go协程中使用的item的地址，在上面list循环中item的值是一只变化的。所以go协程中的item值并不是一一对应的

````
for _,item := range list {
 go func(){
   log.Println(item)
 }()
}
````

> 正确用法：通过参数形式传递进去

````
for _,item := range list {
 tmp := item
 go func(timA string) {
  log.Println(tmpA)
 }(tmp)
}
````





## Channel

> 不同goroutine之间通讯的管道
>
> 下文涉及到几个名词：
>
> ​	send：并发执行的实体(goroutine)，此处为管道一端发送数据；
>
> ​	receive：也是一个执行的实体(goroutine)，可以是main，也可以是groutine，此处用于管道另一端接受数据；
>
> ​	Channel：上述管道Channel；
>
> ​	Buffer：receive写入管道时，Channl中Buffer，如果没有则阻塞；

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

## 使用

__发送__

> 向一个close的channel中发送数据会报run-time panic

````
ch <- 1 //向channel类型的ch传递int类型1数据
````

__接受__

> 只有recive端传递数据时才能接收到，否则一直处于阻塞状态；
>
> 从一个nil的channel中获取数据会一直阻塞状态；
>
> 从一个已经close的channel中获取数据，不会阻塞，会获取到这个channel之前存入但未取出的数据，如果没有则会取出数据类型的初始值

````
a := <-ch //从ch中获取数据
````

__判断是否Close__

>可以使用一个额外的返回值来检查channel是否关闭，bool类型

````
a, ok := <-ch
````

__Range__

> 循环处理channel，直到该channel关闭，退出循环

````
func MakeSend(ch chan int, count int){
	for i := 1; i <= count; i++ {
		ch <- i
	}
  close(ch) 
}

func MakeReCever(ch chan int){
  for i := range ch {
    log.Println(i)
  }
}

func main(){
  ch := make(chan int)  //创建一个传递int类型的channel
  go MakeSend(ch,10)	//执行send 循环10次向ch中传递数据，执行完后关闭ch
  go MakeRecever(ch) // 执行Recever 循环的接受每次send传递的数据，当channel关闭时，此循环退出
  
  //此处注意mian方法执行完后，程序就会结束，所有channel都会释放，goroutine也会释放；
}

````

__Select__

> select中会有多个case，每个case key为一个ch，当执行到select时判断每个case的channel是否处于阻塞状态，如果是则随机选择一个执行case中的逻辑，如果都没阻塞，并且有一个default，则执行default内容，如果没有case，default可执行，则会处理阻塞状态，直到某一个case阻塞；
>
> 一半select会与for配合使用，一直循环监听某几个channel是否有数据传递过来；
>
> 执行思路如下：
>
> 检查每个case代码块
>
> 如果任意一个case代码块准备好发送或接收，执行对应内容
>
> 如果多余一个case代码块准备好发送或接收，随机选取一个并执行对应内容
>
> 如果任何一个case代码块都没有准备好，等待如果有default代码块，并且没有任何case代码块准备好，执行default代码块对应内容

````
ch1_close, ch2_close := false,false		//定义两个变量表示两个channel是否都已关闭，关闭则跳出for循环
for {	//一直监听ch1,ch2并处理相应代码逻辑
	if(ch1_close && ch2_close) {
    return
	}
  select {
    case a,ok := <- ch1:
    	if(ok){
        ....    //执行代码逻辑1
    	}else{
        ch1_close = ture
    	}
    case b,ok := <- ch2:
      if(ok){
        ....    //执行代码逻辑2
      }else{
        ch2_close = ture
      }
  }
}
````



__Timeout__

> time.After(time.Second * 10) 10秒后会返回一个类型为 ``<-chan Time``的单向channel,
>
> select在没有case和default执行是会出现阻塞，正阻塞期间可以通过设置 ``case <- time.After(time.Second * 10)``差法阻塞10秒后执行该case逻辑；

````
    c1 := make(chan string, 1)
    go func() {
        time.Sleep(time.Second * 2) //让这个ch在2秒后向ch中传递数据
        c1 <- "result 1"
    }()
    select {
    case res := <-c1:
        fmt.Println(res)
    case <-time.After(time.Second * 1): //设置超时为1秒，当代码执行到select阻塞后1秒，这触发该case
        fmt.Println("timeout 1")
    }
````

__Timer(定时器)__

> 设定延迟执行
>
> time.Sleep(time.Second * 10 ) :单纯的停止10秒
>
> timer_ch := time.NewTimer(time.Second * 1) ： 返回一个单向传递Time类型的channel，并设定10秒后准备向这个channel传递数据，注意：10秒的开始时间为这个channel创建的时间，就是这行代码开始，并且是准备传递数据，后面使用``<-time_ch.C``来接受，不写则会报time_ch未使用；

````
	timer1 := time.NewTimer(time.Second * 10)	//10秒后准备传输数据
	<-timer1.C	//钱前10秒为阻塞状态，10时接收到数据，向下执行
	log.Println(1)
````

````
	timer1 := time.NewTimer(time.Second * 5)	//5秒后准备传输数据，阻塞状态
	time.Sleep(time.Second * 10)	//停止了10秒，这个后5秒timer1已经处于阻塞状态，等待数据传递
	log.Println("start")
	<-timer1.C	//准备接受数据，立刻接收到数据，向下执行
	log.Println(1)
````

__Ticker(定时循环触发器)__

> 定时任务，每个一段时间向channel中传递时间(当前时间)，配置for、range循环接受这个channel每段时间传递的数据

````
timer_ch := time.NewTicker(time.Second * 10) //设定一个每10秒发送当前时间到传递time类型数据的channel中
go func() {
	for t := range timer_ch.C{ //循环阻塞，每10秒接收到一次，就会执行内部代码逻辑
		...	//每段时间执行的业务逻辑
  }
}()
````

__Close__

> 关闭channel

````
close(ch)
````

__Cron(定时任务)__

````
import (
	"github.com/robfig/cron"
	"log"
)
func main(){
	i := 0
	c := cron.New()
	spec := "*/5 * * * * *" // 没5秒执行
	c.AddFunc(spec, func() {
		i++
		log.Println("定时任务生效输出：", i)
	})
	c.Start()
	select {} //阻塞
}
````





