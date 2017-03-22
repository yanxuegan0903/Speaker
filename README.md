# Speaker
这是一个使用音频队列进行录音的小Demo

注意：
在录音的时候有时候会出现 连续调用好几次回调的情况 录音不成功，
这是因为在录音的时候，没有设置 AVAudioSession   
NSError * sessionError ;
    
BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&sessionError];
    
if (success) {
    NSLog(@"成功");
}else{
    NSLog(@"失败");
}
录音的时候使用 AVAudioSessionCategoryRecord   播放音频的话使用AVAudioSessionCategoryPlayback 就好了
