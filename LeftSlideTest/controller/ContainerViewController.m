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
// 点击收起侧边栏
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
// 开始的边缘平移手势
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *pan1;
// 侧滑后的平移手势
@property (nonatomic, strong) UIPanGestureRecognizer *pan2;

@end

@implementation ContainerViewController

#pragma mark - init

+ (instancetype)containerViewControllerWithLeftVC:(UIViewController *)leftVC mainVC:(UIViewController *)mainVC{
    return  [[ContainerViewController alloc] initWithLeftVC:leftVC mainVC:mainVC];
}

- (instancetype)initWithLeftVC:(UIViewController *)leftVC mainVC:(UIViewController *)mainVC{
    
    self = [super init];
    if (self) {
        // 根据自己创建的两个控制器进行相应的强制转换
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
    // 显示导航栏,否则侧边栏中的跳转后的控制器没有导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // pop后返回的主页,不设置的话返回的是侧滑展示出来的状态
    [self hideLeftVc];
}

#pragma mark - setup

- (void)setupUI {
    [self addChildViewController:self.mainVC];
    [self addChildViewController:self.leftVC];
    [self.view addSubview:self.leftVC.view];
    [self.view addSubview:self.mainVC.view];
    
    self.leftVC.view.frame = self.view.bounds;
    self.mainVC.view.frame = self.view.bounds;
    
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
    // 边界限定:
    // 1.当滑动大于 kMaxLeftSlideWidth 时,设置为 kMaxLeftSlideWidth
    if (frame.origin.x >= kMaxLeftSlideWidth) {
        frame.origin.x = kMaxLeftSlideWidth;
    }
    // 2.当滑动小于等于0时,设置为0
    if (frame.origin.x <= 0) {
        frame.origin.x = 0;
    }
    self.mainVC.view.frame = frame;


    if (pan.state == UIGestureRecognizerStateEnded) {
        /// 判断手势
        // 屏幕边缘右滑
        if (pan == self.pan1) {
            // 速度大于 kMaxSpeed 时自动展示完整
            // 小于 kMaxSpeed 时为拖动效果 , 拖动超过 kScreenWidth / 2 时自动展示完全
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
        // 左滑收回
        else {
            // 左滑返回的 verPoint.x 是负数
            if (verPoint.x < -kMaxSpeed) {
                [self hideLeftVc];
            } else {
                // 左滑超过 kScreenWidth / 2 时自动收回
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
