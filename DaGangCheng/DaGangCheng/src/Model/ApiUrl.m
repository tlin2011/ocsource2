//
//  ApiUrl.m
//  DaGangCheng
//
//  Created by huaxo on 14-3-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ApiUrl.h"

@implementation ApiUrl

//用户基本地址
+(NSString *)baseUrlStr
{
    NSString *englishName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    englishName = [englishName substringFromIndex:7];
    //NSLog(@"ename:%@",englishName);
    NSString * str =[NSString stringWithFormat:@"http://v1.opencom.cn/%@",englishName];
    return str;
}

//天盾基本地址
+(NSString *)v1BaseWithAction:(NSString *)urlStr
{
    NSString *secret_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"secret_key"];

    NSString * str =[NSString stringWithFormat:@"%@?action=%@&secret_key=%@",[self baseUrlStr],urlStr,secret_key];
    return str;
}

//+(NSString *)v1UrlStr{
//    NSString *str = [NSString stringWithFormat:@"%@?action=%@&secret_key=%@",[ApiUrl baseUrlStr],]
//}

//用户登录地址
+(NSString *)loginUrlStr
{
    NSString *str = @"c/login_community";
    return str;
}

//保存用户的UDID以及设备信息
+(NSString*)getUdidInfoStr
{
    NSString * str = @"comm/get_udid_info";
    return str;
}
+(NSString*)getUdidSessionStr
{
    NSString * str = @"comm/get_udid_session";
    return str;
}
//更改信息地址
+(NSString *)changeUserInfo
{
    NSString * str = @"c/mod_user_info";
    return str;
}

//图片提交
+(NSString*)imagePost
{   
    NSString * str = @"app/app_main_img_post";
    return str;
}

//天气地址
+(NSString*)weaherUrlStr
{
    NSString * str = @"comm/get_weather_info2";
    return str;
}

//返回图片ID
+ (NSString *)getImageUrlStrFromID:(int64_t)imageID
{
    return [self getImageUrlStrFromID:imageID w:2000 h:2000];
}
+ (NSString *)getImageUrlStrFromID:(int64_t)imageID w:(NSInteger)w
{
    return [self getImageUrlStrFromID:imageID w:w h:2*w];
}
+ (NSString *)getImageUrlStrFromID:(int64_t)imageID w:(NSInteger)w h:(NSInteger)h
{
    NSString *str = [NSString stringWithFormat:@"%lld",imageID];
    str = [[NSString alloc] initWithFormat:@"%@?action=%@&secret_key=%@&id=%@&w=%ld&h=%ld",[ApiUrl baseUrlStr],@"comm/comm_img",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"secret_key"],str,(long)w,(long)h];
    return str;
}

//返回密码修改
+(NSString *)modifyPasswordUrlStr
{
    NSString * str = @"c/mod_user_pwd";
    return str;
}

//返回注册字符串
+(NSString *)registerUrlStr
{
    NSString * str = @"c/regist_auto";
    return str;
}

//返回主题字符串
+(NSString*)seeTopicUrlStr
{
    NSString * str = @"lbbs/post_info2";
    return str;
}

//顺序接口
+(NSString *)postReplysUrlStr
{
    NSString * str = @"lbbs/post_replys";
    return str;
}


//倒序接口
+(NSString *)postLastReplysUrlStr
{
    NSString * str = @"lbbs/post_last_replys";
    return str;
}


//发表新话题
+(NSString*)publishTopicUrlStr
{
    NSString * str = @"lbbs/new_post_plus";
    return str;
}


+(NSString*)delPostUrlStr
{
    NSString * str = @"lbbs/del_post";
    return str;
}

+(NSString*)editPostUrlStr
{
    NSString * str = @"lbbs/edit_post_plus";
    return str;
}

//回复
+(NSString*)replyPlusUrlStr
{
    NSString * str = @"lbbs/new_reply_plus";
    return str;
}

//子回复
+(NSString*)subReplyPlusUrlStr
{
    NSString * str = @"lbbs/post_sub_reply";
    return str;
}

//修改回复(一级评论)
+(NSString*)editReply1UrlStr
{
    NSString * str = @"lbbs/edit_reply_plus";
    return str;
}


//删除回复(一级评论)
+(NSString*)deleReply1UrlStr
{
    NSString * str = @"lbbs/del_reply";
    return str;
}

//热门频道
+(NSString*)channelUrlStr
{
    NSString *str = @"lbbs/bbs_info";
    return str;
}

//热门频道
+(NSString*)hotPindaoUrlStr
{
    NSString * str = @"lbbs/bbs_hot_kinds2";
    return str;
}

//附近频道
+(NSString*)nearPindaoUrlStr
{
    NSString * str = @"lbbs/bbs_kind_nearby2";
    return str;
}

//最新频道
+(NSString*)nowPindaoUrlStr
{
    NSString * str = @"lbbs/bbs_kinds_new2";
    return str;
}

//频道最新动态
+(NSString*)channelDynamicNewUrlStr
{
    NSString * str = @"lbbs/bbs_feeds";
    return str;
}

//频道最新动态
+(NSString*)channelHotPostUrlStr
{
    NSString * str = @"lbbs/hot_bbs_posts2";
    return str;
}


//个人主页
+(NSString*)userInfoUrlStr
{
    NSString * str = @"sns/get_user_info";
    return str;
}

+(NSString*)friendListUrlStr:(int) pos
{
    const NSArray* urls = [NSArray arrayWithObjects:@"sns/good_friends",@"sns/net_friends",@"sns/unkown_friends",@"sns/user_msgs",nil];
    return urls[pos];
}

//新帖
+(NSString*)neBbsPostUrlStr
{
    NSString * str = @"lbbs/new_bbs_posts2";
    return str;
}

//频道粉丝
+(NSString*)fansUrlStr
{
    NSString * str = @"lbbs/bbs_index_mems2";
    return str;
}

//云同步频道
+(NSString*)synchronizeChannelUrlStr
{
    NSString * str = @"pindao/user_pindaolist";
    return str;
}

//关注的话说频道
+(NSString*)AttentionChannelUrlStr
{
    NSString * str = @"pindao/user_pindaolist2";
    return str;
}

//分组频道(关注)
+(NSString*)concernChannelUrlStr
{
    NSString * str = @"comm/dgc_pindao_list";
    return str;
}

//搜索频道(关注)
+(NSString*)searchChannelUrlStr
{
    NSString * str = @"lbbs/bbs_kinds_query2";
    return str;
}

//上传关注频道 list
+(NSString*)uploadChannelUrlStr
{
    NSString * str = @"pindao/save_user_pindaolist";
    return str;
}


//最新互动
+(NSString*)neInteractionUrlStr
{
    NSString * str = @"lbbs/new_posts_action2";
    return str;
}

//频道最新互动
+(NSString*)pindaoNewInteractionUrlStr
{
    NSString * str = @"lbbs/new_bbs_posts";
    return str;
}

//频道图片话题接口
+(NSString*)pindaoImageUrlStr
{
    NSString * str = @"lbbs/bbs_img_posts";
    return str;
}

//推荐频道
+(NSString*)reconmmendPindaoUrlStr
{

    NSString * str = @"pindao/get_tj_huashuo_pd";
    return str;
}

//最新推荐频道
+(NSString*)getNewReconmmendPindaoUrlStr
{
    NSString * str = @"pindao/zbt_app_tjpd";
    return str;
}

//热门话题
+(NSString*)hotTopicsUrlStr
{
    NSString * str = @"lbbs/hot_posts2";
    return str;
}

//标签话题接口:(大港城:推荐话题、精彩活动接口)
+(NSString*)labelUrlStr
{
    NSString * str = @"lbbs/bbs_flag_posts";
    return str;
}

//活动接口
+(NSString*)hotActivityUrlStr
{
    NSString * str = @"lbbs/get_acts";
    return str;
}

//图片话题
+(NSString*)photoTopicsUrlStr
{
    NSString * str = @"lbbs/new_posts_imgs";
    return str;
}

+(NSString*)myFeedsUrlStr:(int)kind{
    const NSArray* urls = @[@"c/user_feeds_all_me_sec",@"c/user_friend_feeds_sec",@"c/user_feeds_sec"];
    return urls[kind];
}

+(NSString*)userFeedsUrlStr
{
    return @"c/user_feeds_src";
}

+(NSString*)userPostsUrlStr
{
    return @"lbbs/user_posts";
}

+(NSString*)makeFriendUrlStr
{
    return @"sns/make_friend_req";
}

+(NSString*)delFriendUrlStr
{
    return @"sns/del_friend";
}

+(NSString*) dealMakeFriendReqUrlStr
{
    return @"sns/rsp_mkf_req";
}

+(NSString*)getFriendReqsUrlStr
{
    return @"sns/get_mkf_reqs";
}

+(NSString*)nearbyUsersUrlStr
{
    return @"c/nearby_users";
}

+(NSString*)searchUsersUrlStr
{
    return @"sns/search_users";
}

+(NSString*)getMsgsUrlStr
{
    return @"sns/get_msgs";
}
+(NSString*)sendMsgUrlStr
{
    return @"sns/send_msg";
}
+(NSString*)getPindaoNewsUrlStr
{
    return @"pindao/pindao_news";
}

+(NSString*)getUserNewsUrlStr
{
    return @"comm/user_status_all";
}

+(NSString*)getLifePdsUrlStr
{
    return @"b/get_pindaos";
}

+(NSString*)getShopListUrlStr
{
    return @"b/shop_nearby";
}
+(NSString*)getShopServiceUrlStr
{
    return @"b/shop_services";
}
+(NSString*)getShopInfoUrlStr
{
    return @"b/shop_info";
}
+(NSString*)getMyCardUrlStr
{
    return @"circle/query_card";
}
+(NSString*)saveMyCardUrlStr
{
    return @"circle/save_card";
}
+(NSString*)setMyTouxiangUrl
{
    return @"sns/save_tx_imgid";
}

+(NSString*)setChannelManagerUrlStr
{
    return @"pindao/pd_manager_set";
}

+(NSString*)delChannelManagerUrlStr
{
    return @"pindao/pd_manager_del";
}

//热点的热点
+(NSString*)hotDotInHotDotUrlStr
{
    return @"lbbs/get_hots";
}

//点赞
+(NSString*)addPraiseUrlStr
{
    return @"lbbs/bbs_praise_add";
}

//帖子收藏和举报
+(NSString*)collectionAndReportPostUrlStr
{
    return @"lbbs/bbs_act_add";
}

//推荐好友
+(NSString*)recommendFriendUrlStr
{
    return @"sns/recommend_friends";
}

//已赞，已收藏，已举报
+(NSString*)checkUserPostManagerUrlStr
{
    return @"lbbs/get_user_acts";
}

//最近浏览帖子的用户列表
+(NSString*)recentlyVisitPostUrlStr
{
    return @"lbbs/post_visitors";
}

//最近浏览频道的用户列表
+(NSString*)recentlyVisitPindaoUrlStr
{
    return @"lbbs/bbs_index_visitors";
}

//创建频道
+(NSString*)createPindaoUrlStr
{
    return @"pindao/create_huashuo_pd";
}

//频道信息
+(NSString*)pindaoInfoUrlStr
{
    return @"lbbs/get_bbs_info";
}

//编辑频道
+(NSString*)editPindaoUrlStr
{
    return @"pindao/edit_huashuo_pd";
}

//帖子收藏查询
+(NSString*)myCollectionUrlStr
{
    return @"lbbs/bbs_acts";
}

//个人主页访客
+(NSString*)userInfoVisitorUrlStr
{
    return @"sns/get_visitors";
}

//查询赞了该话题的前 N 个用户
+(NSString*)praiseUserListUrlStr
{
    return @"lbbs/bbs_praise_topN";
}
//导航频道
+(NSString*)navigationPindaoUrlStr
{
    NSString * str = @"pindao/pindao_navigation";
    return str;
}
//频道置顶
+(NSString*)pindaoFlagUrlStr
{
    NSString * str = @"lbbs/bbs_tag_post";
    return str;
}

//APP配置
+ (NSString*)appSettingUrlStr
{
    NSString * str = @"app/get_app_settings";
    return str;
}

//主页个人信息
+ (NSString*)userInfoXQUrlStr
{
    NSString * str = @"sns/get_user_info_xq";
    return str;
}

//图片上传
+ (NSString*)uploadImage
{
    NSString * str = @"comm/comm_up_img";
    return str;
}

//v1图片上传
+ (NSString *)v1UploadImage
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@?action=%@&secret_key=%@",[ApiUrl baseUrlStr],@"comm/comm_up_img",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"secret_key"]];
    return str;
}

//语音上传
+ (NSString*)uploadAudio
{
    NSString * str = @"comm/up_audio";
    return str;
}

//v1语音上传
+ (NSString *)v1UploadAudio
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@?action=%@&secret_key=%@",[ApiUrl baseUrlStr],@"comm/up_audio",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"secret_key"]];
    return str;
}

+ (NSString *)getNetAudioById:(NSString *)aid
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@?action=%@&secret_key=%@&id=%@&k=amr",[ApiUrl baseUrlStr],@"sns/get_audio_k",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"secret_key"],aid];
    return str;
}

//手机验证码下发前检测是否已注册
+ (NSString *)isRegisted
{
    NSString *str = @"c/is_registed";
    return str;
}

//客户端短信发送
+ (NSString *)sendClientSms
{
    NSString *str = @"sms/send_c_sms";
    return str;
}



//客户端短信发送
+ (NSString *)sendClientSms2
{
    NSString *str = @"sms/send_c_sms2";
    return str;
}

//客户端找回密码发送验证码
+ (NSString *)sendClientSmsByFindPassword
{
    NSString *str = @"sms/send_c_sms2";
    return str;
}

//手机验证码验证改密码
+ (NSString *)smsRetrievePassword
{
    NSString *str = @"c/reback_user_pwd";
    return str;
}

//  获取频道分类信息
+ (NSString *)getPindaoKinds
{
    NSString *str = @"lbbs/class_api";
    return str;
}


/**
 *  获取分享URL 路径
 */
+(NSString *)getShareUrl{
    NSString *str = @"post_wap/share_post";
    return str;
}


/**
 *  财富系统相关
 */

+(NSString *)getCFBaseUrl{
    NSString *str = @"http://cf.opencom.cn/";
    return str;
}

+(NSString *)getCFAccountList{
    NSString *str = @"user/account_list";
    return str;
}

+(NSString *)getCFAccountInfo{
    NSString *str = @"user/account_info";
    return str;
}

+(NSString *)getCFAccountDetail{
    NSString *str = @"user/detailed";
    return str;
}


+(NSString *)getCFCurrency{
    NSString *str = @"manager/get_currency";
    return str;
}

+(NSString *)getPointExchange{
    NSString *str = @"plugIn/dedution";
    return str;
}

+(NSString *)getCFOrderRecharge{
    NSString *str = @"order/recharge";
    return str;
}


+(NSString *)getCFUnreadMsg{
    NSString *str = @"message/getAllMessageList";
    return str;
}


+(NSString *)getCFVerificationPwd{
    NSString *str = @"c/verification_pwd";
    return str;
}


+(NSString *)getCFUnReadCount{
    NSString *str = @"message/getUnReadMessageCount";
    return str;
}

+(NSString *)getCFDeleteMessage{
    NSString *str = @"message/deleteMessage";
    return str;
}




+(NSString *)getUserPm{
    NSString *str = @"c/user_pm";
    return str;
}

+(NSString *)getSetPostTop{
    NSString *str = @"lbbs/bbs_post_set_flag";
    return str;
}


+(NSString *)getCancelPostTop{
    NSString *str = @"lbbs/bbs_post_clear_flag";
    return str;
}


+(NSString *)getDeletePost{
    NSString *str = @"lbbs/del_post";
    return str;
}



+(NSString *)getProhibitTalk{
    NSString *str = @"app/app_user_shutup";
    return str;
}




+(NSString *)getProhibitTalkYesOrNo{
    NSString *str = @"app/get_app_shutup";
    return str;
}


+(NSString *)getProhibitTalkCancel{
    NSString *str = @"app/app_shutup_cancel";
    return str;
}




+(NSString *)getHotPostTop{
    NSString *str = @"lbbs/top_post_sort";
    return str;
}


@end