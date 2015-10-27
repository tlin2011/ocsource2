//
//  HotDotSlideView.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "HotDotSlideView.h"
#import "JCTopic.h"
#import "ApiUrl.h"
#import "NetRequest.h"
#import "ArchiverAndUnarchiver.h"
#import "AFNetworking.h"

@interface HotDotSlideView () <JCTopicDelegate>
@property (nonatomic, strong) JCTopic *homeScrollView;
@property (nonatomic, strong) UIPageControl *page;
@end

@implementation HotDotSlideView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews {
    //去掉 homeScrollView 下面的滚动条
    self.homeScrollView = [[JCTopic alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 210)];
    self.clipsToBounds = YES;
    [self addSubview:self.homeScrollView];
    self.backgroundColor = [UIColor orangeColor];
    [self.homeScrollView setShowsHorizontalScrollIndicator:NO];
    
    self.page = [[UIPageControl alloc] init];
    [self addSubview:self.page];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //图片本地化
    [self manyImageSetup];
    
    //网络请求
    NetRequest * request =[[NetRequest alloc]init];
    //参数
    ////ApiUrl * url =[ApiUrl new];

    NSDictionary * parameters =@{@"s_ibg_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"]};
    [request urlStr:[ApiUrl imagePost] parameters:parameters passBlock:^(NSDictionary *customDict) {
        if (![customDict[@"ret"] integerValue]) {
            return ;
        }
        //NSLog(@"%@",customDict[@"msg"] );
        //文件路径
        NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"lantern.txt"];
        
        //归档处理
        ArchiverAndUnarchiver *myArchiver =[[ArchiverAndUnarchiver alloc] init];
        [myArchiver archiverPath:filePath andData:customDict andForKey:@"lanternDict"];
        
        //图片本地化
        [self manyImageSetup];
    }];
}


//图片处理本地化
-(void)manyImageSetup
{
    //文件路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"lantern.txt"];
    //数据对象
    NSData * data =[[NSData alloc]initWithContentsOfFile:filePath];
    //反归档人
    NSKeyedUnarchiver * unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary * aDcit =[unarchiver decodeObjectForKey:@"lanternDict"];
    NSArray *pList = aDcit[@"list"];
    
    self.homeScrollView.JCdelegate = self;
    //创建数据
    NSMutableArray * tempArray = [[NSMutableArray alloc]init];
    //网络图片加载失败
    UIImage * PlaceholderImage = [UIImage imageNamed:@"频道默认图片.png"];
    for (int i=0; i<pList.count; i++) {
        NSString *title = [pList[i] objectForKey:@"subject"];
        long imageID = [(NSNumber *)[pList[i] objectForKey:@"img_id"] integerValue];
        NSString *imgUrlStr = [ApiUrl getImageUrlStrFromID:imageID w:self.homeScrollView.bounds.size.width * 2];
        NSString *urlStr = pList[i][@"url"];
        urlStr = !urlStr || [urlStr isKindOfClass:[NSNull class]] ? @"" : urlStr;
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjects:@[imgUrlStr ,title,@NO,PlaceholderImage,pList[i][@"post_id"],urlStr] forKeys:@[@"pic",@"title",@"isLoc",@"placeholderImage",@"postId",@"url"]];
        [tempArray addObject:tempDic];
    }
    if (tempArray.count>=1){
        //加入数据
        self.homeScrollView.pics = tempArray;
        //更新
        [self.homeScrollView upDate];
        
        //显示幻灯片
        self.frame = self.homeScrollView.frame;
        [self.delegateTab setTableHeaderView:self];
        
        //page dot
        NSUInteger total = [tempArray count];
        self.page.frame=CGRectMake(self.bounds.size.width - 12*(total+1), self.bounds.size.height - 27, 12*total, 20);
        self.page.numberOfPages = total;
    }
}

- (void)didClick:(id)data {
    NSDictionary *dic = data;
    Post *post = [[Post alloc] init];
    NSString *postId = [NSString stringWithFormat:@"%@", dic[@"postId"]];
    post.postId = postId;
    post.postUrl = dic[@"url"];
    if ([self.delegate respondsToSelector:@selector(hotDotSlideView:didClick:)]) {
        [self.delegate hotDotSlideView:self didClick:post];
    }
}

- (void)currentPage:(int)page total:(NSUInteger)total {

    self.page.currentPage = page;
    
    if ([self.delegate respondsToSelector:@selector(hotDotSlideView:currentPage:total:)]) {
        [self.delegate hotDotSlideView:self currentPage:page total:total];
    }
}

@end