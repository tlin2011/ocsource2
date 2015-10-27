//
//  KL_ImagesZoomController.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//


#import "KL_ImagesZoomController.h"
#import "ZoomImgItem.h"
@interface KL_ImagesZoomController ()
{
    CGSize v_size;
    UITableView *m_TableView;
    UILabel *progressLabel;
    UIButton *leftRotationBtn;
    UIButton *rightRotationBtn;
}
@end

@implementation KL_ImagesZoomController

- (id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        v_size = size;
        [self _initView];
    }
    return self;
}

- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index
{
    self.imgs = imageArr;
    [m_TableView reloadData];
    if (index > 0 && index < self.imgs.count) {
        NSInteger row = MAX(index, 0);
        [m_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    progressLabel.text = [NSString stringWithFormat:@"%lu/%lu",index + 1,self.imgs.count];
}

- (void)_initView
{
    m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)
                                               style:UITableViewStylePlain];
    m_TableView.delegate = self;
    m_TableView.dataSource = self;
    m_TableView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    m_TableView.showsVerticalScrollIndicator = NO;
    m_TableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    m_TableView.pagingEnabled = YES;
    m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_TableView.backgroundView = nil;
    m_TableView.backgroundColor = [UIColor blackColor];
    [self addSubview:m_TableView];
    
//    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 20)];
//    progressLabel.backgroundColor = [UIColor clearColor];
//    progressLabel.textColor = [UIColor whiteColor];
//    progressLabel.font = [UIFont systemFontOfSize:15];
//    progressLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:progressLabel];
    
    //fred
    //新增左右旋转
    CGRect frame = self.bounds;
    
    leftRotationBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2.0-44-10, self.frame.size.height-44, 44, 44)];
    [leftRotationBtn setImage:[UIImage imageNamed:@"查看图片_leftRotation.png"] forState:UIControlStateNormal];
    [leftRotationBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [leftRotationBtn setBackgroundColor:[UIColor blackColor]];
    leftRotationBtn.alpha = 0.7;
    leftRotationBtn.layer.cornerRadius = 5;
    leftRotationBtn.layer.masksToBounds = YES;
    [leftRotationBtn addTarget:self action:@selector(leftRotationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftRotationBtn];
    
    rightRotationBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2.0+10, self.frame.size.height-44, 44, 44)];
    [rightRotationBtn setImage:[UIImage imageNamed:@"查看图片_rightRotation.png"] forState:UIControlStateNormal];
    [rightRotationBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [rightRotationBtn setBackgroundColor:[UIColor blackColor]];
    rightRotationBtn.alpha = 0.7;
    rightRotationBtn.layer.cornerRadius = 5;
    rightRotationBtn.layer.masksToBounds = YES;
    [rightRotationBtn addTarget:self action:@selector(rightRotationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightRotationBtn];

    //点击图片的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedPicture:) name:@"clickedPictureInKL_ImageZoomView" object:nil];
}

- (void)clickedPicture:(NSNotification *)noti {
    BOOL isBarHidden = self.delegate.naviView.hidden;
    if (isBarHidden) {
        self.delegate.naviView.hidden = NO;
        leftRotationBtn.hidden = NO;
        rightRotationBtn.hidden = NO;
    } else {
        self.delegate.naviView.hidden = YES;
        leftRotationBtn.hidden = YES;
        rightRotationBtn.hidden = YES;
    }
}

- (void)leftRotationBtnClicked:(UIButton *)sender {
    NSLog(@"clicked left");
    [self rotationAngle:-90];
}

- (void)rightRotationBtnClicked:(UIButton *)sender {
    NSLog(@"clicked right");
    [self rotationAngle:90];
}

//fred 旋转图片
- (void)rotationAngle:(int)angle {
    int index = m_TableView.contentOffset.y / self.bounds.size.width;
    NSLog(@"index:%d tableview offset.y:%f ,self.bounds.width:%f",index,m_TableView.contentOffset.y,self.bounds.size.width);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ZoomImgItem *cell = (ZoomImgItem *)[m_TableView cellForRowAtIndexPath:indexPath];
    
    [cell rotationAngle:angle];
}

//fred 保存图片
- (void)savePicture {
    int index = m_TableView.contentOffset.y / self.bounds.size.width;
    NSLog(@"index:%d tableview offset.y:%f ,self.bounds.width:%f",index,m_TableView.contentOffset.y,self.bounds.size.width);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ZoomImgItem *cell = (ZoomImgItem *)[m_TableView cellForRowAtIndexPath:indexPath];
    
    [cell savePicture];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imgs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idty = @"imgshowCell";
    ZoomImgItem *cell = [tableView dequeueReusableCellWithIdentifier:idty];
    if (nil == cell) {
        cell = [[ZoomImgItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idty];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    cell.size = self.bounds.size;
    NSString *imgStr = [self.imgs objectAtIndex:indexPath.row];
    cell.imgName = imgStr;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.width;
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    NSLog(@"showIndex: %d",indexPath.row);
//    
//    progressLabel.text = [NSString stringWithFormat:@"%d/%d",indexPath.row + 1,self.imgs.count];
//}
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
        self.delegate.pageLabel.text = [NSString stringWithFormat:@"%d/%d",index.row + 1,self.imgs.count];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
     self.delegate.pageLabel.text = [NSString stringWithFormat:@"%d/%d",index.row + 1,self.imgs.count];
    NSLog(@"index.row : %d",index.row);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickedPictureInKL_ImageZoomView" object:nil];
}

@end
