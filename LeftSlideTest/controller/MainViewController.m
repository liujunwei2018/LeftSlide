//
//  MainViewController.m
//  LeftSlideTest
//
//  Created by 刘君威 on 2019/2/18.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;
    [self setupNavigationView];
    
    if (TargetType == 1) {
        self.view.backgroundColor = UIColor.yellowColor;
    }
    if (TargetType == 2) {
        self.view.backgroundColor = UIColor.blueColor;
    }
    if (TargetType == 3) {
        self.view.backgroundColor = UIColor.greenColor;
    }
}

- (void)setupNavigationView {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIApplication sharedApplication].statusBarFrame.size.height + 44)];
    navView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:navView];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftItem setTitle:@"我的" forState:UIControlStateNormal];
    [leftItem setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    leftItem.frame = CGRectMake(20, [UIApplication sharedApplication].statusBarFrame.size.height, 40, 44);
    [leftItem addTarget:self action:@selector(leftItemSelected) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftItem];
}

- (void)leftItemSelected {
    if (self.leftItemClick) {
        self.leftItemClick();
    }
}

@end
