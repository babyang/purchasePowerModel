 cat data/orders_new |awk '{a[$2]+=$5}END{for(i in a){sum+=i;count++;print i,a[i]}}'|sort -r -n -k2 > uid_gmv
