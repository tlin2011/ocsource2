//
//  Post.m
//  ex7-cell20
//
//  Created by huaxo on 14-10-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "Post.h"
#import "TimeUtil.h"

@interface Post ()

//@property (nonatomic, )

@end

@implementation Post
+ (Post *)getPostByJson:(NSDictionary *)json {
    
    return [self.class getPostByJson:json andRemoveSmallImageWithWidth:0];
}

+ (Post *)getPostByJson:(NSDictionary *)json andRemoveSmallImageWithWidth:(CGFloat)width {
    Post *post = [[Post alloc] init];
    //NSLog(@"json:%@",json);
    if (![json[@"img_list"] isKindOfClass:[NSNull class]] && [json[@"img_list"] isKindOfClass:[NSArray class]] && ![json[@"img_wh"] isKindOfClass:[NSNull class]] && [json[@"img_wh"] isKindOfClass:[NSDictionary class]]) {
        post.imageList = json[@"img_list"];
        post.imageWHs = json[@"img_wh"];
        if (width != 0) {
            post.imageList = [post removeSmallImageWithWidth:width];
        }
    }

    post.postId = [json[@"post_id"] isKindOfClass:[NSNull class]] ? @"0" : [NSString stringWithFormat:@"%ld",(long)[json[@"post_id"] integerValue]];
    
    post.uid = [json[@"uid"] isKindOfClass:[NSNull class]] ? @"0" : [NSString stringWithFormat:@"%ld", (long)[json[@"uid"]integerValue]];
    
    //post.pindaoId = [json[@"post_id"] isKindOfClass:[NSNull class]] ? @"0" : [NSString stringWithFormat:@"%ld", (long)[json[@"post_id"] integerValue]];
    
    post.flag = ZBJsonNumber(json[@"post_flag"]);
    
    post.title = ZBJsonObject(json[@"subject"]);
    post.content = ZBJsonObject(json[@"content"]);
    
    post.pindaoName = [json[@"bbs_kind"] isKindOfClass:[NSNull class]] ? @"" : json[@"bbs_kind"];
    if (json[@"kind"] && ![json[@"kind"] isKindOfClass:[NSNull class]]) {
        post.pindaoName = json[@"kind"];
    }
    
    post.userName = ZBJsonObject(json[@"user_name"]);
    post.zan = ZBJsonNumber(json[@"praise_num"]);
    post.replyNum = ZBJsonNumber(json[@"reply_num"]);
    
    NSNumber *timeNum = [json[@"create_time"] isKindOfClass:[NSNull class]] ? @(0) : [NSNumber numberWithLong:[json[@"create_time"] integerValue]];
    NSString* timeStr = [TimeUtil getFriendlySimpleTime:timeNum];
    post.createTime = timeStr;
    
    post.preImageId = ZBJsonNumber(json[@"img_id"]);
    
    post.userImageId = ZBJsonNumber(json[@"tx_id"]);
    
    post.readNum = ZBJsonNumber(json[@"read_num"]);
    
    post.startTime = [NSString stringWithFormat:@"%@",json[@"start_time"]];
    post.endTime = [NSString stringWithFormat:@"%@",json[@"end_time"]];
    post.activtyTag = [json[@"act_time_info"] isKindOfClass:[NSNull class]] ? @"" : json[@"act_time_info"];
    
    post.postUrl = [json[@"url"] isKindOfClass:[NSNull class]] ? @"" : json[@"url"];
    
    //PostFull
    post.address = ZBJsonObject(json[@"addr"]);
    post.pindaoID = ZBJsonNumber(json[@"kind_id"]);
    post.pindaoDesc = ZBJsonObject(json[@"k_desc"]);
    post.pindaoImageID = ZBJsonNumber(json[@"k_imgid"]);
    post.topFlag=ZBJsonNumber(json[@"top_flag"]);
    return post;
}


//- (NSString *)stringWithJsonData:(id)data {
//    NSString *str = nil;
//    if (!data) {
//        str = nil;
//    }else if ([data isKindOfClass:[NSNull class]]) {
//        str = @"";
//    }else if ([data isKindOfClass:[NSString class]]) {
//        str = data;
//    }else if ([data isKindOfClass:[NSNumber class]]) {
//        str = [NSString stringWithFormat:@"%@",data];
//    }else {
//        str = @"";
//    }
//    return str;
//}

- (NSArray *)removeSmallImageWithWidth:(CGFloat)width {
    //筛选图 （去除小图）
    NSMutableArray *postImgeIds = [[NSMutableArray alloc] init];
    if (![self.imageList isKindOfClass:[NSNull class]] && [self.imageList count] >0 && ![self.imageWHs isKindOfClass:[NSNull class]] && [self.imageWHs count]>0) {
        for (int i=0; i<[self.imageList count]; i++) {
            NSString *imgID = self.imageList[i];
            CGSize size = [self getImageWidthAndHeightByImageId:imgID];
            if (size.width>width && size.height/size.width<2.0 && size.width/size.height<2.0) {
                [postImgeIds addObject:imgID];
            }
            if (postImgeIds.count >=3) {
                break;
            }
        }
    }
    return [postImgeIds copy];
}

- (CGSize)getImageWidthAndHeightByImageId:(NSString *)imageId {
    return [self.class getImageWidthAndHeightByImageId:imageId andPost:self];
}

+ (CGSize)getImageWidthAndHeightByImageId:(NSString *)imageId andPost:(Post *)post {
    CGSize imageSize = CGSizeZero;
    NSString *imageHeightStr = [@"h" stringByAppendingString:imageId];
    NSString *imageWidthStr = [@"w" stringByAppendingString:imageId];
    float runH = [[post.imageWHs objectForKey:imageHeightStr] floatValue] * 0.5;
    float runW = [[post.imageWHs objectForKey:imageWidthStr] floatValue] * 0.5;
    imageSize.width = runW;
    imageSize.height = runH;
    
    return imageSize;
}

+ (UIImage *)imageByPostFlag:(NSInteger)flag {
    UIImage *image = nil;
    if ((flag & 0x01) > 0) {
        //置顶
        image = [UIImage imageNamed:GDLocalizedString(@"顶_cell.png")];
    } else if ((flag & 0x02) > 0) {
        //精华
        image = [UIImage imageNamed:GDLocalizedString(@"精_cell.png")];
    } else if ((flag & 0x04) > 0) {
        //热门
        image = [UIImage imageNamed:GDLocalizedString(@"热_cell.png")];
    } else if ((flag & 0x08) > 0) {
        //八卦
        image = [UIImage imageNamed:GDLocalizedString(@"热_cell.png")];
    } else if ((flag & 0x10) > 0) {
        //首页推荐
        image = [UIImage imageNamed:GDLocalizedString(@"荐_cell.png")];
    } else if ((flag & 0x20) > 0) {
        //关联推荐
        image = [UIImage imageNamed:GDLocalizedString(@"荐_cell.png")];
    } else if ((flag & 0x40) > 0) {
        //禁止评论
        image = [UIImage imageNamed:@""];
    } else if ((flag & 0x80) > 0) {
        //活动
        image = [UIImage imageNamed:GDLocalizedString(@"活_cell.png")];
    } else if ((flag & 0x100) > 0) {
        //团购
        image = [UIImage imageNamed:GDLocalizedString(@"团_cell.png")];
    }
    
    return image;
}
@end
