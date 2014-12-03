#!/usr/bin/env bash

RSCRIPT="/usr/local/bin/Rscript"
yesteday=`date -d '4 days ago' +%Y%m%d`
today=`date  +%Y%m%d`
data_dir="/home/qiandu/purchasePowerModel/data/"
exec_dir="/home/qiandu/purchasePowerModel/"


data_all=${data_dir}${yesteday}
#data_all=${data_dir}${today}
item_app_scores=${data_dir}${yesteday}".app.score"
cid_p70=${data_dir}"cid_p70_unique"
item_price_pid_cid=${data_dir}"item_price_pid_cid"
item_price_cid=${data_dir}"item_price_cid"
item_join_result=${data_dir}"item_join_result"
item_scores_cid=${data_dir}"item_scores_cid"

km6_centers=${data_dir}"km_bi9.centers"
item_scores_cid_scores=${data_dir}"item_scores_cid_scores"
#rerank10=${data_dir}"rerank10"
rerank9_30=${data_dir}"rerank9_30"
rerank20=${data_dir}"rerank20"
rerank9_20=${data_dir}"rerank9_20"
rerank30=${data_dir}"rerank30"

reduplicate=${data_dir}"duplicate.count"
cluster_no=9
#6种排序输出结果
cluster_1=${data_dir}"1_cluster_rank"
cluster_2=${data_dir}"2_cluster_rank"
cluster_3=${data_dir}"3_cluster_rank"
cluster_4=${data_dir}"4_cluster_rank"
cluster_5=${data_dir}"5_cluster_rank"
cluster_6=${data_dir}"6_cluster_rank"
cluster_7=${data_dir}"7_cluster_rank"
cluster_8=${data_dir}"8_cluster_rank"
cluster_9=${data_dir}"9_cluster_rank"

echo ${yesteday}
cat ${data_all} |awk -F'[:\t]' 'NR>1{print $2,$3,$5}' > ${item_price_cid}

cat ${item_price_cid} |awk '{print $1,$2,$4,$NF}' > ${item_price_pid_cid}

#cat data/item_grade_pid.data |awk 'NR>1{print $2,$6}' > data/cid_p70

${RSCRIPT} ${exec_dir}"rerank_orders.R"  ${item_app_scores} ${item_price_pid_cid} ${cid_p70} ${item_join_result}

cat ${item_join_result} |awk 'NR==1{print $0,"flag","pcid"}NR>1{if($5>=$7*0.7)print $0,1,"X2"$6;else print $0,0,"X1"$6}' > ${item_scores_cid}

${RSCRIPT} ${exec_dir}"addcidscore.R" ${km6_centers} ${item_scores_cid} ${item_scores_cid_scores}
#增加群组，下面这句要增加群组名c7,c8
#cat ${item_scores_cid_scores}|awk 'NR==1{print $0,"c1","c2","c3","c4","c5","c6","c7","c8","c9"}NR>1{print $0,$10*0.2+$16,$11*0.2+$16,$12*0.2+$16,$13*0.2+$16,$14*0.2+$16,$15*0.2+$16}'> ${rerank20}
#cat ${item_scores_cid_scores}|awk 'NR==1{print $0,"c1","c2","c3","c4","c5","c6","c7","c8","c9"}NR>1{print $0,$10*0.3+$16,$11*0.3+$16,$12*0.3+$16,$13*0.3+$16,$14*0.3+$16,$15*0.3+$16}'> ${rerank30}
cat ${item_scores_cid_scores}|awk 'NR==1{print $0,"c1","c2","c3","c4","c5","c6","c7","c8","c9"}NR>1{print $0,$10*0.2+$19,$11*0.2+$19,$12*0.2+$19,$13*0.2+$19,$14*0.2+$19,$15*0.2+$19,$16*0.2+$19,$17*0.2+$19,$18*0.2+$19}'> ${rerank9_20}
cat ${item_scores_cid_scores}|awk 'NR==1{print $0,"c1","c2","c3","c4","c5","c6","c7","c8","c9"}NR>1{print $0,$10*0.3+$19,$11*0.3+$19,$12*0.3+$19,$13*0.3+$19,$14*0.3+$19,$15*0.3+$19,$16*0.3+$19,$17*0.3+$19,$18*0.3+$19}'> ${rerank9_30}


${RSCRIPT} ${exec_dir}"reduplicateCount.R" ${rerank9_20} ${rerank9_30} ${cluster_no} ${reduplicate} ${cluster_1} ${cluster_2} ${cluster_3} ${cluster_4} ${cluster_5} ${cluster_6} ${cluster_7} ${cluster_8} ${cluster_9}
