//
//  ViewController.m
//  Speaker
//
//  Created by vsKing on 2017/2/16.
//  Copyright © 2017年 vsKing. All rights reserved.
//

#import "ViewController.h"
#import "Speaker.h"



@interface ViewController ()
{
    BOOL _isRecording;
}

@property (nonatomic, strong) Speaker *record;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.record = [Speaker sharedInstance];
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if (_isRecording) {
        [self.record stop];
        _isRecording = NO;
    }else{
        _isRecording = YES;
        [self.record start];
    }
    
    
    

}



@end
