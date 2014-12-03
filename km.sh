
RSCRIPT="/usr/local/bin/Rscript"

exec_dir="/home/qiandu/purchasePowerModel/"
data_dir="/home/qiandu/purchasePowerModel/data/"

#kmeams output path
outputPath=${exec_dir}"output/"

matrix_percentcleanFilename=${data_dir}"binaryMatrix"

#km parameter
km_cluster=${outputPath}"km.cluster"
km_center=${outputPath}"km.centers"
km_data=${outputPath}"km.data"
iter_max=40
nstart=10
k=9
${RSCRIPT} ${exec_dir}"km.R" ${matrix_percentcleanFilename} ${km_cluster} ${km_center} ${km_data} ${k} ${iter_max} ${nstart}
echo "perfect"

