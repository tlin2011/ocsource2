//
//  ApiUrl.h
//  DaGangCheng
//
//  Created by huaxo on 14-3-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ApiUrl : NSObject
+(NSString*)baseUrlStr;
//天盾基本地址
+(NSString *)v1BaseWithAction:(NSString *)urlStr;
+(NSString*)loginUrlStr;

+(NSString*)getUdidInfoStr;

+(NSString*)getUdidSessionStr;

+(NSString *)changeUserInfo;

+(NSString*)imagePost;

+(NSString*)weaherUrlStr;

+(NSString *)getImageUrlStrFromID:(int64_t)imageID;
+(NSString *)getImageUrlStrFromID:(int64_t)imageID w:(NSInteger)w;
+(NSString *)getImageUrlStrFromID:(int64_t)imageID w:(NSInteger)w h:(NSInteger)h;

+(NSString*)modifyPasswordUrlStr;

+(NSString*)registerUrlStr;

+(NSString*)seeTopicUrlStr;

+(NSString*)postReplysUrlStr;

+(NSString*)postLastReplysUrlStr;

+(NSString*)delPostUrlStr;

+(NSString*)editPostUrlStr;

+(NSString*)publishTopicUrlStr;

+(NSString*)replyPlusUrlStr;

+(NSString*)subReplyPlusUrlStr;

+(NSString*)editReply1UrlStr;

+(NSString*)deleReply1UrlStr;

+(NSString*)channelUrlStr;

+(NSString*)channelDynamicNewUrlStr;

+(NSString*)channelHotPostUrlStr;

+(NSString*)userInfoUrlStr;

+(NSString*)userFeedsUrlStr;

+(NSString*)userPostsUrlStr;

+(NSString*)makeFriendUrlStr;

+(NSString*)delFriendUrlStr;

+(NSString*)getFriendReqsUrlStr;

+(NSString*)friendListUrlStr:(int) pos;

+(NSString*) dealMakeFriendReqUrlStr;

+(NSString*)neBbsPostUrlStr;

+(NSString*)fansUrlStr;

+(NSString*)synchronizeChannelUrlStr;

+(NSString*)concernChannelUrlStr;

+(NSString*)searchChannelUrlStr;

+(NSString*)uploadChannelUrlStr;

+(NSString*)neInteractionUrlStr;
//频道最新互动
+(NSString*)pindaoNewInteractionUrlStr;
//频道图片话题接口
+(NSString*)pindaoImageUrlStr;
+(NSString*)hotTopicsUrlStr;

+(NSString*)hotPindaoUrlStr;//热门频道
+(NSString*)nearPindaoUrlStr;//附近频道
+(NSString*)nowPindaoUrlStr;//最新频道
//推荐频道
+(NSString*)reconmmendPindaoUrlStr;
//最新推荐频道
+(NSString*)getNewReconmmendPindaoUrlStr;
//关注的话说频道
+(NSString*)AttentionChannelUrlStr;
+(NSString*)labelUrlStr;
//活动接口
+(NSString*)hotActivityUrlStr;
//图片话题
+(NSString*)photoTopicsUrlStr;

+(NSString*)myFeedsUrlStr:(int)kind;//0--@我动态  1--朋友动态  2--关注动态
+(NSString*)nearbyUsersUrlStr;

+(NSString*)searchUsersUrlStr;

+(NSString*)getMsgsUrlStr;

+(NSString*)sendMsgUrlStr;

+(NSString*)getPindaoNewsUrlStr;

+(NSString*)getUserNewsUrlStr;
//--------生活服务版块
+(NSString*)getLifePdsUrlStr;

+(NSString*)getShopListUrlStr;

+(NSString*)getShopServiceUrlStr;

+(NSString*)getShopInfoUrlStr;


+(NSString*)getMyCardUrlStr;

+(NSString*)saveMyCardUrlStr;

+(NSString*)setMyTouxiangUrl;

+(NSString*)setChannelManagerUrlStr;

+(NSString*)delChannelManagerUrlStr;

//热点的热点推荐
+(NSString*)hotDotInHotDotUrlStr;
//点赞
+(NSString*)addPraiseUrlStr;

//帖子收藏和举报
+(NSString*)collectionAndReportPostUrlStr;
//推荐好友
+(NSString*)recommendFriendUrlStr;
//已赞，已收藏，已举报
+(NSString*)checkUserPostManagerUrlStr;
//最近浏览帖子的用户列表
+(NSString*)recentlyVisitPostUrlStr;
//最近浏览频道的用户列表
+(NSString*)recentlyVisitPindaoUrlStr;
//创建频道
+(NSString*)createPindaoUrlStr;
//频道信息
+(NSString*)pindaoInfoUrlStr;
//编辑频道
+(NSString*)editPindaoUrlStr;
//帖子收藏查询
+(NSString*)myCollectionUrlStr;
//个人主页访客
+(NSString*)userInfoVisitorUrlStr;
//查询赞了该话题的前 N 个用户
+(NSString*)praiseUserListUrlStr;
//导航频道
+(NSString*)navigationPindaoUrlStr;
//频道置顶
+(NSString*)pindaoFlagUrlStr;
//APP配置
+ (NSString*)appSettingUrlStr;
//主页个人信息XQ
+ (NSString*)userInfoXQUrlStr;
//图片上传
+ (NSString*)uploadImage;

//语音上传
+ (NSString*)uploadAudio;

+ (NSString *)getNetAudioById:(NSString *)aid;

//v1图片上传
+ (NSString *)v1UploadImage;

//v1语音上传
+ (NSString *)v1UploadAudio;

//手机验证码下发前检测是否已注册
+ (NSString *)isRegisted;

//客户端短信发送
+ (NSString *)sendClientSms;



+ (NSString *)sendClientSms2;

//客户端找回密码发送验证码
+ (NSString *)sendClientSmsByFindPassword;

//手机验证码验证改密码
+ (NSString *)smsRetrievePassword;

/**
 *  获取频道分类信息
 */
+ (NSString *)getPindaoKinds;

/**
 *  获取分享URL 路径
 */
+(NSString *)getShareUrl;


/**
 *  财富系统相关
 */
+(NSString *)getCFBaseUrl;

+(NSString *)getCFAccountList;

+(NSString *)getCFAccountInfo;

+(NSString *)getCFAccountDetail;


+(NSString *)getCFCurrency;


+(NSString *)getPointExchange;

+(NSString *)getCFOrderRecharge;


+(NSString *)getCFUnreadMsg;


+(NSString *)getCFVerificationPwd;

+(NSString *)getCFUnReadCount;

+(NSString *)getCFDeleteMessage;


+(NSString *)getUserPm;


+(NSString *)getSetPostTop;


+(NSString *)getCancelPostTop;

+(NSString *)getDeletePost;

+(NSString *)getProhibitTalk;

+(NSString *)getProhibitTalkYesOrNo;

+(NSString *)getProhibitTalkCancel;

+(NSString *)getHotPostTop;

@end