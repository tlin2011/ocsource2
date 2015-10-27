//
//  ZBAppSetting.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-18.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBAppSetting.h"
#import "NetRequestAll.h"
#import "ArchiverAndUnarchiver.h"
#import "YRJSONAdapter.h"


@implementation ZBTab
- (id)copyWithZone:(NSZone *)zone {
    ZBTab *tab = [[[self class] allocWithZone:zone] init];
    tab.ID = self.ID;
    tab.name = self.name;
    tab.imgName =self.imgName;
    tab.imgNameSelected = self.imgNameSelected;
    tab.page = self.page;
    
    return tab;
}
@end

@implementation ZBAd
- (id)copyWithZone:(NSZone *)zone {
    ZBAd *ad = [[[self class] allocWithZone:zone] init];
    ad.imageID = self.imageID;
    ad.urlStr = self.urlStr;
    return ad;
}
@end

@interface ZBAppSetting ()

@property (nonatomic, assign, readwrite) BOOL isOpenLifePindao;       //生活频道
@property (nonatomic, strong, readwrite) UIColor *themeColor;         //主题色
@property (nonatomic, strong, readwrite) NSArray *tabs;               //底部tab
@property (nonatomic, strong, readwrite) NSArray *hotNaviList;        //热点导航
@property (nonatomic, assign, readwrite) NSInteger naviCellStyle;     //导航页面布局
@property (nonatomic, assign, readwrite) BOOL isOpenValidateCode;      //短信验证
@property (nonatomic, assign, readwrite) BOOL isCreatePindaoLimit;    // 是否开启创建频道
@property (nonatomic, strong, readwrite) ZBAd *ad;                    // 广告信息
@property (nonatomic, copy,   readwrite) NSString *unfocusName;        //未关注名
@property (nonatomic, copy,   readwrite) NSString *focusName;          //已关注名
@property (nonatomic, copy,   readwrite) NSString *pindaoName;         //频道名
@property (nonatomic, strong, readwrite) NSArray *languages;           //多语言
@property (nonatomic, assign, readwrite) BOOL isOpenLanguages;         //是否开启多语言
@property (nonatomic, assign, readwrite) BOOL isOpenAnonymity;       //是否开启匿名发帖
@property (nonatomic, assign, readwrite) BOOL isOpenPay;       //是否开启充值服务

@property (nonatomic, strong) NSDictionary *json;
@end

@implementation ZBAppSetting

static ZBAppSetting *shareSelf = nil;
+ (ZBAppSetting *)standardSetting {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSelf = [[self alloc] init];
    });
    return shareSelf;
}

- (NSString *)address {
    if (_address==nil) {
        _address = @"";
    }
    return _address;
}

- (void)updateData {
    self.json = [self.class sd_json];
    self.isOpenLifePindao = [self.class isOpenLifePindaoWithJSON:self.json];
    self.themeColor = [self.class themeColorWithJSON:self.json];
    self.tabs = [self.class tabsWithJSON:self.json];
    self.hotNaviList = [self.class hotNaviListWithJSON:self.json];
    self.naviCellStyle = [self.class naviCellStyleWithJSON:self.json];
    self.isOpenValidateCode = [self.class isOpenValidateCodeWithJSON:self.json];
    self.isCreatePindaoLimit = [self.class isCreatePindaoLimitWithJSON:self.json];
    self.ad = [self.class adWithJSON:self.json];
    self.unfocusName = [self.class unfocusNameWithJSON:self.json];
    self.focusName = [self.class focusNameWithJSON:self.json];
    self.pindaoName = [self.class pindaoNameWithJSON:self.json];
    self.isOpenLanguages = [self.class isOpenLanguagesWithJSON:self.json];
    self.languages = [self.class languagesWithJSON:self.json];
    self.isOpenAnonymity = [self.class isOpenAnonymityWithJSON:self.json];
    
    self.isOpenPay=[self.class isOpenPay:self.json];
    
    self.json = nil;
}

- (void)updateRunData {
    self.isOpenLifePindao = [self.class sd_isOpenLifePindao];
    self.isOpenValidateCode = [self.class sd_isOpenValidateCode];
}

+ (NSDictionary *)jsonForkey:(NSString *)key JSON:(NSDictionary *)json {

    NSArray *list = json[@"list"];
    for (int i=0; i<[list count]; i++) {
        NSDictionary *dic = list[i];
        if ([dic[@"key"] isEqualToString:key]) {
            return dic;
        }
    }
    return nil;
}

+ (NSArray *)sd_tabs {
    return [self tabsWithJSON:[self sd_json]];
}

+ (NSArray *)tabsWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"tabs" JSON:json];
    
    if (dic && [dic[@"setting"] isKindOfClass:[NSString class]]) {
        NSString *tabStr = dic[@"setting"];
        NSData *jsonData = [tabStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *tabDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![tabDic isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSArray *tabArr = tabDic[@"tabs"];
        if ([tabArr isKindOfClass:[NSArray class]]) {
            NSMutableArray *mTabArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in tabArr) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ZBTab *tab = [[ZBTab alloc] init];
                    tab.ID = [dic[@"id"] integerValue];
                    tab.name = dic[@"name"];
                    tab.imgName = dic[@"img"];
                    tab.imgNameSelected = dic[@"img_s"];
                    tab.page = dic[@"page"];
                    [mTabArr addObject:tab];
                }
            }
            
            
            return [mTabArr copy];
        }
    }
    return nil;
}

+ (BOOL)sd_isOpenLifePindao {

    return [self isOpenLifePindaoWithJSON:[self sd_json]];
}

+ (BOOL)isOpenLifePindaoWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"isOpenLifePindao" JSON:json];
    
    //没有不开启，传1不开启，传0开启
    if (dic && [dic[@"setting"] integerValue]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)sd_focusName {

    return [self focusNameWithJSON:[self sd_json]];
}


+ (NSString *)focusNameWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"app_unfocus_btn_name" JSON:json];
    
    //没有不开启，传1不开启，传0开启
    if (dic && dic[@"setting"]) {
        return dic[@"setting"];
    }
    return GDLocalizedString(@"已关注");
}

+ (NSString *)sd_unfocusName {
    
    return [self unfocusNameWithJSON:[self sd_json]];
}

+ (NSString *)unfocusNameWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"app_focus_btn_name" JSON:json];
    
    //没有不开启，传1不开启，传0开启
    if (dic && dic[@"setting"]) {
        return dic[@"setting"];
    }
    return GDLocalizedString(@"关注");
}

+ (NSString *)sd_pindaoName {
    
    return [self pindaoNameWithJSON:[self sd_json]];
}

+ (NSString *)pindaoNameWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"app_pindao_name" JSON:json];
    
    //没有不开启，传1不开启，传0开启
    if (dic && dic[@"setting"]) {
        return dic[@"setting"];
    }
    return GDLocalizedString(@"频道");
}

+ (UIColor *)sd_themeColor {
    
    return [self themeColorWithJSON:[self sd_json]];
}

+ (UIColor *)themeColorWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"themecolor" JSON:json];
    
    if (dic && [dic[@"setting"] isKindOfClass:[NSString class]]) {
        NSString *str = dic[@"setting"];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *colorStr = subDic[@"color"];
        
        if (colorStr.length == 7) {
            NSString *nStr = [NSString stringWithFormat:@"0x%@",[colorStr substringFromIndex:1]];
            NSScanner *scanner = [NSScanner scannerWithString:nStr];
            unsigned temp;
            if ([scanner scanHexInt:&temp]) {
                return UIColorFromRGB(temp);
            }
        }
    }
    
    return nil;
}

+ (NSArray *)sd_hotNaviList {
    
    return [self hotNaviListWithJSON:[self sd_json]];
}

+ (NSArray *)hotNaviListWithJSON:(NSDictionary *)json {
    NSDictionary *dic = [self jsonForkey:@"navigation" JSON:json];
    if (dic && [dic[@"setting"] isKindOfClass:[NSString class]]) {
        NSString *str = dic[@"setting"];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *subArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        return subArr;
    }
    return nil;
}

+ (NSInteger)sd_naviCellStyle {
    
    return [self naviCellStyleWithJSON:[self sd_json]];
}

+ (NSInteger)naviCellStyleWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"style" JSON:json];
    
    if (dic && [dic[@"setting"] integerValue]==1) {
        return 1;
    }
    return 0;
}

+ (BOOL)sd_isOpenValidateCode {

    return [self isOpenValidateCodeWithJSON:[self sd_json]];
}

+ (BOOL)isOpenValidateCodeWithJSON:(NSDictionary *)json {
    NSDictionary *dic = [self jsonForkey:@"isOpenValidateCode" JSON:json];
    
    //没有不开启，传1不开启，传0开启
    if (dic && [dic[@"setting"] integerValue]==0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)sd_isCreatePindaoLimit {
    
    return [self isCreatePindaoLimitWithJSON:[self sd_json]];
}

+ (BOOL)isCreatePindaoLimitWithJSON:(NSDictionary *)json
{
    
    // 0代表不隐藏，1代表隐藏
    if ([json[@"app_status"] integerValue]==1) {
        return YES;
    }
    return NO;
}

+ (ZBAd *)sd_ad {

    return [self adWithJSON:[self sd_json]];
}

+ (ZBAd *)adWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"app_start_ad" JSON:json];
    
    if (dic && [dic[@"setting"] isKindOfClass:[NSString class]]) {
        NSString *str = dic[@"setting"];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *imageID = [NSString stringWithFormat:@"%ld", (long)[subDic[@"img_id"] integerValue]];
        NSString *urlStr = [NSString stringWithFormat:@"%@", subDic[@"url"]];
        ZBAd *ad = [[ZBAd alloc] init];
        ad.imageID = imageID;
        ad.urlStr = urlStr;
        return ad;
    }
    return nil;
}

+ (NSArray *)sd_languages {

    return [self languagesWithJSON:[self sd_json]];
}

+ (NSArray *)languagesWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"language" JSON:json];
    
    if (dic && [dic[@"setting"] isKindOfClass:[NSString class]]) {
        NSString *str = dic[@"setting"];
        NSArray *arr = [str componentsSeparatedByString:@"|"];
        return arr;
    }
    return nil;
}


+(BOOL)isOpenAnonymity{
      return [self isOpenAnonymityWithJSON:[self sd_json]];
}


#pragma mark 判断是否显示匿名发帖  0:表示显示，1：表示不显示
+ (BOOL)isOpenAnonymityWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"isOpenAnonymity" JSON:json];
    
    if (dic && [dic[@"setting"] integerValue]==0) {
        return NO;
    }
    return YES;
}


+(BOOL)isOpenPay{
    return [self isOpenPay:[self sd_json]];
}

+ (BOOL)isOpenPay:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"isOpenPay" JSON:json];
    
    if (dic && [dic[@"setting"] integerValue]==0) {
        return NO;
    }
    return YES;
}


+ (BOOL)sd_isOpenLanguages {
    
    return [self isOpenLanguagesWithJSON:[self sd_json]];
}



+ (BOOL)isOpenLanguagesWithJSON:(NSDictionary *)json {
    
    NSDictionary *dic = [self jsonForkey:@"language_offOn" JSON:json];
    
    if (dic && [dic[@"setting"] isKindOfClass:[NSString class]]) {
        NSString *str = dic[@"setting"];
        
        return [str integerValue];
    }
    return NO;
}

+ (NSDictionary *)sd_json {
    //app_setting
    //文件路径
    NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@",@"AppSetting", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //判断数据库文件是否存在
    if (![self isFileExist:filePath]) {
        NSString *appSettingPlite = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_setting"];
        NSData *jsonData = [appSettingPlite dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"rdic:%@",dic);

        ArchiverAndUnarchiver *myArchiver =[[ArchiverAndUnarchiver alloc] init];
        NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
        [myArchiver archiverPath:filePath andData:dic andForKey:fileName];
    };
    
    //数据对象
    NSData * data =[[NSData alloc]initWithContentsOfFile:filePath];
    //反归档人
    NSKeyedUnarchiver * unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary* dic = [unarchiver decodeObjectForKey:fileName];
    return dic;
}

+ (BOOL) isAppSettingFileExist {
    //文件路径
    NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@",@"AppSetting", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    if ([self isFileExist:filePath]) {
        return YES;
    }
    return NO;
}

+ (BOOL) isFileExist:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (void)requestJson {
    
    [self requestJsonCompletion:^(BOOL finished) {
        if (finished) {
            [[ZBAppSetting standardSetting] updateRunData];
        }
    }];
    
}

+ (void)requestJsonCompletion:(void (^)(BOOL finished))completion {
    //请求配置
    [NetRequestAll requestAppSetting:^(NSDictionary *customDict) {
        
        if ([customDict[@"ret"] integerValue]) {
            //customDict = @{@"ret":@"1",@"list":@[@{@"key":@"isOpenSheQuPindao",@"setting":@"1"},@{@"key":@"isOpenLifePindao",@"setting":@"1"}]};
            //NSLog(@"customDic %@",customDict);
            //归档
            NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@",@"AppSetting", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
            ArchiverAndUnarchiver *myArchiver =[[ArchiverAndUnarchiver alloc] init];
            NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
            [myArchiver archiverPath:filePath andData:customDict andForKey:fileName];
            
            completion(YES);
            return ;
        }
        
        completion(NO);
    }];
}

/**
 *  纬度字符串
 *
 *  @return latitude
 */
- (NSString *)latitudeStr {
    return [NSString stringWithFormat:@"%.6f",self.latitude];
}


/**
 *  经度字符串
 *
 *  @return longitude
 */
- (NSString *)longitudeStr {
    return [NSString stringWithFormat:@"%.6f",self.longitude];
}

@end
