//
//  ZBTFaceScrollView.m
//  DaGangCheng
//
//  Created by huaxo on 15-1-9.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBTFaceScrollView.h"

@implementation ZBTFaceScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    //frame (0,0,320,200)
    [self setBackgroundColor:UIColorFromRGB(0xfbfbfb)];
    CGRect frame = self.frame;
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 180)];
    
    //int faceTotalNum = 106;   //表情总数
    int horizontalNum = 7;    //横排数
    int verticalNum = 4;      //竖排数
    int onePage = horizontalNum*verticalNum-1; //一个页面多少表情
    int pageNum = 106/onePage + (106%onePage==0?0:1); //总页面数
    
    float faceBtnWidth = self.scrollView.frame.size.width/(horizontalNum*1.0);
    float faceBtnHeight = self.scrollView.frame.size.height/(verticalNum*1.0);
    //开启子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<pageNum; i++) {
            
            for (int j=0; j<onePage; j++) {
                int imgNum = i*onePage + j;
                if (imgNum==106) {
                    break;
                }
                
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                
                UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*frame.size.width + faceBtnWidth*(j%horizontalNum), faceBtnHeight*(j/horizontalNum), faceBtnWidth, faceBtnHeight)];
                
                NSString *imgStr = [NSString stringWithFormat:@"f%.3d.png",imgNum];
                [faceBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
                [faceBtn setImageEdgeInsets:UIEdgeInsetsMake(8.5, 8.5, 8.5, 8.5)];
                faceBtn.tag = imgNum;
                [faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:faceBtn];
                });
            }
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //删除按钮
                int delNum = onePage;
                UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*frame.size.width + faceBtnWidth*(delNum%horizontalNum), faceBtnHeight*(delNum/horizontalNum), faceBtnWidth, faceBtnHeight)];
                [delBtn setImage:[UIImage imageNamed:@"delete_face.png"] forState:UIControlStateNormal];
                [delBtn setImage:[UIImage imageNamed:@"delete_face_h.png"] forState:UIControlStateHighlighted];
                [delBtn setImageEdgeInsets:UIEdgeInsetsMake(8.5, 8.5, 8.5, 8.5)];
                delBtn.tag = i;
                [delBtn addTarget:self action:@selector(clickedDelBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:delBtn];
            });
        }
    });

    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width*pageNum, 0);
    self.scrollView.showsVerticalScrollIndicator  = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    //定义PageControll
    self.pageControl = [[UIPageControl alloc] init];
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x7d7d7d);
    self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xe0e0e0);
    self.pageControl.frame = CGRectMake(130, 180, 60, 20);//指定位置大小
    self.pageControl.numberOfPages = pageNum;//指定页面个数
    self.pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    [self addSubview:self.pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}


- (void)clickedFaceBtn:(UIButton *)sender {
    NSInteger imgNum = sender.tag;
    NSString *imgStr = [NSString stringWithFormat:@"f%.3ld.png",(long)imgNum];
    if ([self.delegate respondsToSelector:@selector(faceScrollView:selectedFaceName:)]) {
        [self.delegate faceScrollView:self selectedFaceName:imgStr];
    }
}

- (void)clickedDelBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(faceScrollView:selectedDeleteButton:)]) {
        [self.delegate faceScrollView:self selectedDeleteButton:sender];
    }
}

@end
