//
//  ZBWaitUploadImageView.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-3.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBWaitUploadImageView.h"

#define ImageWidth 75
#define ImageHeight 75
#define OneLineNum 4
#define LeftGap 10
#define TopGap 0

@interface ZBWaitUploadImageView ()
@property (nonatomic, strong) UIButton *addPhoto;
@property (nonatomic, assign, readwrite) CGSize contentSize;
@end

@implementation ZBWaitUploadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    _imageList = [[NSMutableArray alloc] init];
    _addPhoto = [[UIButton alloc] init];
    [_addPhoto setImage:[UIImage imageNamed:@"添加图片_发帖.png"] forState:UIControlStateNormal];
    [_addPhoto setImage:[UIImage imageNamed:@"添加图片_发帖_h.png"] forState:UIControlStateHighlighted];
    [_addPhoto setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 15)];
    [_addPhoto addTarget:self action:@selector(clickedAddPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    WaitUploadImage *upload = [[WaitUploadImage alloc] init];
//    upload.imageBtn = _addPhoto;
//    [_imageList addObject:upload];
    
    [self reorderImageBtns];
}

- (void)addImageOnView:(WaitUploadImage *)uploadImage {

    if (self.imageList.count>=9 || uploadImage.fullImage==nil) {
        return;
    }
    
    UIButton *imgBtn = [[UIButton alloc] init];
    //    imgBtn.layer.borderWidth = 0.5;
    //    imgBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    imgBtn.layer.masksToBounds = YES;
    //imgBtn.backgroundColor = [UIColor redColor];
    [imgBtn setImage:uploadImage.smallImage forState:UIControlStateNormal];
    [imgBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 15)];
    uploadImage.imageBtn = imgBtn;
    [self.imageList addObject:uploadImage];
    
    //加载框
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 15, ImageWidth-15, ImageHeight-15);
    indicator.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
    [imgBtn addSubview:indicator];
    indicator.tag = 1;
    [indicator startAnimating];
    
    //删除按钮
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(ImageWidth-30, 0, 30, 30)];
    [delBtn setImage:[UIImage imageNamed:@"瀑布流_发帖_删除图片.png"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(clickedDelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imgBtn addSubview:delBtn];
    
    //上传照片
    __block WaitUploadImage *bUploadImage = uploadImage;
    NSLog(@"upload %@",uploadImage.fullImage);
    [UploadImage uploadWithImage:uploadImage.fullImage completed:^(NSString *imageStr, NSError *error) {
        if (imageStr) {
            bUploadImage.imageId = imageStr;
            NSLog(@"imageStr %@",imageStr);
            bUploadImage.isUploadSuccess = YES;
            //停止加载框
            for (UIView *v in bUploadImage.imageBtn.subviews) {
                if (v.tag == 1) {
                    UIActivityIndicatorView *indic = (UIActivityIndicatorView *)v;
                    [indic stopAnimating];
                }
            }
        }
    }];
    
    //重新排列
    [self reorderImageBtns];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"WaitUploadImageView_ImageList_Change" object:nil userInfo:@{@"NumStr":[NSString stringWithFormat:@"%d",[self.imageList count]]}];
}

//重新排列
- (void)reorderImageBtns {
    
    for (int i=0; i<[self.imageList count]; i++) {
        WaitUploadImage * upload = self.imageList[i];
        float xwidth = (self.frame.size.width-LeftGap*1-OneLineNum*ImageWidth)/(OneLineNum-1);
        CGRect frame = CGRectMake(LeftGap+(i%OneLineNum)*(xwidth+ImageWidth), TopGap+i/OneLineNum*(xwidth + ImageHeight), ImageWidth, ImageHeight);
        upload.imageBtn.frame = frame;
        [self addSubview:upload.imageBtn];
    }
    NSInteger i=[self.imageList count];
    float xwidth = (self.frame.size.width-LeftGap*1-OneLineNum*ImageWidth)/(OneLineNum-1);
    CGRect frame = CGRectMake(LeftGap+(i%OneLineNum)*(xwidth+ImageWidth), TopGap+i/OneLineNum*(xwidth + ImageHeight), ImageWidth, ImageHeight);
    _addPhoto.frame = frame;
    [self addSubview:_addPhoto];
    
    //面积
    self.contentSize = CGSizeMake(self.frame.size.width, frame.origin.y+frame.size.height+15);
}

- (void)clickedDelBtn:(UIButton *)sender {
    UIButton *imageBtn = (UIButton *)[sender superview];
    for (WaitUploadImage *upload in self.imageList) {
        if ([imageBtn isEqual:upload.imageBtn]) {
            [imageBtn removeFromSuperview];
            [self.imageList removeObject:upload];
            break;
        }
    }
    
    //重新排列
    [self reorderImageBtns];
    //
    if ([self.delegate respondsToSelector:@selector(waitUploadImageviewDidRemovedPhotoBtn)]) {
        [self.delegate waitUploadImageviewDidRemovedPhotoBtn];
    }
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"WaitUploadImageView_ImageList_Change" object:nil userInfo:@{@"NumStr":[NSString stringWithFormat:@"%d",[self.imageList count]]}];
}

- (void)clickedAddPhotoBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(waitUploadImageviewDidClickedAddPhotoBtn)]) {
        [self.delegate waitUploadImageviewDidClickedAddPhotoBtn];
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
