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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    Speaker * speaker = [[Speaker alloc] init];
    
    [speaker start];
    
    

}



@end
