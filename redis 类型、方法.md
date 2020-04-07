# redis 类型、方法

之前使用redis，现在对所有redis方法做一个总结；

## string类型

　　形式：key=>value;

　　说明：最简单的类型；一个key对应一个value，value保存的类型是二进制安全的，string可以包含任何数据，比如图片或者序列换的对象

　　方法：

　　　　set：设置key对应的值为string类型的value；如果存在则修改，否则添加；返回ok

```
set name aaa
```

　　　　setnx：设置key对应的值为string类型的value；如果存在，失败返回0，不存在则添加，成功返回value；nx为not exists 的意思

```
setnx name aaa
```

　　　　setex：设置key对应的值为string类型的value；并指定此建对应的有效期；成功返回ok；

```
setex name 10 aaa //设置名字为aaa并且有效期有10秒
```

　　　　setrange：设置指定key的value值的子字符串；替换

```
setrange name 2 aaa //设置name从第二个下标开始替换后面的三个子字符串为aaa；返回修改后的字符串长度
```

　　　　mset：一次性设置多个key的值，成功返回ok表示所有值都设置了，失败返回0表示没有任何值被设置；

```
mset name1 aaa1 name2 aaa2 //设置name1为aaa1，name2为aaa2
```

　　　　msetnx：一次性设置多个key的值，成功返回OK表示所有值被设置了，失败返回0表示没有值被设置了；不会覆盖已经存在的key

```
msetnx name4 aaa4 name5 aaa5 //设置name4为aaa4，name5为aaa5 如果其中一个存在则返回0，不改变任何；成功返回1
```

　　　　getset：设置key的值，并且返回一个key的旧值，旧值不存在则返回空，新增一个新值；

```
getset name5 aaa5    //设置name5的值为aaa5 并返回name5的旧值，不存在则返回nil
```

　　　　getrange：获取key对应的string的子字符串；有则返回子字符串，没有则返回空字符串

```
getrange name5 0 2 //返回key为name5的字符串中下表0到2的子字符串
```

 　　　get：获取key对应的value值

```
get name5
```

　　　　mget：批量获取值

```
mget name1 name2 name3 name4 //返回name1,name2,name3,name4的值，不存在则返回nil
```

　　　　incr：对key的值进行递增操作，返回新的值

```
incr name6 //对name6的值进行递增，如果值为字符串则会报错，成功返回自增后的值
```

　　　　incrby：对key的值增加或减少指定值的操作

```
incrby name6 12    //对name6的值加12返回新值
incrby name6 -12  //对name6的值减12 返回新值
```

　　　　decr\decrby同上

　　　　append：给指定key的值追加value；返回新的字符串长度

```
append name5 bbb    //给key为name5的值追加bbb
```

　　　　strlen：返回指定key的value长度

```
strlen name5    //返回name5的value长度
```

 

## hashes类型

　　形式：key:field value field value

　　说明：string类型field和value的映射表,适合于存储对象，类似与表，ID可以连接在key后面；

　　方法：

　　　　hset：设置hash field为指定值，如果key不存在则创建，成功返回1，失败返回0

```
hset myhash field1 value1 field2 value2 //创建一个key为myhash的fied1为value1 field2为value2的hash类型数据
```

　　　　hget：获得指定key中指定属性的值

```
hget myhash field1    //获取myhash中属性field1的值
```

　　　　hsetnx：设置hash field为指定值，如果key不存在，则先创建，如果存在返回失败0

```
hsetnx myhash title aaa    //添加myhash中title的值为aaa
```

　　　　hmset：批量设置hash中的过个field

```
hmset myhash field1 value1 field2 value2 field3 value3
```

 　　　hincrby：指定hash field 加上指定值

```
hincrby myhash field value
```

　　　　hexists：判断指定hash中字段是否存在

```
hexists myhash field
```

　　　　hlen：指定hash中field的数量

```
hlen myhash
```

　　　　hdel：删除指定hash中的field

```
hdel myhash field
```

　　　　hkeys：获取指定hash中所有的field

```
hkeys myhash
```

　　　　hvals：获取指定hash中所有的value

```
hvals myhash
```

　　　　hgetall：获取指定hash中所有的field 和 value

```
hgetall myhash
```

 ## list类型

　　格式：mylist:key1=>value1 key2=>value2

　　说明：list是一个链表结构，主要功能是push、pop、获取一段范围内的所有值等等；操作中key理解为链表的名字；，链表既可以做栈也可以做队列

　　方法：

　　　　lpush：向头部添加元素；成功返回添加后的数量；可以同事添加多个元素

 

```
lpush mylist value    //向mylist头部添加 value
```

 

　　　　lpop：从头部弹出一个元素；成功返回第一个元素；失败返回nil

```
lpop mylist    //从mylist头部弹出第一个元素，并删除
```

　　　　lrange：获取list中两个下表中的所有值；

```
lrange mylist 0 -1    //返回mylist中所有的值
```

　　　　rpush：从尾部添加一个元素；可同时添加多个；返回添加后的长度

```
rpush mylist aaa bbb    //向mylist尾部最加两个元素 
```

　　　　rpop：从尾部弹出一个元素；

```
rpop mylist //从mylist尾部弹出一个值，并删除最后一个
```

　　　　linsert：向列表中间插入一个；返回添加后的长度

```
linsert mylist before "aaa" "bbb"    //在mylist中向aaa前面插入bbb
```

　　　　lset：修改指定list指定下标的元素值；成功返回OK；

```
lset mylist index value    //将mylist中下标为index的值替换为value
```

　　　　lrem：从指定list中删除和指定值相同的值；返回影响的行数

```
lrem mylist count value    //从mylist中删除count个和value中相同的值；返回影响的行数；
```

　　　　ltrim：在指定list中保留指定下标内的元素；成功返回ok

```
ltrim mylist start end    //保留mylist中从start到end下标的元素
```

　　　　rpoplpush：从第一个list尾部弹出一个元素添加到第二个元素头部

```
rpoplpush mylist1 mylist2    从第一个list尾部弹出一个添加到mylist2头部
```

 　　　lindex：返回指定list中指定下标的值；

```
lindex mylist index    //返回mylist中下标index的值
```

　　　　llen：返回list的长度

```
llen mylist    //获取mylist中元素的长度
```

## set集合

　　格式：myset:value1 value2 value2

　　说明：set是string类型的无序集合，set是通过hash table实现的，对于集合可以去并集、交集、差集，可以实现类似好友推荐的功能；

　　方法：

　　　　sadd：向指定集合中添加元素;集合中不允许有重复的值

```
sadd myset value    //向myset集合中添加value元素
```

　　　　smembers：查看指定集合中的元素

```
smembers myset    //查看myset中的元素
```

　　　　srem：删除集合中的成员

```
srem myset value    //删除集合中value成员
```

　　　　spop：从集合中随机弹出删除指定个数的元素，默认为1；返回被删除的元素

```
spop myset1 2    //随机弹出并删除两个元素
```

　　　　sdiff：返回两个集合的差集，以第一为主，就是第一个集合中有第二个集合中没有的返回，第一个集合没有第二个集合有则不返回

```
sdiff myset1 myset2    // 返回myset1和myset2中的差集；以myset1为主
```

　　　　sdiffstore：以第二个为主，与后面的集合比较取差集，存入第一个集合中，如果第一个中本来就有值，则先清空在插入

```
sdiffstore myset1 myset2 myset3    //以myset2为主将myset2和myset3的差集存入myset1中
```

　　　　sinter:返回n个集合的交集

```
sinter myset1 myset2    //返回myset1和myset2的交集
```

　　　　sinterstore：将第二个和后面的取交接，存入第一个结合中

```
sinterstore myset1 myset2 myset3    //将myset2 myset3的交集存入myset1中
```

 　　　unision：取n个集合的交集

```
unsion myset1 myset2    //取myset1和myset2的交集
```

　　　　unisionstore：将第二个和后面的集合取交集，存入第一个集合中

```
unisonstore myset1 myset2 myset3 //将myset2 myset3取交集存入myset1中
```

　　　　smove：将第一个集合中的元素移到第二个集合中,只可以移动一个s

```
smove myset1 myset2 value     //将myset1中的value移到myset2中
```

　　　　scard：返回集合中元素的个数

```
scard myset1    //获取myset1中的元素的个数
```

 　　　sismember：判断集合中是否存在该元素；存在返回true，不存在返回false；

```
sismember myset1 value    //判断myset1中是否存在value
```

　　　　srandmember：随机返回指定个数的元素；但不删除；

```
srandmember myset1 count    //随机返回myset中count个元素，但不删除
```

## sorted set 有序集合

　　格式：storeset:value store

　　说明：stored set是有序集合，无需集合的升级版；在set基础上添加了一个数序属性，该属性在添加的时候可以指定；每次在zset集合添加设置后，集合会自动按照书序排序　　

　　方法：

　　　　zadd：向有序结合中添加元素和顺序，当添加同样顺序的不同值时，相同顺序不同值会按照插入顺序排序，最先插入的在上面,当插入的元素已经存在则失败；就是排序不唯一，值已定唯一；

```
zadd myzset order value    //向myzset中添加value元素 排序是order
```

　　　　zrange：查看有序列表中的元素；可指定加上顺序；withsorces

```
orange myzset 0 -1 withscores //返回myzset集合中所有排序和元素，按照排序返回
```

　　　　zrem：删除有序集合中的指定值

```
zrem myzset value    //删除myzset中值为value的元素
```

　　　　zincrby：给制定有序集合中指定值的顺序加或减

```
zincrby myzset count value    //给myzset有虚表中值为value的顺序加count
```

 　　　zrank：返回指定有序集合中指定的值在排序中从小到大的位置，及下标；不是顺序 没有则返回nil

```
zrank myzset value    //返回myzset中value的下标
```

　　　　zrevrank：返回指定有序集合中指定的值在排序中从大到小排序的位置，及下标；

```
zrevarank myzset value     //返回myzset 从大到小排序中value的下标
```

　　　　zrevrange：返回从大到小，与zrange顺序相反

```
zrevrange myzset1 0 -1 withscroes    //返回myzset中所有元素，从大到小
```

　　　　zrangebyscores：按照排序返回指定顺序内的值

```
zrangebyscores myzset 1 10 withscores    //返回排序值在1到10包括1、10中的元素
```

　　　　zcount：返回给定排序值中的元素个数

```
zcount myzset 1 10    //返回myzset中排序在1到10 包括1、10 的元素的个数
```

　　　　zcard：返回给定有序集合中所有元素个数

```
card myzset     //返回myzset 中所有元素个个数
```

　　　　 zremrangebyrank：删除指定有序集合中指定索引区间中的元素；索引区间不是排序

```
zremrangebyrank myzset 1 4    //删除myzset中索引在1到4的元素
```

　　　　zremrangebyscore：删除指定有序集合中指定排序区间中的元素；

```
zremrangebyscore myzset 1 10    //删除myzset中排序在1到10的元素
```

 