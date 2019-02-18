//
//  MainViewController.h
//  LeftSlideTest
//
//  Created by 刘君威 on 2019/2/18.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController
@property (nonatomic, copy) void(^leftItemClick)(void);
@end
