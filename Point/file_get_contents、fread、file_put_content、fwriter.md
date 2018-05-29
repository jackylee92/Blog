``file_get_contents与fread区别``

``fread``

``fread(file,length)``

> file		：必填，指定读取的文件。  
> length	：必填，规定要读取的最大字节数。

* 返回所读取的字符串，如果出错返回 false。

``file_get_contents``

``file_get_contents(path,include_path,context,start,max_length)``

> path				:必需。规定要读取的文件。    
> include_path	:可选。如果也想在 include_path 中搜寻文件的话，可以将该参数设为 "1"。    
> context			:可选。规定文件句柄的环境。context 是一套可以修改流的行为的选项。若使用 null，则忽略。    
> start			:可选。规定在文件中开始读取的位置。该参数是 PHP 5.1 新加的。    
> max_length		:可选。规定读取的字节数。该参数是 PHP 5.1 新加的。    

* file_get_contents() 函数把整个文件读入一个字符串中。
* 和 file() 一样，不同的是 file_get_contents() 把文件读入一个字符串。
* file_get_contents() 函数是用于将文件的内容读入到一个字符串中的首选方法。如果操作系统支持，还会使用内存映射技术来增强性能。

__如果只是想将一个文件的内容读入到一个字符串中，请使用 file_get_contents()，它的性能比 fread() 好得多。__

---

``file_put_contents与fwrite区别``

``file_put_content``

>file_put_contents() 函数把一个字符串写入文件中。与依次调用 fopen()，fwrite() 以及 fclose() 功能一样。

``file_put_contents(file,data,mode,context)``

* file			:必需。规定要写入数据的文件。如果文件不存在，则创建一个新文件。
* data			:可选。规定要写入文件的数据。可以是字符串、数组或数据流。
* mode			:可选。规定如何打开/写入文件。可能的值：
 * FILE_USE_INCLUDE_PATH
 * FILE_APPEND
 * LOCK_EX


* context		:可选。规定文件句柄的环境。context 是一套可以修改流的行为的选项。若使用 null，则忽略。

``fwrite``

``fwrite(file,string,length)``
> fwrite() 函数写入文件（可安全用于二进制文件）。

* file		:必需。规定要写入的打开文件。
* string	:必需。规定要写入文件的字符串。
* length	:可选。规定要写入的最大字节数。

````
<?php
$file = fopen("test.txt","w");
echo fwrite($file,"Hello World. Testing!");
fclose($file);
?>
````

````
"r"	只读方式打开，将文件指针指向文件头。
"r+"	读写方式打开，将文件指针指向文件头。
"w"	写入方式打开，将文件指针指向文件头并将文件大小截为零。如果文件不存在则尝试创建之。
"w+"	读写方式打开，将文件指针指向文件头并将文件大小截为零。如果文件不存在则尝试创建之。
"a"	写入方式打开，将文件指针指向文件末尾。如果文件不存在则尝试创建之。
"a+"	读写方式打开，将文件指针指向文件末尾。如果文件不存在则尝试创建之。
"x"	
创建并以写入方式打开，将文件指针指向文件头。如果文件已存在，则 fopen() 调用失败并返回 FALSE，并生成一条 E_WARNING 级别的错误信息。如果文件不存在则尝试创建之。

这和给底层的 open(2) 系统调用指定 O_EXCL|O_CREAT 标记是等价的。

此选项被 PHP 4.3.2 以及以后的版本所支持，仅能用于本地文件。

"x+"	
创建并以读写方式打开，将文件指针指向文件头。如果文件已存在，则 fopen() 调用失败并返回 FALSE，并生成一条 E_WARNING 级别的错误信息。如果文件不存在则尝试创建之。

这和给底层的 open(2) 系统调用指定 O_EXCL|O_CREAT 标记是等价的。

此选项被 PHP 4.3.2 以及以后的版本所支持，仅能用于本地文件。
````

__性能对比__

````
<?php  
$start_time = microtime(true);  
$fp = fopen("fwrite.txt","w");  
for ($i = 1;$i <= 1000000;++$i) {  
    fwrite($fp, "{$i}\r\n");  
}  
fclose($fp);  
$end_time = microtime(true);  
echo "fwrite cost:",($end_time-$start_time),"\r\n";  
  
$start_time = microtime(true);  
for ($i = 1;$i <= 1000000;++$i) {  
file_put_contents("file_put_contents.txt","{$i}\r\n",FILE_APPEND);  
}  
$end_time = microtime(true);  
echo "file_put_contents cost:",($end_time-$start_time),"\r\n";  
````

````
fwrite cost:1.7961459159851
file_put_contents cost:20.127501010895
````
> 如果需要代开一个文件多次写入 fwrite 比 file_put_content 开很多，但如果写入的只有一次，建议使用file_put_content 节省函数变量传递；