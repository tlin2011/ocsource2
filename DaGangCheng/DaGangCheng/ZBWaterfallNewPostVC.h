//
//  ZBWaterfallNewPostVC.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-2.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBWaitUploadImageView.h"
#import "QBImagePickerController.h"
#import "ZBWaterfallNewPostBoxView.h"


@interface ZBWaterfallNewPostVC : UIViewController <ZBWaitUploadImageViewDelegate, UIActionSheetDelegate, QBImagePickerControllerDelegate, UITextViewDelegate, ZBWaterfallNewPostBoxViewDelegate>

@property (nonatomic, strong) NSString *pindaoId;

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) ZBWaitUploadImageView *waitView;
@end
