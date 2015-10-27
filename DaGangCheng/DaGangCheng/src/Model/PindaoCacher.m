//
//  PindaoCacher.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoCacher.h"
#import "PindaoFocusSQL.h"

NSString* const HUASHUO_PD = @"huashuo_pd";
static int isUpload = 0;
@implementation PindaoCacher


+(void)forceSaveToNetwork
{
    if (isUpload==0) {
        [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(uploadToNetwork) userInfo:nil repeats:NO];
    }
    isUpload++;
}

+ (void)uploadToNetwork {

    NetRequest * request = [NetRequest new];
    NSDictionary *dic = [[PindaoFocusSQL sharedManager] queryListByUid:[HuaxoUtil getUdidStr]];
    if (!dic || ![[HuaxoUtil getUdidStr] integerValue]) {
        return;
    }
    
    NSDictionary * parameters = @{
                                  @"uid":[HuaxoUtil getUdidStr],
                                  @"list":[dic JSONString]
                                  };
    [request urlStr:[ApiUrl uploadChannelUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {

        if([customDict[@"ret"] intValue]){
            
            NSLog(@"ver %ld", (long)[customDict[@"ver"] integerValue]);
        }
        //SQLDataBase * sql = [SQLDataBase new];
        //[sql updateValue:[NSString stringWithFormat:@"%@",customDict[@"ver"]] key:@"pdlist-ver"];
        [NotifyCenter sendLoginStatus:nil];
    }];
    isUpload = 0;
}


//从disk中加载
+(NSArray *)getPindaoList
{
    NSDictionary *dic = [[PindaoFocusSQL sharedManager] queryListByUid:[HuaxoUtil getUdidStr]];
    if (!dic) {
        return nil;
    }
    NSArray *list = dic[@"list"];
    return list;
}

//云同步
+(void) getPindaoListFromNetwork:(int)ver completed:(PindaoProcessEndBlock)sender
{
    if(![[HuaxoUtil getUdidStr] integerValue])
    {
        NSLog(@"pindao cacher getNetWorkPdList unLogined");
        return ;
    }
    ////ApiUrl * url = [ApiUrl new];
    NetRequest * request = [NetRequest new];
    SQLDataBase * sql = [SQLDataBase new];
    NSString* ibg_udid = [HuaxoUtil getUdidStr];
    
    NSDictionary * parameters =@{@"uid":ibg_udid,
                                 @"ver":[NSString stringWithFormat:@"%d",ver],};
    [request urlStr:[ApiUrl synchronizeChannelUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] intValue]) {
            NSLog(@"get pindaolist failed! ver:%d  ret-msg:%@",ver,customDict[@"msg"]);
            return ;
        }
        
        [sql updateValue:[NSString stringWithFormat:@"%@",customDict[@"ver"]] key:@"pdlist-ver"];
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        NSString *dynamic = customDict[@"list"];
        if (!dynamic || [dynamic isKindOfClass:[NSNull class]]) {
        }else {
            NSData *jsonData = [dynamic dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (dic) {
                [[PindaoFocusSQL sharedManager] insertUid:[HuaxoUtil getUdidStr] list:dic];
            }
            
        }
            
        //});
        sender(customDict);
    }];
    
}

//判断频道是否已经关注
+(BOOL) isFocused:(NSString*) kind kindID:(NSString*) kindID
{
    if(![kindID isKindOfClass:[NSString class]]){
        return NO;
    }
    
    NSDictionary *dic = [[PindaoFocusSQL sharedManager] queryListByUid:[HuaxoUtil getUdidStr]];
    if (!dic) {
        return NO;
    }
    NSArray* list = dic[@"list"];
    //NSLog(@"isFocused:%@  len:%d",list,list.count);
    for(int i=0;i<[list count];i++){
        NSString* strID = [NSString stringWithFormat:@"%@", list[i][@"id"]];
        //NSLog(@"i:%d  strID:%@  kindID:%@",i,strID,kindID);
        if([list[i][@"kind"] isEqualToString:kind] && [strID isEqualToString:kindID])
            return YES;
    }
    return NO;
}
//关注频道
+(BOOL)focusPindao:(NSString*) title kind:(NSString*)kind kindID:(NSNumber*)kindID imgID:(NSNumber*)imgID desc:(NSString*)desc
{
    NSString* idStr = [NSString stringWithFormat:@"%@",kindID];
    if([PindaoCacher isFocused:kind kindID:idStr])
        return NO;
    
    NSDictionary* dic = @{@"id":kindID,@"kind":kind,@"title":title,@"img_id":imgID,@"desc":desc};
    
    NSDictionary *json = [[PindaoFocusSQL sharedManager] queryListByUid:[HuaxoUtil getUdidStr]];
    
    NSArray *list = json[@"list"];
    NSMutableArray* mList = [NSMutableArray arrayWithArray:list];
    [mList addObject:dic];

    NSDictionary *dicNew = @{@"list":[mList copy],@"ret":@"1"};
    
    [[PindaoFocusSQL sharedManager] insertUid:[HuaxoUtil getUdidStr] list:dicNew];
    return YES;
}

//取消关注
+(BOOL)unfocusPindao:(NSString*)kind kindId:(NSString*)kindID
{
    if(![kindID isKindOfClass:[NSString class]]){
        return NO;
    }

    NSDictionary *dic = [[PindaoFocusSQL sharedManager] queryListByUid:[HuaxoUtil getUdidStr]];
    if (!dic) {
        return NO;
    }
    NSMutableArray* list = [dic[@"list"] mutableCopy];
    for(int i=0;i<[list count];i++){
        NSString* pindaoId = [NSString stringWithFormat:@"%@", list[i][@"id"]];
        if([list[i][@"kind"] isEqualToString:kind] && [pindaoId isEqualToString:kindID])
        {
            [list removeObjectAtIndex:i];
            [[PindaoFocusSQL sharedManager] insertUid:[HuaxoUtil getUdidStr] list:@{@"list":[list copy],@"ret":@"1"}];
            return YES;
        }
    }
    return NO;
}

@end
