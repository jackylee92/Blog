[TOC]

>author：李俊东
>
>startDate：2020-06-022
>
>endDate：0000-00-00

## 功能介绍

> ES蚂蚁订单同步

## 实现方案

> 原同步方案
>
> 支付相关字段数据来源我方库中，司机油卡相关字段数据来源我方库中

1. elasticsync表配置蚂蚁订单索引基本信息
2. elasticsync表配置蚂蚁所有字段，并添加字段取值规则
3. 通过esSyncOrder服务对外API通过获取数据库蚂蚁索引配置信息创建索引
4. 开发mayi_es监听kafka服务，底层同步逻辑复用订单、站点同步规则。

__订单__


| 字段               | 字段类型  | 是否支持索引 | 分词方式   | 备注                             |
| ------------------ | --------- | ------------ | ---------- | -------------------------------- |
| is_serv_order      | integer   | TRUE         |            | 是否服务订单 1=是 0=不是         |
| update_time        | date      | TRUE         |            | 订单更新时间                     |
| refund_status      | integer   | TRUE         |            | 退款状态                         |
| order_id           | integer   | TRUE         |            | 订单ID                           |
| sku_list_price     | float     | TRUE         |            | 枪标价                           |
| sku_base_price     | float     | TRUE         |            | 发改委价                         |
| order_type         | integer   | TRUE         |            | 订单类型                         |
| up_order_id        | integer   | TRUE         |            | 红虫订单的正向订单ID             |
| mode_type          | integer   | TRUE         |            | 加油模式                         |
| truck_id           | integer   | TRUE         |            | 车辆ID                           |
| refund_amount      | integer   | TRUE         |            | 退款金额                         |
| payment_amount     | integer   | TRUE         |            | 实付金额                         |
| osg_id             | integer   | TRUE         |            | 油枪ID                           |
| sku_litre          | float     | TRUE         |            | 订单升量                         |
| order_src          | integer   | TRUE         |            | 订单来源                         |
| staff_id           | integer   | TRUE         |            | 服务人员ID                       |
| create_time        | date      | TRUE         |            | 创建时间                         |
| oil_amount         | float     | TRUE         |            | 有枪金额                         |
| amount             | float     | TRUE         |            | 金额                             |
| price              | float     | TRUE         |            | 价格                             |
| product_sku        | keyword   | TRUE         |            | 商品编号                         |
| oss_id             | integer   | TRUE         |            | 站点ID                           |
| osp_id             | integer   | TRUE         |            | 服务商ID                         |
| company_id         | integer   | TRUE         |            | 公司ID                           |
| employee_id        | integer   | TRUE         |            | 司机ID                           |
| order_sn           | keyword   | TRUE         |            | 订单号                           |
| mayi_truck_id      | integer   | TRUE         |            | 蚂蚁 车辆ID                      |
| mayi_company_id    | integer   | TRUE         |            | 蚂蚁 客户公司ID                  |
| mayi_employee_id   | integer   | TRUE         |            | 蚂蚁 司机ID                      |
| mayi_order_id      | integer   | TRUE         |            | 蚂蚁 订单ID                      |
| pay_status         | integer   | TRUE         |            | 支付状态                         |
| province_id        | integer   | TRUE         |            | 省ID                             |
| province_name      | text      | TRUE         | whitespace | 省名                             |
| city_id            | integer   | TRUE         |            | 站点市ID                         |
| city_name          | text      | TRUE         | standard   | 站点市名                         |
| district_id        | integer   | TRUE         |            | 站点区ID                         |
| district_name      | text      | TRUE         | standard   | 站点区名                         |
| oss_address        | text      | TRUE         | standard   | 站点地址                         |
| osp_name           | text      | TRUE         | standard   | 服务商名                         |
| oss_name           | text      | TRUE         | standard   | 站点名                           |
| oss_status         | integer   | TRUE         |            | 站点状态                         |
| location           | geo_point | TRUE         |            | 经纬度                           |
| product_name       | keyword   | TRUE         |            | 商品名                           |
| staff_name         | text      | TRUE         | standard   | 服务人员名                       |
| pay_type           | integer   | TRUE         |            | 支付类型                         |
| status             | integer   | TRUE         |            | 状态                             |
| pay_amount         | float     | TRUE         |            | 支付金额                         |
| osg_code           | text      | TRUE         | standard   | 油枪号                           |
| truck_number       | keyword   | TRUE         |            | 车牌号                           |
| pay_time           | date      | TRUE         |            | 实际支付时间                     |
| bill_price         | float     | TRUE         |            | 服务商结算价格                   |
| bill_amount        | float     | TRUE         |            | 服务商结算金额                   |
| sales_bill_payment | float     | TRUE         |            | 账单中的订单实际计算金额         |
| bill_id            | integer   | TRUE         |            | 服务商账单ID                     |
| sbo_id             | integer   | TRUE         |            | 网点账单ID                       |
| bill_rate          | float     | TRUE         |            | 服务商折扣比例                   |
| cos_id             | integer   | TRUE         |            | 网点结算设置ID                   |
| oss_ao_id          | integer   | TRUE         |            | 网点油费账户ID                   |
| bill_create_time   | date      | TRUE         |            | 服务商结算日期                   |
| retail_ao_id       | integer   | TRUE         |            | 司机油卡ID                       |
| recharge_amount    | integer   | TRUE         |            | 客户订单充值油费支付金额         |
| rebate_amount      | integer   | TRUE         |            | 客户订单返现油费支付金额         |
| retail_ao_code     | keyword   | TRUE         |            | 司机油卡编号                     |
| retail_ao_cate     | integer   | TRUE         |            | 司机油卡类型                     |
| retail_card_source | integer   | TRUE         |            | 司机油卡来源                     |
| customer_bill_id   | integer   | TRUE         |            | 客户账单ID                       |
| customer_sbo_id    | integer   | TRUE         |            | 客户对账单ID                     |
| credit_amount      | float     | TRUE         |            | 赊销油费                         |
| duty_type          | integer   | TRUE         |            | 补单原因                         |
| price_discount     | float     | TRUE         |            | 一客一价老吕价,生产环境r_id是139 |
| refund_time        | date      | TRUE         |            | 订单退款时间,生产环境r_id是2027  |
| employee_mobile    | keyword   | TRUE         |            | 司机手机号                       |
| employee_name      | text      | TRUE         | standard   | 司机姓名                         |
| company_name       | text      | TRUE         | standard   | 公司名                           |

### 补充

* 三方相关字段去除
*  拆单相关字段去除，
* 渠道相关字段去掉，
*  app_name去掉，

## 主要函数

> 涉及到的函数封装

## 注意事项

> 开发中的注意事项

## 上线步骤

1. 执行sql
2. 