//
//  Speaker.m
//  UUSmartHome
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 Fuego. All rights reserved.
//

#import "Speaker.h"
#import <AVFoundation/AVFoundation.h>

#define kNumberBuffers 4



@interface Speaker (){
    AudioFileTypeID _fileFormat;
    AudioStreamBasicDescription _mDataFormat;
    AudioQueueRef               _queue;
    AudioQueueBufferRef         _mBuffers[kNumberBuffers];
    AudioFileID                 _outputFile;

}

@end

@implementation Speaker


static void AQInputCallback (void *                          inUserData,
                             AudioQueueRef                   inAQ,
                             AudioQueueBufferRef             inBuffer,
                             const AudioTimeStamp *          inStartTime,
                             UInt32                          inNumberPacketDescriptions,
                             const AudioStreamPacketDescription *inPacketDescs){
    
    NSLog(@"============================ speaker 产生回调");

    
    Speaker *speaker = (__bridge Speaker *) inUserData;
    [speaker processAudioBuffer:inBuffer withQueue:inAQ];
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}


+(Speaker *)sharedInstance{
    static Speaker *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Speaker alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


//set audio parameter
-(void)setup{
    
    NSLog(@"============================ speaker 初始化");
    
    
    _mDataFormat.mSampleRate = 8000;
    _mDataFormat.mFormatID = kAudioFormatLinearPCM;
    _mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger |kLinearPCMFormatFlagIsPacked;
    _mDataFormat.mFramesPerPacket = 1;
    _mDataFormat.mChannelsPerFrame = 1;
    _mDataFormat.mBitsPerChannel = 16;
    _mDataFormat.mBytesPerPacket = (_mDataFormat.mBitsPerChannel/8) * _mDataFormat.mChannelsPerFrame;
    _mDataFormat.mBytesPerFrame = _mDataFormat.mBytesPerPacket;
    
    AudioQueueNewInput(&_mDataFormat, AQInputCallback, (__bridge void *)(self), NULL, kCFRunLoopCommonModes,0, &_queue);
    
    //口述音频处理
    for (int i=0;i<kNumberBuffers;i++){
//        AudioQueueAllocateBuffer(_queue, 640, &_mBuffers[i]);
        AudioQueueAllocateBuffer(_queue, 960, &_mBuffers[i]);   // 修改了
        AudioQueueEnqueueBuffer(_queue, _mBuffers[i], 0, NULL);
    }

}

- (void)start{
    
    NSLog(@"============================ speaker start");
    
    NSError * sessionError ;
    
    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&sessionError];
    
    if (success) {
        NSLog(@"成功");
    }else{
        NSLog(@"失败");
    }
    
    
    
    
//    for (int i=0;i<kNumberBuffers;i++){
//        AudioQueueEnqueueBuffer(_queue, _mBuffers[i], 0, NULL);
//    }
    int status = AudioQueueStart(_queue, NULL);
    NSLog(@"------------------------开始录音 status = %d",status);
}

- (void)stop{

    int status = AudioQueueStop(_queue, true);
    
    NSLog(@"------------------------停止录音 status = %d",status);
    
}

-(void)dealloc{
    for (int i = 0; i < kNumberBuffers; i++) {
        AudioQueueFreeBuffer(_queue, _mBuffers[i]);
    }
    
}

/**
 *  call talk delegate
 *
 *  @param buffer buffer description
 *  @param queue  <#queue description#>
 */
- (void) processAudioBuffer:(AudioQueueBufferRef) buffer withQueue:(AudioQueueRef) queue{
    
    NSData *data = [[NSData alloc] initWithBytes:buffer->mAudioData length:buffer->mAudioDataByteSize];
    
    NSLog(@"============================ speaker data.length = %lu",(unsigned long)data.length);
    
    
    if (data.length != 960) {
        
        NSLog(@"============================ speaker data 长度不对 直接返回");
        
        return ;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(speakerDidRecieveData:)]) {
        [self.delegate speakerDidRecieveData:data];
    }
}

@end
