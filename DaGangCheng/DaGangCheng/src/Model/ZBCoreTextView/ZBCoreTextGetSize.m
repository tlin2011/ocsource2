//
//  ZBCoreTextGetSize.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCoreTextGetSize.h"

@implementation ZBCoreTextGetSize

+ (NSArray *)regularMatchArrayHadHeightFromRegularMatchArray:(NSArray *)rmArray imageWHs:(NSDictionary *)imageWHs {
    
    return [self regularMatchArrayHadHeightFromRegularMatchArray:rmArray imageWHs:imageWHs font:[UIFont systemFontOfSize:17] lineSpace:6.0f width:300];
}

+ (NSArray *)regularMatchArrayHadHeightFromRegularMatchArray:(NSArray *)rmArray imageWHs:(NSDictionary *)imageWHs font:(UIFont *)font lineSpace:(CGFloat)lineSpace width:(CGFloat)width {
    
    for (ZBCoreText *coreText in rmArray) {
        CGRect rect = CGRectZero;
        rect.size = [self coreTextSizeFromCoreText:coreText imageWHs:imageWHs font:font lineSpace:lineSpace width:width];
        coreText.rect = rect;
    }
    
    return rmArray;
}

+ (CGSize)coreTextSizeFromCoreText:(ZBCoreText *)coreText imageWHs:(NSDictionary *)imageWHs font:(UIFont *)font lineSpace:(CGFloat)lineSpace width:(CGFloat)width{
    
    CGSize totalSize = CGSizeMake(width, 0);

    if (coreText.kind == ZBCoreTextKindText) {
        
        CGRect rect = [ZBRichTextView boundingRectWithSize:CGSizeMake(totalSize.width, 500+coreText.string.length*14) font:font string:coreText.string lineSpace:lineSpace];
        
        totalSize.height = (NSInteger)(rect.size.height);  //取整数，不然会有黑线
        
    } else if (coreText.kind == ZBCoreTextKindImage) {
        
        NSString *imageID = [coreText.string substringWithRange:NSMakeRange(5, coreText.string.length - 6)];
        NSString *sizeStr = [imageWHs valueForKey:imageID];
        if (sizeStr) {
            CGSize size = CGSizeFromString(sizeStr);

            NSInteger w = size.width>totalSize.width?totalSize.width:size.width;
            NSInteger h = size.height/size.width*w;
            
            h = (h>3*w)?(3*w):h;
            totalSize.height = h;
            
        } else {
            
            totalSize.height = 60;
        }
        
    } else if (coreText.kind == ZBCoreTextKindVoice) {
    
        totalSize.height = 44;

    } else if (coreText.kind == ZBCoreTextKindSuperCS) {
        
        totalSize.height = 60;
        
    }
    
    return totalSize;
}

+ (NSDictionary *)coreTextImageHWsFromServerImageWHs:(NSDictionary *)imageWHs {

    NSMutableDictionary *mDic = nil;
    
    for (NSString *key in imageWHs.allKeys) {
        
        if ([key hasPrefix:@"h"] && key.length>2) {
            
            NSString *imageID = key;
            imageID = [imageID substringFromIndex:1];
            
            NSString *wStr = [NSString stringWithFormat:@"w%@",imageID];
            
            NSInteger h = [[imageWHs valueForKey:key] integerValue];
            NSInteger w = [[imageWHs valueForKey:wStr] integerValue];
            
            CGSize size = CGSizeMake(w, h);
            
            if (!mDic) {
                mDic = [[NSMutableDictionary alloc] init];
            }
            [mDic setObject:NSStringFromCGSize(size) forKey:imageID];
            
        }
    }
    return mDic;
}

@end
