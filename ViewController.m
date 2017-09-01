//
//  ViewController.m
//  BarrageDemo
//
//  Created by wjp on 2017/8/30.
//  Copyright © 2017年 wjp. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"
@interface ViewController ()
@property (nonatomic, strong) BulletManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[BulletManager alloc] init];
    
    __weak typeof (self) weakSelf = self;
    self.manager.generateViewBlock = ^(BulletView *view) {
        [weakSelf addBulletView:view];
    };
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [startBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    stopBtn.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [stopBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];

}

- (void)startBtnClick:(UIButton *)sender {
    [self.manager start];
}

- (void)stopBtnClick:(UIButton *)sender {
    [self.manager stop];
}

- (void)addBulletView:(BulletView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.trajectory * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}
@end
