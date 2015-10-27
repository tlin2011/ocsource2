//
//  ZBAudioPlayView.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBAudioPlayView.h"

@interface ZBAudioPlayView ()

@property (weak, nonatomic) UIButton *playBtn;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UIProgressView *progressView;

@end

@implementation ZBAudioPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {

        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    
    //播放按钮
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [playBtn setImage:[[UIImage imageNamed:@"playButton.png"] imageWithMobanThemeColor] forState:UIControlStateNormal];
    [playBtn setImage:[[UIImage imageNamed:@"playButton_selected.png"] imageWithMobanThemeColor] forState:UIControlStateHighlighted];
    [playBtn setImage:[[UIImage imageNamed:@"puaseButton.png"] imageWithMobanThemeColor] forState:UIControlStateSelected];
    playBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:playBtn];
    self.playBtn = playBtn;
    
    //时间显示
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 60, 44)];
    timeLabel.textColor = UIColorFromRGB(0x464a50);
    timeLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //播放进度
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-8, self.frame.size.width, 2)];
    progressView.progressTintColor = UIColorWithMobanTheme;
    progressView.trackTintColor = [UIColor lightGrayColor];
    
    [self addSubview:progressView];
    self.progressView = progressView;
    
    //播放进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playProgress:) name:@"AudioPlayer-PlayProcess" object:nil];
}

- (void)setAudioLen:(NSInteger)audioLen {
    _audioLen = audioLen;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld”",(long)(audioLen/1000.0)];
}

- (void)playBtnClicked:(UIButton *)sender {
    
    if (!self.playBtn.selected) {
        
        self.progressView.progress = 0;
        
        //未播放
        [[ZBAudioPlayerManger sharedZBAudioPlayerManger] startPlayWithAudioID:self.audioID];
        
        self.playBtn.selected = YES;
        
    } else {
        //正在播放
        [[ZBAudioPlayerManger sharedZBAudioPlayerManger] stopPlay];
        
        self.progressView.progress = 0;
        self.playBtn.selected = NO;
    }
}

#pragma mark -- notification "AudioPlayer-PlayProcess"
- (void)playProgress:(NSNotification *)sender {
    NSDictionary *info = sender.userInfo;
    NSTimeInterval currentTime = [info[@"currentTime"] doubleValue];
    NSTimeInterval duration = [info[@"duration"] doubleValue];
    NSInteger audioID = [info[@"audioID"] integerValue];
    BOOL finished = [info[@"finished"] boolValue];
    if (self.audioID == audioID) {

        self.progressView.progress = currentTime/duration;
    }
    
    if (finished) {
        self.playBtn.selected = NO;
        self.progressView.progress = 0;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AudioPlayer-PlayProcess" object:nil];
}



@end
