//
//  AudioRecordView.m
//  FastTextViewDemo
//
//  Created by 话说社区 on 14-4-4.
//  Copyright (c) 2014年 wangqiang. All rights reserved.
//

#import "AudioRecordView.h"
#import "PlayProgressBar.h"
#import "amrFileCodec.h"

@interface AudioRecordView ()
@property (nonatomic, strong) UIView *recordView;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) PlayProgressBar *playProgress;
@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, strong) UILabel *playDuration;

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation AudioRecordView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initRecordViews];
        [self initRecorder];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRecordViews];
        [self initRecorder];
    }
    return self;
}

-(void)initRecordViews
{
    
    CGRect frame = self.frame;
    

    
    //录音视图
    self.recordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.recordView.backgroundColor = UIColorFromRGB(0xfbfbfb);
    [self addSubview:self.recordView];

    
    //录音
    self.recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 92, 92)];
    self.recordBtn.center = CGPointMake(frame.size.width/2.0, 85);
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"录音_语音.png"] forState:UIControlStateNormal];
    [self.recordBtn setBackgroundImage:[[UIImage imageNamed:@"录音_语音_h.png"] imageWithMobanThemeColor] forState:UIControlStateHighlighted];
    [self.recordBtn setImage:[[UIImage imageNamed:@"录音_语音_话筒.png"] imageWithMobanThemeColor] forState:UIControlStateNormal];
    [self.recordBtn setImage:[[UIImage imageNamed:@"录音_语音_话筒.png"] imageWithMobanThemeColor] forState:UIControlStateHighlighted];

    [self.recordBtn addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchDragOutside];
    [self.recordBtn addTarget:self action:@selector(recordFinished:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordView addSubview:self.recordBtn];
    
    //语音背景
    [self setVoiceBgKind:0];
    
    //提示
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    self.messageLabel.center = CGPointMake(frame.size.width/2.0, 152);
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont systemFontOfSize:15];
    self.messageLabel.textColor = [UIColor grayColor];
    self.messageLabel.text = GDLocalizedString(@"长按开始录音");
    [self addSubview:self.messageLabel];
}

- (void)setTimeBTnValue:(int)value {
    if (!self.timeBtn) {
        //录音记时
        self.timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42, 27)];
        self.timeBtn.center = CGPointMake(self.frame.size.width/2.0, 8+14);
        [self.timeBtn setBackgroundImage:[UIImage imageNamed:@"time_bg_语音.png"] forState:UIControlStateNormal];
        self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.timeBtn setTitleEdgeInsets:UIEdgeInsetsMake(-4, 0, 0, 0)];
        self.timeBtn.hidden = YES;
        [self.recordView addSubview:self.timeBtn];
    }

    if (value<1) {
        self.timeBtn.hidden = YES;
    } else {
        self.timeBtn.hidden = NO;
        [self.timeBtn setTitle:[NSString stringWithFormat:@"%d”",value] forState:UIControlStateNormal];
        
    }
    
}

//设置语音背景
- (void)setVoiceBgKind:(int)kind {
    if (!self.voiceBgs) {
        self.voiceBgs = [[NSMutableArray alloc] initWithCapacity:6];
        
        //
        for (int i=0; i<3; i++) {
            CGRect frame = self.frame;
            
            UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 75)];
            btnLeft.center = CGPointMake(frame.size.width/2.0-(65+i*25),85);
            btnLeft.userInteractionEnabled = NO;
            [btnLeft setImage:[UIImage imageNamed:[NSString stringWithFormat:@"voice_%d_语音.png",i+1]] forState:UIControlStateNormal];
            [btnLeft setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"voice_%d_语音_h.png",i+1]] imageWithMobanThemeColor] forState:UIControlStateSelected];
            [self.voiceBgs addObject:btnLeft];
            [self.recordView addSubview:btnLeft];
            
            UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 75)];
            btnRight.center = CGPointMake(frame.size.width/2.0+(65+i*25),85);
            btnRight.userInteractionEnabled = NO;
            [btnRight setImage:[UIImage imageNamed:[NSString stringWithFormat:@"voice_%d_语音.png",i+1+3]] forState:UIControlStateNormal];
            [btnRight setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"voice_%d_语音_h.png",i+1+3]] imageWithMobanThemeColor] forState:UIControlStateSelected];
            [self.voiceBgs addObject:btnRight];
            [self.recordView addSubview:btnRight];
        }
    }
    
    for (int i=0; i<[self.voiceBgs count]; i++) {
        UIButton *btn = self.voiceBgs[i];
        if (i<kind*2) {
            btn.selected = YES;
        }else {
            btn.selected = NO;
        }
    }

}



- (void)initRecorder
{
    if(recorder) return ;
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys://kAudioFormatLinearPCM
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                   [NSNumber numberWithFloat:8000], AVSampleRateKey,//800
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    /*
    recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                       [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                       [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                       //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                       //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                       //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                       nil];
    */
    NSString *strUrl =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; //NSTemporaryDirectory();//
    self.audioFilePath = [NSString stringWithFormat:@"%@/tmptest.wav", strUrl];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/tmptest.wav", strUrl]];
    NSLog(@"url:%@",self.audioFilePath);
    urlPlay = url;
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
    //核心代码.
    [recorder prepareToRecord];
}

- (IBAction)playAudio:(UIButton*)sender {
    if(self.recordTime<1) return ;
    
    AudioHelper* helper = [[AudioHelper alloc]init];
    BOOL bHeadSet = [helper hasHeadset];
    //[helper]
    [helper initSession];
    
    if (self.avPlay.playing) {
        [self.avPlay stop];
        self.playBtn.selected = NO;
        [self.playTimer invalidate];
        self.messageLabel.text = GDLocalizedString(@"点击播放");;
        return;
    }else{
        self.playBtn.selected = YES;
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    player.delegate = self;
    self.avPlay = player;
    [self.avPlay play];
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    self.messageLabel.text = GDLocalizedString(@"点击暂停");
    
}

-(void)updateUI{
    //self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.app.player.currentTime/60,(int)self.app.player.currentTime%60];
    NSLog(@"cur time:%f dur:%f",self.avPlay.currentTime, self.avPlay.duration);
    self.playProgress.value = self.avPlay.currentTime/self.avPlay.duration;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.playBtn.selected = NO;
    self.playProgress.value = 1.0;
    [self.playTimer invalidate];
    self.messageLabel.text = GDLocalizedString(@"点击播放");
}

- (IBAction)recordFinished:(id)sender {
    


    
    double cTime = recorder.currentTime;
    double deviceTime=recorder.deviceCurrentTime;
    self.recordTime = cTime;
    NSLog(@"record-time:%.2f device-time:%.2f",cTime,deviceTime);
    if (cTime > 1) {//如果录制时间<2 不发送
        NSLog(@"发出去");
        [recorder stop];
        [timer invalidate];
        //显示播放视图
        [self displayPlayView];
        [self createAudio];

        if(urlPlay){
            NSLog(@"audio-file-size:%.2fK",(float)getMyRecordFileSize([urlPlay path])/1024);
        }
    }else {
        NSLog(@"删除存储");
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
        [recorder stop];
        
        self.messageLabel.text = GDLocalizedString(@"长按开始录音");
        [self setTimeBTnValue:0];
        [self setVoiceBgKind:0];
        [timer invalidate];
    }

}

- (void)displayPlayView {
    if (!self.playView) {
        
        CGRect frame = self.frame;
        self.playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.playView.backgroundColor = UIColorFromRGB(0xfbfbfb);
        [self addSubview:self.playView];
        
        //重录
        UIButton *againRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        againRecordBtn.center = CGPointMake(frame.size.width/2.0+60, 85+34);
        againRecordBtn.layer.cornerRadius = againRecordBtn.frame.size.width/2.0;
        againRecordBtn.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
        againRecordBtn.layer.borderWidth = 8.0;
        againRecordBtn.layer.masksToBounds = YES;
        againRecordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [againRecordBtn setTitle:GDLocalizedString(@"重录") forState:UIControlStateNormal];
        [againRecordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        againRecordBtn.backgroundColor = [UIColor whiteColor];
        [againRecordBtn addTarget:self action:@selector(clickedAgainRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.playView addSubview:againRecordBtn];

        
        //播放进度
        PlayProgressBar *progress = [[PlayProgressBar alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        progress.center = CGPointMake(frame.size.width/2.0, 85);
        progress.layer.cornerRadius = progress.frame.size.width/2.0;
        progress.layer.masksToBounds = YES;
        progress.lineWidth = 20;
        progress.strokeColor = UIColorWithMobanTheme;
        progress.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self.playView addSubview:progress];
        self.playProgress = progress;
        
        //试听
        self.playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 82, 82)];
        self.playBtn.center = CGPointMake(frame.size.width/2.0, 85);
        self.playBtn.layer.cornerRadius = self.playBtn.frame.size.width/2.0;
        self.playBtn.layer.masksToBounds = YES;
        
        [self.playBtn setImage:[[UIImage imageNamed:@"播放_语音.png"] imageWithMobanThemeColor] forState:UIControlStateNormal];
        [self.playBtn setImage:[[UIImage imageNamed:@"暂停_语音.png"] imageWithMobanThemeColor] forState:UIControlStateSelected];
        [self.playBtn setBackgroundColor:[UIColor whiteColor]];

        [self.playBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.playView addSubview:self.playBtn];
        
        self.playDuration = [[UILabel alloc] initWithFrame:CGRectMake(0+2, 82-20, 82, 14)];
        self.playDuration.textAlignment = NSTextAlignmentCenter;
        self.playDuration.font = [UIFont systemFontOfSize:14];
        self.playDuration.textColor = [UIColor grayColor];
        [self.playBtn addSubview:self.playDuration];
        
        //insertBtn
        self.insertBtn = [[UIButton alloc]initWithFrame:CGRectMake(263, 200-50, 50, 30)];
        self.insertBtn.hidden = self.hiddenSendBtn;
        [self.insertBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.insertBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        self.insertBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        
        [self.insertBtn setTitle:GDLocalizedString(@"发送") forState:UIControlStateNormal];
        [self.insertBtn addTarget:self action:@selector(insert:) forControlEvents:UIControlEventTouchUpInside];
        [self.playView addSubview:self.insertBtn];
    }
    
    [self bringSubviewToFront:self.playView];
    [self bringSubviewToFront:self.messageLabel];
    self.messageLabel.text = GDLocalizedString(@"点击播放");
    self.playDuration.text = [self.timeBtn titleForState:UIControlStateNormal];
    self.playBtn.selected = NO;
    self.playProgress.value = 0;
}

- (void)clickedAgainRecordBtn:(UIButton *)sender {
    if ([self.avPlay isPlaying]) {
        [self.avPlay stop];
    }
    [self setVoiceBgKind:0];
    [self bringSubviewToFront:self.recordView];
    [self bringSubviewToFront:self.messageLabel];
    self.messageLabel.text = GDLocalizedString(@"长按开始录音");
    [self.playTimer invalidate];
    [self setVoiceBgKind:0];
    [self setTimeBTnValue:0];
    if ([self.delegate respondsToSelector:@selector(audioRecordViewWithCancelAudio:)]) {
        [self.delegate audioRecordViewWithCancelAudio:self];
    }
}

- (IBAction)recordCancel:(id)sender {
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
    [self setVoiceBgKind:0];
    [self setTimeBTnValue:0];
}


- (IBAction)record:(id)sender {
    [self initRecorder];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    
    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
        self.messageLabel.text = GDLocalizedString(@"松开结束录音");
    }else{
        NSLog(@"录音启动失败");
        //[timer invalidate];
        //[self btnUp:nil];
    }
    
}

- (void)createAudio {
    NSString* fileName = [NSString stringWithFormat:@"0_user_tmp%.0f.%ld.bgamr", [NSDate timeIntervalSinceReferenceDate] * 1000.0,(long)(self.recordTime*1000)];
    NSString* newfilePath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(),fileName];
    
    EncodeWAVEFileToAMRFile([[urlPlay path] UTF8String], [newfilePath UTF8String], 1, 16);
    
    if ([self.delegate respondsToSelector:@selector(audioRecordView:createdAudio:audioLen:)]) {
        [self.delegate audioRecordView:self createdAudio:newfilePath audioLen:(long)(self.recordTime*1000)];
    }
   
    NSLog(@"sendAudio:%@ len:%ld,",newfilePath,(long)(self.recordTime*1000));
}

- (IBAction)insert:(id)sender {
    NSLog(@"insert");
    if(self.recordTime<1)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"发送失败") message:GDLocalizedString(@"录音内容为空") delegate:nil cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [alertView show];
        return ;
    }
    /*
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"插入语音" message:@"" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertView show];
     */
    if(self.delegate )// && [self.delegate respondsToSelector:@selector(sendAudio:)])
    {
        
        /*
        NSData *mydata = [NSData dataWithContentsOfFile:[urlPlay path]];
        mydata = EncodeWAVEToAMR(mydata,1,16);//转吗
        //DecodeAMRFileToWAVEFile(<#const char *pchAMRFileName#>, <#const char *pchWAVEFilename#>)
        */
        NSString* fileName = [NSString stringWithFormat:@"0_user_tmp%.0f.%ld.bgamr", [NSDate timeIntervalSinceReferenceDate] * 1000.0,(long)(self.recordTime*1000)];
        NSString* newfilePath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(),fileName];
        
        EncodeWAVEFileToAMRFile([[urlPlay path] UTF8String], [newfilePath UTF8String], 1, 16);
        //NSLog(@"mydata:%@",mydata);
        //NSString* newfilePath = [NSString stringWithFormat:@"%@record01.amr", NSTemporaryDirectory()];
        /*
        BOOL isSaved = [mydata writeToFile:newfilePath atomically:NO];
        if (!isSaved) {
            NSLog(@"%@文件保存失败！", newfilePath);
            return ;
        }
         */
        
        bool ret = [self.delegate sendAudio:newfilePath audioLen:(long)(self.recordTime*1000)];
        NSLog(@"sendAudio:%@ len:%ld, ret:%d",newfilePath,(long)(self.recordTime*1000),ret);
    }else{
        NSLog(@"delegate:%@ not respondsToSelector:@selector(sendAudio:)",self.delegate);
    }
}

long getMyRecordFileSize(NSString* file)
{
    NSData *mydata = nil;//[NSData dataWithContentsOfFile:file];
    //mydata = EncodeWAVEToAMR(mydata,1,16);//转吗
    
    NSString *strUrl =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; //NSTemporaryDirectory();//
    NSString* amrFilePath = [NSString stringWithFormat:@"%@/tmptest.amr", strUrl];
    
    int fCnt= EncodeWAVEFileToAMRFile([file UTF8String], [amrFilePath UTF8String], 1, 16);
    mydata = [NSData dataWithContentsOfFile:amrFilePath];

    //NSLog(@"mydata:%@",mydata);
    NSString* newfilePath = [NSString stringWithFormat:@"%@record01.amr", NSTemporaryDirectory()];
    BOOL isSaved = [mydata writeToFile:newfilePath atomically:NO];
    if (isSaved) {
        NSLog(@"%@文件成功保存！", newfilePath);
    }
    file = newfilePath;
    @try {
        NSLog(@"getMyFileSize:%@",newfilePath);
        long imgSize=0;
        NSError *error = nil;
        NSFileManager *fm  = [NSFileManager defaultManager];
        NSDictionary* dictFile = [fm attributesOfItemAtPath:newfilePath error:&error];
        if (!error)
        {
            imgSize = [dictFile fileSize]; //得到文件大小
        }
        return imgSize ;
    }
    @catch (NSException *exception) {
        NSLog(@"getMyFileSize-exception:%@",exception);
    }
    @finally {
    }
}
- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double cTime = recorder.currentTime;
    double deviceTime=recorder.deviceCurrentTime;
    [self setTimeBTnValue:cTime];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults &&lowPassResults<=0.06) {
        [self setVoiceBgKind:0];
    }else if (0.06<lowPassResults && lowPassResults<=0.20) {
        [self setVoiceBgKind:1];
    }else if (0.20<lowPassResults && lowPassResults<=0.55) {
        [self setVoiceBgKind:2];
    }else if (0.55<lowPassResults<=0.9) {
        [self setVoiceBgKind:3];
    }else {
        [self setVoiceBgKind:3];
    }
}

- (void)dealloc {

}
@end
