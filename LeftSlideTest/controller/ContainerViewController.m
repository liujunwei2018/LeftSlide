//
//  ContainerViewController.m
//  LeftSlideTest
//
//  Created by 刘君威 on 2019/2/18.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "LeftViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMaxLeftSlideWidth (kScreenWidth - 100)
CGFloat const kMaxSpeed = 800;

@interface ContainerViewController ()
@property (nonatomic, strong) MainViewController *mainVC;
@property (nonatomic, strong) LeftViewController *leftVC;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *pan1;  // 开始的边缘平移手势
@property (nonatomic, strong) UIPanGestureRecognizer *pan2; // 侧滑后的平移手势

@end

@implementation ContainerViewController

+ (instancetype)containerViewControllerWithLeftVC:(UIViewController *)leftVC mainVC:(UIViewController *)mainVC{
    return  [[ContainerViewController alloc] initWithLeftVC:leftVC mainVC:mainVC];
}

- (instancetype)initWithLeftVC:(UIViewController *)leftVC mainVC:(UIViewController *)mainVC{
    
    self = [super init];
    if (self) {
        
        self.leftVC = (LeftViewController *)leftVC;
        self.mainVC = (MainViewController *)mainVC;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - lift Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 如果mainVC有导航栏,需要自定义导航栏,系统导航栏无法跟随移动
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self hideLeftVc];
}

#pragma mark - setup

- (void)setupUI {
    [self addChildViewController:self.mainVC];
    [self addChildViewController:self.leftVC];
    [self.view addSubview:self.mainVC.view];
    [self.view addSubview:self.leftVC.view];
    
    self.leftVC.view.frame = self.view.bounds;
    self.mainVC.view.frame = self.view.bounds;
    // 将mainVC.view 放到最前面显示
    [self.view bringSubviewToFront:self.mainVC.view];
    
    // 添加手势
    [self.mainVC.view addGestureRecognizer:self.pan1];
    [self.mainVC.view addGestureRecognizer:self.pan2];
    [self.mainVC.view addGestureRecognizer:self.tapGesture];
    
    // 回调事件
    __weak __typeof(&*self)weakSelf = self;
    self.mainVC.leftItemClick = ^{
        [weakSelf showLeftVc];
    };
}

#pragma mark - 手势处理

- (void)screenGesture:(UIPanGestureRecognizer *)pan {
    // 移动的距离
    CGPoint point = [pan translationInView:pan.view];
    // 移动的速度
    CGPoint verPoint = [pan velocityInView:pan.view];
    
    CGRect frame = self.mainVC.view.frame;
    frame.origin.x += point.x;
    self.mainVC.view.frame = frame;
    // 边界限定
    if (frame.origin.x >= kMaxLeftSlideWidth) {
        frame.origin.x = kMaxLeftSlideWidth;
    }
    if (frame.origin.x <= 0) {
        frame.origin.x = 0;
    }
    self.mainVC.view.frame = frame;


    if (pan.state == UIGestureRecognizerStateEnded) {
        // 判断手势
        if (pan == self.pan1) {
            if (verPoint.x >= kMaxSpeed) {
                [self showLeftVc];
            } else {
                if (frame.origin.x >= kScreenWidth / 2) {
                    [self showLeftVc];
                } else {
                    [self hideLeftVc];
                }
            }
        }
        else {
            if (verPoint.x < -kMaxSpeed) {
                [self hideLeftVc];
            } else {
                if (frame.origin.x >= kScreenWidth / 2) {
                    [self showLeftVc];
                } else {
                    [self hideLeftVc];
                }
            }
        }
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
}

/// 方法2
- (void)hideLeftVc{
 
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.mainVC.view.frame;
        frame.origin.x = 0;
        self.mainVC.view.frame = frame;
    } completion:^(BOOL finished) {
        self.pan1.enabled = YES;
        self.pan2.enabled = NO;
        self.tapGesture.enabled = NO;
    }];
}

-(void)showLeftVc{
  
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.mainVC.view.frame;
        frame.origin.x = kMaxLeftSlideWidth;
        self.mainVC.view.frame = frame;
    } completion:^(BOOL finished) {
        self.pan1.enabled = NO;
        self.pan2.enabled = YES;
        self.tapGesture.enabled = YES;
    }];
}

#pragma mark - getter

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLeftVc)];
    }
    return _tapGesture;
}

-(UIScreenEdgePanGestureRecognizer *)pan1{
    if (!_pan1) {
        _pan1 =[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenGesture:)];
        _pan1.edges = UIRectEdgeLeft;
        _pan1.enabled = YES;
    }
    return _pan1;
}

-(UIPanGestureRecognizer *)pan2{
    if (!_pan2) {
        _pan2 =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(screenGesture:)];
        _pan2.enabled = NO;
    }
    return _pan2;
}
@end
