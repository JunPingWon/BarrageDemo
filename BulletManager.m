//
//  BulletManager.m
//  BarrageDemo
//
//  Created by wjp on 2017/8/30.
//  Copyright © 2017年 wjp. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"
@interface BulletManager ()
//弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *dataSource;
//弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;
//
@property (nonatomic, assign) BOOL stopAnimation;
@end


@implementation BulletManager

- (instancetype)init {
    if (self = [super init]) {
        self.stopAnimation = YES;
    }
    return self;
}

//弹幕开始
- (void)start {
    if (!self.stopAnimation) {
        return;
    }
    self.stopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletComment];
    
}

//弹幕结束
- (void)stop {
    if (self.stopAnimation) {
        return;
    }
    self.stopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

//初始化弹幕，随机分配弹幕轨迹（3个为例）
- (void)initBulletComment {
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) {
        
        if (self.bulletComments.count > 0) {
            
            //通过随机数获取到弹幕的轨迹
            NSInteger index = arc4random() % trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory {
    if (self.stopAnimation) {
        return;
    }
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof (view) weakView = view;
    __weak typeof (self) weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (self.stopAnimation) {
            return;
        }
        switch (status) {
            case Start: {
                //弹幕开始进入屏幕，弹幕view加入弹幕管理的变量bulletViews中
                [weakSelf.bulletViews addObject:weakView];
                break;
            }
            case Enter: {
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕轨迹中创建一个弹幕
                NSString *comment = [weakSelf nextComment];
                //递归调用
                if (comment) {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case End: {
                //弹幕飞出屏幕后从bulletViews中删除，释放资源
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                //说明屏幕上已经没有弹幕了，开始循环滚动
                if (weakSelf.bulletViews.count == 0) {
                    self.stopAnimation = YES;
                    [weakSelf start];
                }
            }
                
                break;
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
    
}

- (NSString *)nextComment {
    if (self.bulletComments.count == 0) {
        return nil;
    }
  
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~~~",
                                                       @"弹幕2~~~~",
                                                       @"弹幕3~~~~~~~~~~~~~",
                                                       @"弹幕4~~~~~~",
                                                       @"弹幕5~~~",
                                                       @"弹幕6~~~~~~~~~~",
                                                       @"弹幕7~~~~~~",
                                                       @"弹幕8~~~",
                                                       @"弹幕9~~~~~~~~~~~~~~~~",
                                                       @"弹幕10~~~~~~",
                                                       @"弹幕11~~~~~~~~",
                                                       @"弹幕12~~~~~",
                                                       @"弹幕13~~~~~~",
                                                       @"弹幕14~~~~~~~~~~~~~",
                                                       @"弹幕15~~~~~~~~~~",
                                                       @"弹幕16~~~~~~",
                                                       @"弹幕17~~",
                                                       @"弹幕18~~~~~~~~~~~"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}
@end
