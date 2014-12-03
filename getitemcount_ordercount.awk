 cat data/orders_new |awk '{a[$2]++}b[$2,$1]!=1{b[$2]++}{b[$3,$2]=1}END{for(i in a)print i,a[i],b[i]}' > data/orders_new_itemcount_ordercount

