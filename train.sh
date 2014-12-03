RSCRIPT="/usr/local/bin/Rscript"

exec_dir="/home/qiandu/purchasePowerModel/"
data_dir="/home/qiandu/purchasePowerModel/data/"

#input file
#订单表
orderFilename=${data_dir}"orders_new"
#商品所属类目价格
item_cidFilename=${data_dir}"item_cid_price.log"
cid2parentFilename=${data_dir}"cid2parent"

item_cid_gradeFilename=${data_dir}"item_cid_grade.data"
orderWithPivot=${data_dir}"orderWithPivot"
ordersFor4Catogery=${data_dir}"ordersFor4Catogery"
uid_pidFilename=${data_dir}"uid_pid.data"
matrix_above3Filename=${data_dir}"matrix_above3.data"
binaryMatrix=${data_dir}"binaryMatrix"

#kmeams output path
outputPath=${exec_dir}"output/"
#ssepdf
ssePDF=${outputPath}"sse.pdf"
#起始K,长度，每个K的训练次数
begin=6
length=1
count=1

#km parameter
km_cluster=${outputPath}"km.cluster"
km_center=${outputPath}"km.centers"
km_data=${outputPath}"km.data"
iter_max=20
nstart=10
k=9


#每个类目商品的分档值

${RSCRIPT}  ${exec_dir}"quantile.R" ${cid2parentFilename} ${item_cidFilename} ${item_cid_gradeFilename} 
#将商品类目高低分档值追加到每个订单上
${RSCRIPT}  ${exec_dir}"appendGradeToOrders.R" ${orderFilename} ${item_cid_gradeFilename} ${orderWithPivot}  
#保留四大类商品订单，还剩327W订单
cat ${orderWithPivot} |awk 'NR==1{print $0}NR>1{if($15==683||$15==757||$15==795||$15==777)print $0}'> ${ordersFor4Catogery}
cat ${ordersFor4Catogery}| awk 'NR > 1&&$5>400&&$5<100000{if($5>$12*0.7){print $3,2""$15}else{print $3,1""$15}}' > ${uid_pidFilename}
#转换成UC-IC矩阵，只统计购买商品数大于5的活跃用户
${RSCRIPT} ${exec_dir}"toMatrix.R" ${uid_pidFilename} ${matrix_above3Filename}
#to binary Matrix
awk -f ${exec_dir}"to_binary_matrix.awk" ${matrix_above3Filename} > ${binaryMatrix}
#kmeans 训练k=2到17,画出ESS图，寻找拐点确定K值
#${RSCRIPT} ${exec_dir}"km_plotESS.R" ${matrix_percentcleanFilename} ${outputPath} ${ssePDF} ${begin} ${length} ${count} 
${RSCRIPT} ${exec_dir}"km.R" ${binaryMatrix} ${km_cluster} ${km_center} ${km_data} ${k} ${iter_max} ${nstart}
echo "perfect"


