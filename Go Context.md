# Go Context、WaitGroup

## Context

> 用来在各个goroutine中传递上下文数据、可对各个goroutine实现广播效果，可中止routine树；

``parent_ctx := context.Background()``：返回一个空的Context，这个空的Context一般用于整个Context树的根节点。

````
func Background() Context {
	return background
}
````

``ctx,cancel := context.WithCancel(parent_ctx)``：返回一个可取消的子Context和一个cancel方法

````
func WithCancel(parent Context) (ctx Context, cancel CancelFunc) {
	c := newCancelCtx(parent)
	propagateCancel(parent, &c)
	return &c, func() { c.cancel(true, Canceled) }
}
````

``ctx,WithDeadline := context.WithDeadline(context.Background(),time.Now().Add(time.Second*10))``：返回一个10秒后自动结取消的context和取消方法；

````
func WithDeadline(parent Context, d time.Time) (Context, CancelFunc) {
	if cur, ok := parent.Deadline(); ok && cur.Before(d) {
		// The current deadline is already sooner than the new one.
		return WithCancel(parent)
	}
	c := &timerCtx{
		cancelCtx: newCancelCtx(parent),
		deadline:  d,
	}
	propagateCancel(parent, c)
	dur := time.Until(d)
	if dur <= 0 {
		c.cancel(true, DeadlineExceeded) // deadline has already passed
		return c, func() { c.cancel(true, Canceled) }
	}
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.err == nil {
		c.timer = time.AfterFunc(dur, func() {
			c.cancel(true, DeadlineExceeded)
		})
	}
	return c, func() { c.cancel(true, Canceled) }
}
````

``ctx,cancel := context.WithTimeout(context.Background(),time.Second * 10)``：返回一个10秒后停止的context和取消方法，和WithDealline效果差不多

````
func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc) {
	return WithDeadline(parent, time.Now().Add(timeout))
}
````

``ctx := context.WithValue(context.Background(),"key","value")``：返回一个绑定了key对应value键值对的context

__Background、TODO__

> 他们两个本质上都是`emptyCtx`结构体类型，是一个不可取消，没有设置截止时间，没有携带任何值的Context

``Background``：主要用于main函数、初始化以及测试代码中，作为Context这个树结构的最顶层的Context，也就是根Context。

``TODO``：创建一个空 context。也只能用于高等级或当您不确定使用什么 context，或函数以后会更新以便接收一个 context 。这意味您（或维护者）计划将来要添加 context 到函数，它与 background 完全相同。不同的是，静态分析工具可以使用它来验证 context 是否正确传递，这是一个重要的细节，因为静态分析工具可以帮助在早期发现潜在的错误，并且可以连接到 CI/CD 管道。【不是很懂】

__struct Content__

> 结构体实现了一下四方法

````
type Context interface {
  Deadline() (deadline time.Time, ok bool)	//第一个返回值为设置的截止时间，如果设置了截止时间，到该时间则会自动取消context，第二个返回值为是否设置了截止时间，如果没有则需要通过取消函数进行取消；
  Done() <-chan struct{}	//返回的是一个只读的chann,返回类型为struct{},如果ctx.Done()方法可以获取数据，则说明其这个Context肯定取消了；
  Err() error	//返回取消的原因；
  Value(key interface{}) interface{}	//获取context上绑定的值
}
````

__注意⚠️__

1. 不要把Context放在结构体中，要以参数的方式传递
2. 以Context作为参数的函数方法，应该把Context作为第一个参数，放在第一位。
3. 给一个函数方法传递Context的时候，不要传递nil，如果不知道传递什么，就使用context.TODO
4. Context的Value相关方法应该传递必须的数据，不要什么数据都使用这个传递
5. Context是线程安全的，可以放心的在多个goroutine中传递



## WaitGroup

> 计数器，注意：向goroutine中传递wg时，需要使用指针传递，否则该goroutine中Done对该goroutine外的wg没有影响，会造成该goroutine外的wg死锁；

``var wg  sync.WaitGroup`` ：创建一个计数器。

``wg.Add(1)``：计数器+1。

``wg.Done()``：计数器-1，等价于``wg.Add(-1)``。

``wg.Wait()``：阻塞等待wg处理Done完后向下执行。

````
func main() {
	var wg sync.WaitGroup

	wg.Add(2)
	go func() {
		time.Sleep(2*time.Second)
		fmt.Println("1号完成")
		wg.Done()
	}()
	go func() {
		time.Sleep(2*time.Second)
		fmt.Println("2号完成")
		wg.Done()
	}()
	wg.Wait()
	fmt.Println("好了，大家都干完了，放工")
}
````



## 总结：

* waitGroup：适合多个goroutine全部完成整个任务才算完成；这种是子goroutine通过对waitGroup的操作，通知主goroutine；
* channel+select：适合横向少量goroutine通讯，不适合非常多，和嵌套非常多层的goroutine，关系链会比较复杂
* Context：...