//
//  ZBAppSetting.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-18.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBLocation;

@interface ZBTab : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *imgNameSelected;
@property (nonatomic, strong) NSDictionary *page;
@end

@interface ZBAd : NSObject <NSCopying>
@property (nonatomic, assign) NSString *imageID;
@property (nonatomic, copy) NSString *urlStr;
@end

@interface ZBAppSetting : NSObject
@property (nonatomic, assign, readonly) BOOL isOpenLifePindao;       //生活频道
@property (nonatomic, strong, readonly) UIColor *themeColor;         //主题色
@property (nonatomic, strong, readonly) NSArray *tabs;               //底部tab
@property (nonatomic, strong, readonly) NSArray *hotNaviList;        //热点导航
@property (nonatomic, assign, readonly) NSInteger naviCellStyle;     //导航页面布局
@property (nonatomic, assign, readonly) BOOL isOpenValidateCode;     //短信验证
@property (nonatomic, assign, getter=isOpenPindaoKind) BOOL openPindaoKind; // 是否开启频道分类
@property (nonatomic, assign, readonly) BOOL isCreatePindaoLimit;    // 是否开启创建频道
@property (nonatomic, strong, readonly) ZBAd *ad;                    //广告
@property (nonatomic, copy,   readonly) NSString *unfocusName;         //未关注名
@property (nonatomic, copy,   readonly) NSString *focusName;       //已关注名
@property (nonatomic, copy,   readonly) NSString *pindaoName;        //频道名
@property (nonatomic, strong, readonly) NSArray *languages;         //多语言
@property (nonatomic, assign, readonly) BOOL isOpenLanguages;       //是否开启多语言
@property (nonatomic, assign, readonly) BOOL isOpenAnonymity;       //是否开启多语言
@property (nonatomic, assign, readonly) BOOL isOpenPay;       //是否开启充值服务

@property (nonatomic, assign)           CGFloat latitude;            //纬度
@property (nonatomic, assign)           CGFloat longitude;           //经度
@property (nonatomic, copy)             NSString *address;           //位置
@property (nonatomic, strong)           ZBLocation *loca;

@property (nonatomic, weak) id postController;                       //临时查看话题对象引用

//硬盘型
+ (BOOL)sd_isOpenLifePindao;                                         //生活频道
+ (UIColor *)sd_themeColor;                                          //主题色
+ (NSArray *)sd_tabs;                                                //底部tab
+ (NSArray *)sd_hotNaviList;                                         //导航页面布局
+ (NSInteger)sd_naviCellStyle;                                       //导航页面布局
+ (BOOL)sd_isOpenValidateCode;                                       //短信验证
+ (BOOL)sd_isCreatePindaoLimit;                                      // 是否开启创建频道
+ (ZBAd *)sd_ad;                                                     //广告
+ (NSString *)sd_focusName;                                                //已关注名
+ (NSString *)sd_unfocusName;                                              //未关注名
+ (NSString *)sd_pindaoName;                                              //频道名
+ (NSArray *)sd_languages;                                            //多语言
+ (BOOL)sd_isOpenLanguages;                                           //是否开启多语言

+ (BOOL)isOpenAnonymity;                                       //是否开启匿名发帖

+ (BOOL)isOpenPay;



+ (ZBAppSetting *)standardSetting;
- (void)updateData;
- (void)updateRunData;  //更新不急的数据

+ (BOOL) isAppSettingFileExist;                                      //appsetting文件
+ (void)requestJson;                                                 //请求json
+ (void)requestJsonCompletion:(void (^)(BOOL finished))completion;   //请求json

- (NSString *)latitudeStr;//纬度字符串
- (NSString *)longitudeStr;//经度字符串
@end
