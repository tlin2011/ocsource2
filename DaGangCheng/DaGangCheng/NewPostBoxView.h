//
//  NewPostBoxView.h
//  DaGangCheng
//
//  Created by huaxo on 15-1-20.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBTFaceScrollView.h"
#import "ZBTFaceImage.h"
#import "AudioRecordView.h"
#import "WaitUploadAudio.h"
#import "UploadAudio.h"
#import "DrawPictureView.h"

@class NewPostBoxView;
@protocol NewPostBoxViewDelegate <NSObject>

- (void)NewPostBoxView:(NewPostBoxView *)view drawImage:(UIImage *)image;

@end

@interface NewPostBoxView : UIView <ZBTFaceScrollViewDelegate, AudioRecordDelegate, DrawPictureDelegate>
@property (nonatomic, weak) UIViewController *delegate;
@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *keyboardBtn;
@property (nonatomic, strong) UITextView *contentTV;

@property (nonatomic, strong) UILabel *audioNumLabel;
@property (nonatomic, strong) AudioRecordView *audioView;
@property (nonatomic, strong) WaitUploadAudio *waitUploadAudio;

@property (nonatomic, strong) UIButton *drawBtn;
@property (nonatomic, strong) DrawPictureView *drawView;
@property (nonatomic, weak) id<NewPostBoxViewDelegate>dataDelegate;
@end
