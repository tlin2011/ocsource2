//
//  ZoomImgItem.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "ZoomImgItem.h"
@implementation ZoomImgItem

- (void)dealloc {
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


- (void)_initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    imageView = [[KL_ImageZoomView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageView];
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;

    [imageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    [imageView uddateImageWithUrl:imgName];
}

//fred 旋转图片
- (void)rotationAngle:(int)angle {
    [imageView rotationAngle:angle];
}
//fred 保存图片
- (void)savePicture{
    [imageView savePicture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
