//
//  BulletManager.h
//  BarrageDemo
//
//  Created by wjp on 2017/8/30.
//  Copyright © 2017年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
@interface BulletManager : NSObject

@property (nonatomic, copy) void(^generateViewBlock)(BulletView *view);
//弹幕开始
- (void)start;
//弹幕结束
- (void)stop;
@end
