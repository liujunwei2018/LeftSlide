//
//  ViewController.m
//  LeftSlideTest
//
//  Created by 刘君威 on 2019/2/18.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor purpleColor];
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


@end
