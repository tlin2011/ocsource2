//
//  ZBAudioPlayerManger.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBAudioPlayerManger.h"

@interface ZBAudioPlayerManger ()

@property (strong, nonatomic) AFURLConnectionOperation *operation;

@end

@implementation ZBAudioPlayerManger

singleton_implementation(ZBAudioPlayerManger)

- (void)startPlayWithAudioID:(NSInteger)audioID {
    if (audioID == 0) return;
    self.lastAudioID = self.audioID;
    self.audioID = audioID;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioPlayer-PlayProcess" object:nil userInfo:@{@"currentTime":@(self.audioPlayer.duration), @"duration":@(self.audioPlayer.duration), @"audioID":@(self.lastAudioID), @"finished":@(YES)}];
    
    NSURL *url = [self getPlayUrl];
    if (url) {
        [self startPlayWithContentsOfURL:url];
    } else {
        [self getNetworkAudio];
    }
}

- (void)startPlayWithContentsOfURL:(NSURL *)url {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    
    [self.audioPlayer play];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProcess:) userInfo:nil repeats:YES];
    
}

- (void)stopPlay {
    
    if (self.audioPlayer.isPlaying) {
        self.audioPlayer.currentTime = 0;   //当前播放时间设置为0
        [self.audioPlayer stop];
    }

    [self.timer invalidate];
    
}

#pragma mark -- AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioPlayer-PlayProcess" object:nil userInfo:@{@"currentTime":@(self.audioPlayer.duration), @"duration":@(self.audioPlayer.duration), @"audioID":@(self.audioID), @"finished":@(YES)}];
    
    [self.timer invalidate];
}

- (void)playProcess:(NSTimer *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioPlayer-PlayProcess" object:nil userInfo:@{@"currentTime":@(self.audioPlayer.currentTime), @"duration":@(self.audioPlayer.duration), @"audioID":@(self.audioID), @"finished":@(NO)}];

}

-(NSURL*)getPlayUrl
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat: @"%d.amr",audioId]];
    NSString *filePath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat: @"%ld.acc",(long)self.audioID]];
    
    //int iCnt = DecodeAMRFileToWAVEFile([filePath UTF8String], [filePath2 UTF8String] );
    
    if([HuaxoUtil getFileSize:filePath2]>0)
    {
        return [NSURL fileURLWithPath:filePath2];
    }
    return nil;
}

-(void)getNetworkAudio
{
    NSInteger audioId = self.audioID;
    
    if(audioId == 0){
        return;
    }
    
    //NSLog(@"pre get audio data id:%ld len:%ld obj:%@",(long)audioId,(long)audioLen,self);
    NSString *tmpUrl = [ApiUrl getNetAudioById:[NSString stringWithFormat:@"%ld",(long)audioId]];
    NSLog(@"now load audio:%ld",(long)audioId);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tmpUrl]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    if (self.operation != nil) {
        [self.operation cancel];
    }
    self.operation = operation;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat: @"%ld.amr",(long)audioId]];
    NSString *filePath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat: @"%ld.acc",(long)audioId]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"total-k:%.2fK",(float)totalBytesExpectedToRead/1000);
    }];
    /*
     [operation setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
     NSLog(@"setRedirectResponseBlock into!");
     return nil;
     }];*/
    [operation setCompletionBlock:^{
        NSLog(@"download completed");
        DecodeAMRFileToWAVEFile([filePath UTF8String], [filePath2 UTF8String] );
        NSURL *urlPlay = [NSURL fileURLWithPath:filePath2];
        
        [self startPlayWithContentsOfURL:urlPlay];
    }];
    [operation start];
}

@end
