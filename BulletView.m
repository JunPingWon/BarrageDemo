//
//  BulletView.m
//  BarrageDemo
//
//  Created by wjp on 2017/8/30.
//  Copyright © 2017年 wjp. All rights reserved.
//

#import "BulletView.h"
#define Padding 10
#define Icon_Height 30

@interface BulletView()
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *iconImg;
@end

@implementation BulletView
//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 15;
        
        //计算弹幕的实际宽度
        CGFloat width = [comment sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}].width;
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + Icon_Height, 30);
        
        self.iconImg.frame = CGRectMake(-Padding, -Padding, Padding + Icon_Height, Padding + Icon_Height);
        self.iconImg.layer.cornerRadius = (Padding                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 + Icon_Height) / 2;
        self.iconImg.layer.borderWidth = 1;
        self.iconImg.layer.borderColor = [UIColor greenColor].CGColor;
        self.commentLabel.frame = CGRectMake(Padding + Icon_Height, 0, width, 30);
        self.commentLabel.text = comment;
        
    }
    return self;
}
//开始动画
- (void)startAnimation {
    
    //根据弹幕长度执行动画效果
    //根据 v = s / t，时间相同情况下，距离越长，速度就越快
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    //t = s/v;
    
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
 //   取消
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    //不能中间终止
//    dispatch_time_t after = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC));
//    dispatch_after(after, dispatch_get_main_queue(), ^{
//        if (self.moveStatusBlock) {
//            self.moveStatusBlock(Enter);
//        }
//    });
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
    
}

- (void)enterScreen {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}

//结束动画
- (void)stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font = [UIFont systemFontOfSize:14.0];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_commentLabel];
    }
    return _commentLabel;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.clipsToBounds = YES;
        _iconImg.contentMode = UIViewContentModeScaleToFill;
        _iconImg.image = [UIImage imageNamed:@"headImg"];
        [self addSubview:_iconImg];
    }
    return _iconImg;
}
@end
