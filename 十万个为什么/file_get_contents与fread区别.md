# file_get_contents与fread区别

__fread__

``fread(file,length)``

> file		：必填，指定读取的文件。  
> length	：必填，规定要读取的最大字节数。

* 返回所读取的字符串，如果出错返回 false。

__file_get_contents__

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
