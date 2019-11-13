# Mysql utf8几种utf8区别

###  utf8_bin

> 将字符串中的每一个字符用二进制数据存储，区分大小写(在二进制中 ,小写字母 和大写字母 不相等.即 a !=A)
>
> 验证码则一般不区分大小写,所以用这个就合理utf8_general_cs这个选项一般不用，所以使用utf8_bin区分大小写

### utf8_general_ci

> 不区分大小写，ci为case insensitive的缩写（insensitive ; 中文解释: adj. 感觉迟钝的，对…没有感觉的），即大小写不敏感
>
> 用utf8_genera_ci没有区分大小写，导致这个字段的内容区分大小写时出问题:
> 作为密码时就会出现不合理的方面;

### utf8_general_cs

> 区分大小写，cs为case sensitive的缩写（sensitive 中文解释:敏感事件;大小写敏感;注重大小写;全字拼写须符合），即大小写敏感

### utf8_unicode_ci

> 不能完全支持组合的记号。
>
> utf8_unicode_ci比较准确，utf8_general_ci速度比较快。