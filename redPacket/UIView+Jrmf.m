//
//  UIView+Jrmf.m
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import "UIView+Jrmf.h"
#import <objc/runtime.h>
#import "RCEJrmfManager.h"

NSString *const tapRedPacketFinished = @"tapRedPacketFinished";

@implementation UIView (Jrmf)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(addSubview:);
        SEL newSel = @selector(rc_addSubview:);
        Method oldMethod = class_getInstanceMethod([self class], oldSel);
        Method newMethod = class_getInstanceMethod([self class], newSel);
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

- (void)rc_addSubview:(UIView *)view{
    if ([self isEqual:[RCEJrmfManager shareManager].jrmfView]) {
        [RCEJrmfManager shareManager].jrmfImageView = view;
    }else if ([self isEqual:[RCEJrmfManager shareManager].jrmfImageView]) {
        NSLog(@"%@", view);
        if ([view isMemberOfClass:[UIButton class]] && view.clipsToBounds == YES) {
        }else if ([view isMemberOfClass:[UIButton class]] && view.bounds.size.width > 200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([RCEJrmfManager shareManager].robLevel * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchUpInside];
            });
        }
    }
    [self rc_addSubview:view];
    
}

@end
