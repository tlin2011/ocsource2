#!/bin/sh

EN_NAME=$2
CH_NAME="设计高手"
LOGO=245966
VERSION=1.0.0
APP_VER=201
PDNAMES="房产频道|婚嫁频道|亲子频道|汽车频道"
PDIDS="878|875|877|876"
SHARE_TIPS="这个应用不错，分享一下"
DOWN_URL="http:\/\/wap.huaxo.com\/d.jsp?k=ibuger_dagangcheng"
APP_KIND="ibuger_${EN_NAME}"
TJPD="{\"ret\":true,\"list\":[{\"uid\":138377,\"id\":819,\"desc\":\"话说港城，有你有我！图拍港城，有你有我！和谐港城，有你有我！焦点话题、时事评说，有你更精彩！\",\"img_id\":218084,\"user_num\":3196,\"create_time\":1388991767,\"label\":0,\"sort_id\":0,\"kind\":\"港城茶座\"}]}"

SVR_IP=203.195.186.69
SVR_PWD=xnlz@2011

#/Users/huaxo/Desktop/dagangcheng-IOS/DaGangCheng
ROOT_PATH=$1
BUILD_PATH=${ROOT_PATH}/build/Release-iphoneos
APP_FILE=${BUILD_PATH}/test.app
IPA_FILE=${BUILD_PATH}/${EN_NAME}.ipa
HTML_FILE=${BUILD_PATH}/${EN_NAME}.html
PLIST_FILE=${BUILD_PATH}/${EN_NAME}.plist

cd ${ROOT_PATH}


#1 clean  
cd ${ROOT_PATH}  

#1.1 loop

while [ 1 -eq 1 ]
do

ret=`ps aux|grep xcode|grep -v "grep"|wc -l`
if [ $ret -gt 0 ];
then
    echo "xcodebuild - thread:$ret"
    sleep 3
else
    echo "no"
    break;
fi


done;

xcodebuild clean


#2  build to app
security unlock-keychain -powllgz@2014 /Users/huaxo/Library/Keychains/login.keychain
echo "ROOT_PATH:${ROOT_PATH}"
cd ${ROOT_PATH} && xcodebuild -target DaGangCheng -configuration Distribution  -sdk iphoneos build

#echo "xcodebuild------ret:$ret"
echo "xcode build end!"
sleep 5
#3  zip to ipa
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${APP_FILE}" -o "${IPA_FILE}" 
#--sign "iPhone Distribution: Zhoubaitong Technology co., Ltd"  

#end  create xxx.html  xxx.plist
#cd ${BUILD_PATH} 
#cat template.html | sed s/EN_NAME/${EN_NAME}/g | sed s/CH_NAME/${CH_NAME}/g |sed s/VERSION/${VERSION}/g | sed s/LOGO/${LOGO}/g  > ${HTML_FILE}

#cat template.plist | sed s/EN_NAME/${EN_NAME}/g | sed s/CH_NAME/${CH_NAME}/g |sed s/VERSION/${VERSION}/g | sed s/LOGO/${LOGO}/g  > ${PLIST_FILE}

#ftp the files to server
datestr=`date +'%m-%d'`
#(
#    echo "user lauo ${SVR_PWD}"
#    echo "binary"
#    echo "prompt"
#    echo "mkdir $datestr"
#    echo "cd ${datestr}"
#    echo "mput ${EN_NAME}*"
#    echo "quit" ) | ftp -n ${SVR_IP}

