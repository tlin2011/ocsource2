//
//  ZBAudioPlayerManger.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Singleton.h"
#import "HuaxoUtil.h"
#import "AFNetworking.h"
#import "amrFileCodec.h"

@interface ZBAudioPlayerManger : NSObject <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger lastAudioID;
@property (assign, nonatomic) NSInteger audioID;

singleton_interface(ZBAudioPlayerManger)

- (void)startPlayWithAudioID:(NSInteger)audioID;
- (void)startPlayWithContentsOfURL:(NSURL *)url;
- (void)stopPlay;

@end
