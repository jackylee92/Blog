[TOC]

>author：李俊东
>
>startDate：2020-05-13
>
>endDate：0000-00-00

## 功能介绍

> 企业转账ES订单支持字段

* usedCompanyId：业务订单(status=21)下单的公司的ID
* usedCompanyName：业务订单(status=21)下单公司的名称
* amoutCompanyIds：服务订单(status=11)金额使用的公司ID
* amountDistribution：服务订单(status=11)金额分配

````
{
    "orderId": "1115481",
    "orderSn": 2.02001081541243313783116e+23,
    "isServOrder": 11,
    "payAmount": "350000",
    "companyId": 3,
    "oilRebate": 0,
    "oilRecharge": 0,
    "oilBizScratchCard": 0, //充值油费-刮刮卡使用部分（单位：分）
    "oilDetb": 0, // 赊销油费（单位：分）
    "distributionItems": [
        {
            "companyId": 3,
            "aomunt": 50000
        },
        {
            "companyId": 4,
            "aomunt": 100000
        },
        {
            "companyId": 5,
            "aomunt": 200000
        }
    ]
}
````



## 实现方案

> 主要流程实现方案
>
> job(定时任务)、server(基础服务)、api(接口)、async(异步)、lock(锁) 使用到的功能提供的功能、实现方案

es中添加四个字段

|序号| 字段               | 类型                      | 名称               | 是否索引 |
|----| ------------------ | ------------------------- | ------------------ | -------- |
|1| usedCompany        | integer                   | 业务订单下单公司   | 是       |
|2| usedCompanyName    | text                      | 业务订单下单公司名 | 是       |
|3| amoutCompanys      | nested(companyId、amount) | 公司金额分配       | 是       |
|4| amountDistribution | test                      | 公司分配全部信息   | 否       |

1. 



### 补充

struct添加索引：

````
ALTER TABLE `elasticsync`.`struct` 
ADD INDEX `index_i_id`(`i_id`) USING BTREE;
````





## 主要函数

> 涉及到的函数封装



## 注意事项

> 开发中的注意事项