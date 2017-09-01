//
//  BulletView.h
//  BarrageDemo
//
//  Created by wjp on 2017/8/30.
//  Copyright © 2017年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>

//弹幕三种状态
typedef NS_ENUM(NSInteger,MoveStatus) {
    Start,
    Enter,
    End
};

@interface BulletView : UIView

@property (nonatomic, assign) int trajectory;//弹道
@property (nonatomic, copy) void (^moveStatusBlock)(MoveStatus status);//弹幕状态回调

//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;
//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAnimation;

@end
