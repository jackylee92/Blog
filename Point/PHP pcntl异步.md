# PHP异步

## pcntl

pcntl_fork()方法

fork是创建了一个子进程，父进程和子进程 都从fork的位置开始向下继续执行，不同的是父进程执行过程中，得到的fork返回值为子进程 号，而子进程得到的是0

函数创建一个子进程，这个子进程仅PID（进程号） 和PPID（父进程号）与其父进程不同。



```
pcntl_wait
```

父进程中等待一个子进程中断后继续执行

ps -ef 状态

master process

manager process

task worker process

event worker process



子进程控制



孙子进程 执行结束后自动被系统回收，解决僵尸进程



主进程解决后不会停止子进程，这样会产生僵尸进程



pstree -ap | grep php 查看进程父子关系 记住查看的父子进程pid 找找里面关系

````
    public function actionIndex()
    {
        $pid = pcntl_fork();
        Common::logInfo('DEBUG 创建子进程 Res:['.$pid.']');
        if($pid == -1){ //创建失败
            Common::logInfo('创建子进程失败');
        }else if( $pid == 0){ //子进程
            $sleep_time = 2;
            sleep($sleep_time);
            Common::logInfo('我是子进程['.$sleep_time.'] pid:['.$pid.']');

            $child_pid = pcntl_fork();
            Common::logInfo('DEBUG 创建子子进程 Res:['.$child_pid.']');
            if($child_pid == 0) {
                $sleep_time = 2;
                sleep($sleep_time);
                Common::logInfo('这个是子进程['.$sleep_time.'] pid:['.$child_pid.']');
            }else if($child_pid) {
                $sleep_time = rand(1,10);
                sleep($sleep_time);
                Common::logInfo('这个是子子进程['.$sleep_time.'] pid:['.$child_pid.']');
            }else {
                Common::logInfo('创建子子进程失败');
            }
        }else if($pid) { //父进程
            $sleep_time = rand(1,10);
            sleep($sleep_time);
            Common::logInfo('我是父进程['.$sleep_time.'] pid:['.$pid.']');
        }
    }
````



注意主进程循环 生成子成，子进程复制主进程上线文，会同样执行到for循环，会产生非常多的子进程



> 哈哈