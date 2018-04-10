### Navicat生成数据字典

* 查询test库结构

````
select 
TABLE_SCHEMA,TABLE_NAME,COLUMN_TYPE,COLUMN_COMMENT 
from information_schema.columns 
where TABLE_SCHEMA='test'
````
* 导出数据为Excel格式

