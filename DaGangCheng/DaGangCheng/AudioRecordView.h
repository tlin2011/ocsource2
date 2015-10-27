//
//  AudioRecordView.h
//  FastTextViewDemo
//
//  Created by 话说社区 on 14-4-4.
//  Copyright (c) 2014年 wangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioHelper.h"
@class AudioRecordView;
@protocol AudioRecordDelegate <NSObject>
@optional
-(BOOL) sendAudio:(NSString*) path  audioLen:(long) len;
-(void) audioRecordView:(AudioRecordView *)arv createdAudio:(NSString *)path audioLen:(long) len;
-(void) audioRecordViewWithCancelAudio:(AudioRecordView *)arv;
@end

@interface AudioRecordView : UIView<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
}

@property  (nonatomic, strong) UIButton *recordBtn;
@property  (nonatomic, strong) UIButton *insertBtn;
@property  (nonatomic, strong) UIButton *timeBtn;
@property  (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, assign) BOOL hiddenSendBtn;

@property (nonatomic, strong) NSMutableArray *voiceBgs;

@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (copy, nonatomic) NSString *audioFilePath;
@property (weak, nonatomic) id<AudioRecordDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval recordTime;
- (void)initRecorder;


@end
