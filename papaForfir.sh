#!/bin/bash

#设置超时
export FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT=120

#计时
SECONDS=0

#假设脚本放置在与项目相同的路径下
project_path="/Users/luo_walle/Desktop/jenkins/LeftSlide"
#取当前时间字符串添加到文件结尾
now=$(date +"%Y_%m_%d_%H_%M_%S")

#指定项目的scheme名称
if [[ $1 == "production" ]]; then
scheme="LeftSlideTest-prod"
elif [[ $1 == "gray" ]]; then
scheme="LeftSlideTest-gray"
elif [[ $1 == "debug" ]]; then
scheme="LeftSlideTest-debug"
elif [[ $1 == "development" ]]; then
scheme="LeftSlideTest"
fi

#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
export_method='ad-hoc'

#指定项目地址
#workspace_path="$project_path/XNPaPaWallet.xcworkspace"
#指定输出路径
output_path="/Users/luo_walle/Desktop/jenkins/buildout"
#指定输出归档文件地址
archive_path="$output_path/${scheme}_${now}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/${scheme}_${now}.ipa"
#指定输出ipa名称
ipa_name="${scheme}_${now}.ipa"
#获取执行命令时的commit message
commit_msg="$1"

#输出设定的变量值
#echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===export method: ${export_method}==="
echo "===commit msg: $1==="
echo "**************** ${scheme} *******************"

#先清空前一次build
fastlane gym --scheme ${scheme} --clean --configuration ${configuration} --archive_path ${archive_path} --export_method ${export_method} --output_directory ${output_path} --output_name ${ipa_name}

#上传到fir
fir publish ${ipa_path} -T "c02b42079bd176dac4955777ac97171a" -c "${commit_msg}"

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="
