//
//  RCEChatListViewController+Jrmf.m
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import "RCEChatListViewController+Jrmf.h"
#import "RCEChatViewController.h"
#import <objc/runtime.h>
#import "RCEJrmfManager.h"

@implementation RCEChatListViewController (Jrmf)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(didReceiveMessageNotification:);
        SEL newSel = @selector(rc_didReceiveMessageNotification:);
        Method oldMethod = class_getInstanceMethod([self class], oldSel);
        Method newMethod = class_getInstanceMethod([self class], newSel);
        method_exchangeImplementations(oldMethod, newMethod);
        
        SEL oldSel1 = @selector(viewDidLoad);
        SEL newSel1 = @selector(rc_viewDidLoad);
        Method oldMethod1 = class_getInstanceMethod([self class], oldSel1);
        Method newMethod1 = class_getInstanceMethod([self class], newSel1);
        method_exchangeImplementations(oldMethod1, newMethod1);
    });
}

- (void)rc_viewDidLoad {
    [self rc_viewDidLoad];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tapGes.numberOfTapsRequired = 2;
    [self.navigationController.navigationBar addGestureRecognizer:tapGes];
    
    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
    doubleTapGes.numberOfTapsRequired = 3;
    [self.navigationController.navigationBar addGestureRecognizer:doubleTapGes];
    
    [tapGes requireGestureRecognizerToFail:doubleTapGes];
}

- (void)rc_didReceiveMessageNotification:(NSNotification *)notification{
    
    RCMessage *message = notification.object;
    if ([message.objectName isEqualToString:@"RCJrmf:RpMsg"] && [RCEJrmfManager shareManager].autoRob) {
        RCEChatViewController *chatVC = [[RCEChatViewController alloc] init];
        chatVC.targetId = message.targetId;
        chatVC.conversationType = message.conversationType;
        chatVC.enableNewComingMessageIcon = YES; //开启消息提醒
        chatVC.enableUnreadMessageIcon = YES;
        //如果是单聊，不显示发送方昵称
        if (message.conversationType == ConversationType_PRIVATE) {
            chatVC.displayUserNameInCell = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:chatVC animated:NO];
        });
    }
    [self rc_didReceiveMessageNotification:notification];
}

- (void)tapAction {
    float level = [RCEJrmfManager shareManager].robLevel;
    level += 0.2;
    if (level > 1.0) {
        level = 0;
    }
    [RCEJrmfManager shareManager].robLevel = level;
    NSString *alertMsg = [NSString stringWithFormat:@"抢红包自动延迟 %.1f 秒", level];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doubleTapAction {
    
    NSString *alertMsg = @"";
    [RCEJrmfManager shareManager].autoRob = ![RCEJrmfManager shareManager].autoRob;
    if ([RCEJrmfManager shareManager].autoRob) {
        alertMsg = @"已开启自动抢红包模式";
    }else{
        alertMsg = @"已关闭自动抢红包模式";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)versionService {
    
}

@end
