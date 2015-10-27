//
//  KL_ImagesZoomController.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookPictureVC.h"

@interface KL_ImagesZoomController : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) LookPictureVC *delegate;
- (id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size;
@property (nonatomic, retain)NSArray *imgs;

- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index;
//fred 保存图片
- (void)savePicture;
@end
