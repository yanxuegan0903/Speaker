//
//  Speaker.h
//  UUSmartHome
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 Fuego. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeakerDelegate <NSObject>

-(void)speakerDidRecieveData:(NSData *)data;

@end

@interface Speaker : NSObject

- (void)start;
- (void) stop;

@property (nonatomic, weak) id<SpeakerDelegate>delegate;

@end
