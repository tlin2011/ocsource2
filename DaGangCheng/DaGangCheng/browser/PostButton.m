//
//  PostButton.m
//  UIWebViewTest
//
//  Created by huaxo2 on 15/9/11.
//  Copyright (c) 2015年 opencom. All rights reserved.
//

#import "PostButton.h"

@implementation PostButton{
    CGFloat bwidth;
    CGFloat bheight;
    CGFloat imageWidth;
}


-(instancetype)initWithFrame:(CGRect)frame width:(CGFloat)width height:(CGFloat)height imageWidth:(CGFloat)btnWidth{
     bwidth=width;
     bheight=height;
     imageWidth=btnWidth;
    return  [self initWithFrame:frame];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.titleLabel.font=[UIFont systemFontOfSize:14];
    self.titleLabel.textColor=kHexRGBAlpha(0x666666,1);
    return self;
}



-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(2,2, imageWidth, imageWidth);
}


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(imageWidth+4,0, bwidth-imageWidth-4, bheight);
}


@end
