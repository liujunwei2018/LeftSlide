//
//  ContainerViewController.h
//  LeftSlideTest
//
//  Created by 刘君威 on 2019/2/18.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContainerViewController : UIViewController
+ (instancetype)containerViewControllerWithLeftVC:(UIViewController *)leftVC mainVC:(UIViewController *)mainVC;

- (instancetype)initWithLeftVC:(UIViewController *)leftVC mainVC:(UIViewController *)mainVC;
@end

NS_ASSUME_NONNULL_END
