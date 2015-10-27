//
//  NaviPindao.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NaviPindao.h"

@implementation NaviPindao

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.status forKey:@"status"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
    }
    
    return self;
}

//NSCopying
- (id)copyWithZone:(NSZone *)zone {
    NaviPindao *pindao = [[self.class allocWithZone:zone] init];
    pindao.ID = self.ID;
    pindao.name = self.name;
    pindao.status = self.status;
    
    return pindao;
}

//NSMutableCopying
- (id)mutableCopyWithZone:(NSZone *)zone {
    NaviPindao *pindao = [[self.class allocWithZone:zone] init];
    pindao.ID = self.ID;
    pindao.name = self.name;
    pindao.status = self.status;
    
    return pindao;
}

//转换成需要的数组
+ (NSArray *)naviPindaoArrWithArr:(NSArray *)arr {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<[arr count]; i++) {
        NSDictionary *dic = arr[i];
        NaviPindao *pindao = [[NaviPindao alloc] init];
        pindao.ID = [NSString stringWithFormat:@"%ld",(long)[dic[@"kind_id"] integerValue]];
        pindao.name = dic[@"kind"];
        [mArr addObject:pindao];
    }
    return mArr;
}

//判断两个数组是否相等
+ (BOOL)isArr:(NSArray *)arr equalityToArr:(NSArray *)arr2 {
    for (int i=0; i<[arr count]; i++) {
        NaviPindao *pindao = arr[i];
        BOOL isExist = NO;
        for (int j=0; j<[arr2 count]; j++) {
            NaviPindao *pindao2 = arr2[j];
            if ([pindao.ID isEqualToString:pindao2.ID] && [pindao.name isEqualToString:pindao2.name]) {
                isExist = YES;
            }
        }
        if (!isExist) {
            return NO;
        }
    }
    return YES;
}

//删除数组中的naviPindao
+ (NSArray *)arr:(NSArray *)arr removeNaviPindao:(NaviPindao *)pindao {
    NSMutableArray *mArr = [arr mutableCopy];
//    for (NaviPindao *p in mArr) {
//        if ([p.ID isEqualToString:pindao.ID] && [p.name isEqualToString:pindao.name]) {
//            [mArr removeObject:p];
//            //isExist = YES;
//            break;
//        }
//    }
    BOOL isExist = YES;
    
    while (isExist) {
        isExist = NO;
        for (NaviPindao *p in mArr) {
            if ([p.ID isEqualToString:pindao.ID] && [p.name isEqualToString:pindao.name]) {
                [mArr removeObject:p];
                isExist = YES;
                break;
            }
        }
    }
    return [mArr copy];
}

//向数组中添加naviPindao
+ (NSArray *)arr:(NSArray *)arr addNaviPindao:(NaviPindao *)pindao {
    NSMutableArray *mArr = [arr mutableCopy];
    if ([mArr count]==0) {
        [mArr addObject:pindao];
    } else {
        BOOL isExist = NO;
        for (int i=0; i<[mArr count]; i++) {
            NaviPindao *p = mArr[i];
            
            if ([p.ID isEqualToString:pindao.ID] && [p.name isEqualToString:pindao.name]) {
                isExist = YES;
            }
        }
        if (!isExist) {
            [mArr addObject:pindao];
        }
    }
    return [mArr copy];
}


//第一步：删
- (void)removeNoExistNaviPindaoWithNaviPindaoArr:(NSArray *)arr{
    NSArray *arrDis = [self.class unarchiverDisplayList];
    NSMutableArray *mArrDis = [NSMutableArray arrayWithArray:arrDis];
    NSArray *arrDel = [self.class unarchiverDeleteList];
    NSMutableArray *mArrDel = [NSMutableArray arrayWithArray:arrDel];

    for (int i=0; i<[arrDis count]; i++) {
        NaviPindao *p = arrDis[i];
        BOOL isExist = NO;
        for (NaviPindao *pindao in arr) {
            if ([p.name isEqualToString:pindao.name] && [p.ID isEqualToString:pindao.ID]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            for (NaviPindao *pin in mArrDis) {
                if (!pin.ID || !pin.name || ([p.name isEqualToString:pin.name] && [p.ID isEqualToString:pin.ID])) {
                    [mArrDis removeObject:p];
                    [self.class archiveDisplayList:mArrDis];
                    break;
                }
            }
            
        }
    }
    //NSLog(@"arr %@",[self.class unarchiverDisplayList]);
    for (int i=0; i<[arrDel count]; i++) {
        NaviPindao *p = arrDel[i];
        BOOL isExist = NO;
        for (NaviPindao *pindao in arr) {
            if ([p.name isEqualToString:pindao.name] && [p.ID isEqualToString:pindao.ID]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            for (NaviPindao *pin in mArrDel) {
                if (!pin.ID || !pin.name || ([p.name isEqualToString:pin.name] && [p.ID isEqualToString:pin.ID])) {
                    [mArrDel removeObject:p];
                    [self.class archiveDeleteList:mArrDel];
                    break;
                }
            }
        }
    }
    
}


//第二步：增
- (void)addNaviPindaoWithNaviPindaoArr:(NSArray *)arr {
    NSArray *arrDis = [self.class unarchiverDisplayList];
    NSArray *arrDel = [self.class unarchiverDeleteList];
    NSMutableArray *mDisAndDel = [[NSMutableArray alloc] init];
    [mDisAndDel addObjectsFromArray:arrDis];
    [mDisAndDel addObjectsFromArray:arrDel];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
    for (int i=0; i<[arr count]; i++) {
        NaviPindao *p = arr[i];

        for (NaviPindao *pindao in mDisAndDel) {
            if (!p.ID || !p.name || ([p.name isEqualToString:pindao.name] && [p.ID isEqualToString:pindao.ID])) {
                
                for (NaviPindao *pin in mArr) {

                    if (!pin.ID || !pin.name || ([p.name isEqualToString:pin.name] && [p.ID isEqualToString:pin.ID])) {
                        [mArr removeObject:pin];
                        break;
                    }
                }
                break;
            }
        }
    }
    if ([mArr count]>0) {
        NSMutableArray *finisArr = [[NSMutableArray alloc] initWithArray:arrDis];
        [finisArr addObjectsFromArray:mArr];
        [self.class archiveDisplayList:finisArr];
    }
}

+ (void)archiveDisplayList:(NSArray *)list {
    NSString *filename = [NSString stringWithFormat:@"%@%@%@%@",@"NaviPindaoDisplyList", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [self archiveListWithNaviPindaoArr:list FileName:filename];
}

+ (void)archiveDeleteList:(NSArray *)list {
    NSString *filename = [NSString stringWithFormat:@"%@%@%@%@",@"NaviPindaoDeleteList", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [self archiveListWithNaviPindaoArr:list FileName:filename];
}
//归档
+ (void)archiveListWithNaviPindaoArr:(NSArray *)arr FileName:(NSString *)fileName {
    //文件路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
//    1.创建一个可变长度的data
    NSMutableData *md = [NSMutableData data];
//    2.创建归档对象
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc]initForWritingWithMutableData:md];
//    3.开始编码 把对象编码进去
    [arch encodeObject:arr forKey:@"NaviPindaos"];
//    4.完成编码
    [arch finishEncoding];

    [md writeToFile:filePath atomically:YES];

}



+ (NSArray *)unarchiverDisplayList{
    NSString *filename = [NSString stringWithFormat:@"%@%@%@%@",@"NaviPindaoDisplyList", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    return [self unarchiveListWithFileName:filename];
}

+ (NSArray *)unarchiverDeleteList {
    NSString *filename = [NSString stringWithFormat:@"%@%@%@%@",@"NaviPindaoDeleteList", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    return [self unarchiveListWithFileName:filename];
}

//反归档
+ (NSArray *)unarchiveListWithFileName:(NSString *)fileName {
    //文件路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    //数据对象
    NSData * data =[[NSData alloc]initWithContentsOfFile:filePath];
    
    //    1.创建反归档对象
    NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //    2.解码 把对象解出来
    NSArray *list = [unArch decodeObjectForKey:@"NaviPindaos"];
    //for (NaviPindao *pindao in list) {
        //NSLog(@"pindaoId:%@,pindaoName:%@",pindao.ID,pindao.name);
    //}
    return list;
}

@end
