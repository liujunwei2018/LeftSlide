//
//  LeftViewController.m
//  LeftSlideTest
//
//  Created by 刘君威 on 2019/2/18.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import "LeftViewController.h"
#import "ViewController.h"
@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.yellowColor;
    
    // 测试跳转效果
    UIButton *name = [UIButton buttonWithType:UIButtonTypeCustom];
    name.frame = CGRectMake(100, 100, 50, 20);
    [name setTitle:@"跳转" forState:UIControlStateNormal];
    [name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [name addTarget:self action:@selector(pushToNextViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:name];
}

- (void)pushToNextViewController {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
