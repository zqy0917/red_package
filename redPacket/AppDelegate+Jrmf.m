//
//  AppDelegate+Jrmf.m
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import "AppDelegate+Jrmf.h"
#import <objc/runtime.h>
#import "RCEJrmfManager.h"

@implementation AppDelegate (Jrmf)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(application:didFinishLaunchingWithOptions:);
        SEL newSel = @selector(rc_application:didFinishLaunchingWithOptions:);
        Method oldMethod = class_getInstanceMethod([self class], oldSel);
        Method newMethod = class_getInstanceMethod([self class], newSel);
        method_exchangeImplementations(oldMethod, newMethod);
        
        SEL oldSel1 = @selector(applicationWillTerminate:);
        SEL newSel1 = @selector(rc_applicationWillTerminate:);
        Method oldMethod1 = class_getInstanceMethod([self class], oldSel1);
        Method newMethod1 = class_getInstanceMethod([self class], newSel1);
        method_exchangeImplementations(oldMethod1, newMethod1);
    });
}

- (BOOL)rc_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[RCEJrmfManager shareManager] getHongBaoDict];
    return [self rc_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)rc_applicationWillTerminate:(UIApplication *)application {
    [self rc_applicationWillTerminate:application];
    [[RCEJrmfManager shareManager] saveToUserDefaults];
}

@end
