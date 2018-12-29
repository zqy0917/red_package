//
//  UIViewController+Jrmf.m
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import "UIViewController+Jrmf.h"
#import "RCEJrmfManager.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIViewController (Jrmf)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[self class] getPropertyList];
        [[self class] getIvarList];
        [[self class] getInstanceMethodList];
        [[self class] getClassMethodList];
        
        SEL oldSel = @selector(presentViewController:animated:completion:);
        SEL newSel = @selector(rc_presentViewController:animated:completion:);
        Method oldMethod = class_getInstanceMethod([self class], oldSel);
        Method newMethod = class_getInstanceMethod([self class], newSel);
        method_exchangeImplementations(oldMethod, newMethod);
        
        SEL oldSel1 = @selector(loadView);
        SEL newSel1 = @selector(rc_loadView);
        Method oldMethod1 = class_getInstanceMethod([self class], oldSel1);
        Method newMethod1 = class_getInstanceMethod([self class], newSel1);
        method_exchangeImplementations(oldMethod1, newMethod1);
        
    });
}

- (void)rc_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    if ([NSStringFromClass([viewControllerToPresent class]) isEqualToString:@"JYPacketNavigationController"] && [RCEJrmfManager shareManager].autoRob) {
        [RCEJrmfManager shareManager].jrmfView = viewControllerToPresent.childViewControllers[0].view;
    }
    [self rc_presentViewController:viewControllerToPresent animated:flag completion:completion];
    
}

- (void)rc_loadView{
    if ([NSStringFromClass([self class]) isEqualToString:@"JrmfOpenPacketViewController"] && [RCEJrmfManager shareManager].didTipMessage == NO && [RCEJrmfManager shareManager].autoRob) {
        if ([self respondsToSelector:@selector(doActionOpenPacket)]) {
            ((void(*)(id, SEL))objc_msgSend)(self,@selector(doActionOpenPacket));
        }
    }
    [self rc_loadView];
}

//获取类的属性
+ (void)getPropertyList {
    //属性个数
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(NSClassFromString(@"JrmfOpenPacketViewController"), &count);
    for (int i =0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name =property_getName(property);
        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSLog(@"***属性名:%@", nameStr);
    }
    free(properties);
}

//获取类的成员变量
+ (void)getIvarList {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList(NSClassFromString(@"JrmfOpenPacketViewController"), &count);
    for (int i =0; i < count; i++) {
        NSString *nameStr = [NSString stringWithUTF8String:ivar_getName(ivarList[i])];
        NSLog(@"***ivarName:%@", nameStr);
    }
    free(ivarList);
}

//获取一个类的实例方法列表
+ (void)getInstanceMethodList {
    unsigned int count;
    Method *methods = class_copyMethodList(NSClassFromString(@"JrmfOpenPacketViewController"), &count);
    for (int i =0; i < count; i++) {
        SEL name = method_getName(methods[i]);
        NSLog(@"***实例方法名:%@",NSStringFromSelector(name));
    }
    free(methods);
}

//获取一个类的类方法列表
+ (void)getClassMethodList {
    unsigned int count;
    Method *methods = class_copyMethodList(object_getClass(NSClassFromString(@"JrmfOpenPacketViewController")), &count);
    for (int i =0; i < count; i++) {
        SEL name = method_getName(methods[i]);
        NSLog(@"***类方法名:%@",NSStringFromSelector(name));
    }
    free(methods);
}

@end
