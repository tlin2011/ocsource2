//
//  WaitUploadImageView.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "WaitUploadImageView.h"
#import "ZBWaitUploadImageView.h"

@interface WaitUploadImageView ()<ZBWaitUploadImageViewDelegate>

@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) ZBWaitUploadImageView *waitView;

@end

@implementation WaitUploadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.sv = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.sv.backgroundColor = [UIColor clearColor];
    [self addSubview:self.sv];
    
    ZBWaitUploadImageView *waitView = [[ZBWaitUploadImageView alloc] initWithFrame:self.sv.bounds];
    waitView.delegate = self;
    [self.sv addSubview:waitView];
    self.waitView = waitView;
    self.imageList = self.waitView.imageList;
}

- (void)addImageOnView:(WaitUploadImage *)uploadImage {

    [self.waitView addImageOnView:uploadImage];
    
    self.sv.contentSize = self.waitView.contentSize;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitUploadImageView_ImageList_Change" object:nil userInfo:@{@"NumStr":[NSString stringWithFormat:@"%ld",(unsigned long)[self.imageList count]]}];
}

#pragma mark - ZBWaitUploadImageViewDelegate
- (void)waitUploadImageviewDidRemovedPhotoBtn {
    self.sv.contentSize = self.waitView.contentSize;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitUploadImageView_ImageList_Change" object:nil userInfo:@{@"NumStr":[NSString stringWithFormat:@"%ld",(unsigned long)[self.imageList count]]}];

}
- (void)waitUploadImageviewDidClickedAddPhotoBtn {
    if ([self.delegate respondsToSelector:@selector(waitUploadImageViewdidClickedAddPhotoBtn)]) {
        [self.delegate waitUploadImageViewdidClickedAddPhotoBtn];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
