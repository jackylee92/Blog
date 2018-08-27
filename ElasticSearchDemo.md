## ElasticSearchDemo

## 创建索引：

````
url: http://ip:端口/website
{
  "mappings": {
    "article": {
      "properties": {
        "content": {
          "type": "text",
          "analyzer": "english"
        },
        "post_data": {
          "type": "date"
        },
        "title": {
          "type": "text"
        },
        "author_id": {
          "type": "long"
        }
      }
    }
  }
}
````

## 动态建立index、mapping、field

````
url: http://ip:端口/company/employee/1
{
  "address": {
    "country": "china",
    "province": "guangdong",
    "city": "hefei"
  },
  "name": "jacky",
  "age": 27,
  "join_date": "2017-01-01"
}
````

## 动态建立index、mapping、field 带数组field类型

````
url: http://ip:端口/company2/employee2/1
{
  "address": {
    "country": "china",
    "province": "guangdong",
    "city": "hefei"
  },
  "name": "jacky",
  "age": 27,
  "join_date": "2017-01-01",
  "friend": [
    1,
    2,
    3
  ]
}
````



## 新增Field

````
url: http://ip:端口/website/_mapping/article
{
  "properties": {
    "tags": {
      "type": "text"
    }
  }
}
````

## 修改Field

> 无法修改

![1535277759731](https://github.com/jackylee92/Blog/blob/master/Images/es_demo1.png)