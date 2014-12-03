---
title: "购买力模型文档说明"
author: "@千度"
date: "2014-12-03"
output: html_document
---

----

###一、人群聚类

####原始数据说明

```
cid2parent:类目对照表，叶子类目与其二级类目对应关系表
item_cid_price.log:商品表，全站商品以及其对应的叶子类目和商品价格
orders_new:双十一之前60天的订单数据

```
####数据规模

```
60天订单数：324W
覆盖用户：59W
活跃用户（60天购买大于等于3件商品）：44W
商品数：30W
类目数ItemClass：女装下四个二级类目，每个类目划分为高低两档，共8个类目

```

####数据预处理


    1. 根据商品表item_cid_price.log中同一类目下所有商品的价格分布，将前30%的商品定为高价商品，找出同一类目下高低档价位分档价格p70，得到item_cid_grade.data表（quantile.R）
    2. 根据item_cid_grade.data表将每个（叶子）类目高低档商品分档值p70 追加到orders_new表,得到orderWithPivot表（appendGradeToOrders.R）
    3. 消除其他销量小的类目误差影响，保留女装下四个二级类目，得到ordersFor4Catogery表
    4. 对于新的订单表ordersFor4Catogery中所有商品，去掉商品价格低于4元或者高于1000元的异常点，并根据商品所属类目的分档值pivot（p70*70%）与其实际成交价格对比将其归档,得到用户对应商品类目表（8个二级类目）uid_pid.data
    5. 根据用户商品类目表，将其转化为矩阵形式，每行记录为一个用户所购买的商品类目记录，只保留购买大于等于3次的活跃用户,得到UC-IC矩阵表matrix_above3.data。（toMatrix.R）
    6. 对UC-IC矩阵进行二值化处理，将其转化为0、1离散值，规则是：四个类目下的每个类目，每个用户只会属于高或低档其中一类，并置为1，另一个置为0；同一类目下属于高档类的条件是：其所购买的该类商品中，大于等于30%的商品属于高档商品，则该用户在该类目下属于高档类人群，将其置为1，该类目下低档类置为0，得到binaryMatrix表。（to_binary_matrix.awk）




####kmeans聚类

    根据上面处理得到的binaryMatrix，用kmeans将人群分为9类，中心点分布图如下，红色是高档商品类目，蓝色是低档商品类目
```{r,echo=FALSE}
setwd("d:/mogujie")
c9<-read.table("km.centers",header=T,sep=" ",as.is = T)

barplot(t(c9),beside=T, col = c("lightblue","lightblue","lightblue","lightblue", "mistyrose","mistyrose","mistyrose","mistyrose"))
```
  
  9类人群数 38674, 52252, 63156, 54381, 28611, 39813, 69836, 18633, 79803



----
###二、ltr排序结果+购买力模型重排

####原始数据说明

```
20141202 :ltr每天排序的商品
20141202.app.score :ltr产出的商品排序分数
cid_p70_unique ：叶子类目高低档分档值p70
km_bi9.centers ：9类人群的中心点
    
```

####重排处理逻辑

    1. 根据20141202文件导出商品对应叶子类目和二级父类目，得到商品类目表item_price_pid_cid
    2. 将商品类目表item_price_pid_cid和类目分档值表cid_p70_unique添加到ltr产出的排序分数20141202.app.score中，得到item_join_result表。（rerank_orders.R）
    3. 根据item_join_result表中，商品成交价格和分档值pivot，标注商品所属ItemClass，得到item_scores_cid
    4. 根据商品所属类目添加该类目在9类人群中的得分（9类人群中心点centers的坐标），并将原ltr分数按最大最小归一化，得到带有购买力模型分数的商品表item_scores_cid_scores。（addcidscore.R）
    5. 商品购买力模型分数*0.2+归一化后的原ltr分数=商品新的分数
    6. 根据9类人群下9中商品9中不同的分数重新排序，得到每类人群下的一个新商品排序，并统计与老ltr排序的重合度。（reduplicateCount.R）

**重合度比较**

count_p20_10表示购买力模型分数权重系数为0.2时，取前10个商品的重合度
```
"count_p20_10" "count_p20_30" "count_p20_50" "count_p20_100" "count_p20_500" "count_p20_1000" "count_p30_10" "count_p30_30" "count_p30_50" "count_p30_100" "count_p30_500" "count_p30_1000"
"1" 6 12 18 36 169 379 4 9 16 32 150 319
"2" 6 20 33 70 336 629 6 19 32 66 331 617
"3" 8 23 40 86 428 818 8 23 40 84 424 814
"4" 7 8 15 25 126 310 2 4 9 14 63 147
"5" 6 18 31 69 336 633 6 17 30 64 329 625
"6" 6 17 31 67 324 602 6 17 30 64 317 591
"7" 8 23 40 84 417 786 8 23 40 84 412 782
"8" 7 14 24 48 224 490 5 8 14 28 120 292
"9" 6 14 22 43 187 431 4 10 15 23 100 239

``` 
