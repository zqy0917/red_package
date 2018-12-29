//
//  UINavigationController+Jrmf.m
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import "UINavigationController+Jrmf.h"
#import <objc/runtime.h>
#import "UIView+Jrmf.h"
#import "RCEJrmfManager.h"

extern NSString *const tapRedPacketFinished;

@implementation UINavigationController (Jrmf)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(pushViewController:animated:);
        SEL newSel = @selector(jrmf_pushViewController:animated:);
        Method oldMethod = class_getInstanceMethod([self class], oldSel);
        Method newMethod = class_getInstanceMethod([self class], newSel);
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

- (void)jrmf_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([NSStringFromClass([viewController class]) isEqualToString:@"JrmfOPacketDetailViewController"] && [RCEJrmfManager shareManager].didTipMessage == NO && [RCEJrmfManager shareManager].autoRob) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:tapRedPacketFinished object:nil];
    }else{
        [self jrmf_pushViewController:viewController animated:animated];
    }
}

@end
