//
//  RCEChatViewController+Jrmf.m
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import "RCEChatViewController+Jrmf.h"
#import <objc/runtime.h>
#import <RongIMKit/RongIMKit.h>
#import "RCEJrmfManager.h"

extern NSString *const tapRedPacketFinished;

@implementation RCEChatViewController (Jrmf)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(willDisplayMessageCell:atIndexPath:);
        SEL newSel = @selector(jrmf_willDisplayMessageCell:atIndexPath:);
        Method oldMethod = class_getInstanceMethod([self class], oldSel);
        Method newMethod = class_getInstanceMethod([self class], newSel);
        method_exchangeImplementations(oldMethod, newMethod);
        
        SEL oldSel1 = @selector(didTapMessageCell:);
        SEL newSel1 = @selector(rc_didTapMessageCell:);
        Method oldMethod1 = class_getInstanceMethod([self class], oldSel1);
        Method newMethod1 = class_getInstanceMethod([self class], newSel1);
        method_exchangeImplementations(oldMethod1, newMethod1);
        
        SEL oldSel2 = @selector(viewDidLoad);
        SEL newSel2 = @selector(rc_viewDidLoad);
        Method oldMethod2 = class_getInstanceMethod([self class], oldSel2);
        Method newMethod2 = class_getInstanceMethod([self class], newSel2);
        method_exchangeImplementations(oldMethod2, newMethod2);
        
        SEL oldSel3 = @selector(viewWillDisappear:);
        SEL newSel3 = @selector(rc_viewWillDisappear:);
        Method oldMethod3 = class_getInstanceMethod([self class], oldSel3);
        Method newMethod3 = class_getInstanceMethod([self class], newSel3);
        method_exchangeImplementations(oldMethod3, newMethod3);
        
    });
}

- (void)jrmf_willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([[[cell.model.content class] getObjectName] isEqualToString:@"RCJrmf:RpMsg"] && [RCEJrmfManager shareManager].autoRob) {
        if ([[RCEJrmfManager shareManager] hasInDict:[NSString stringWithFormat:@"%@", @(cell.model.messageId)]]) {
            
        }else{
            [RCEJrmfManager shareManager].didTipMessage = NO;
            [self didTapMessageCell:cell.model];
        }
    }
    [self jrmf_willDisplayMessageCell:cell atIndexPath:indexPath];
}

- (void)rc_didTapMessageCell:(RCMessageModel *)model {
    if ([[RCEJrmfManager shareManager] hasInDict:[NSString stringWithFormat:@"%@", @(model.messageId)]]) {
        [RCEJrmfManager shareManager].didTipMessage = YES;
    }
    [self rc_didTapMessageCell:model];
    [[RCEJrmfManager shareManager] addHongbaoId:[NSString stringWithFormat:@"%@", @(model.messageId)]];
}

- (void)rc_viewDidLoad{
    [self rc_viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissRedPacket)
                                                 name:tapRedPacketFinished
                                               object:nil];
}

- (void)rc_viewWillDisappear:(BOOL)animated{
    [self rc_viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:tapRedPacketFinished object:nil];
}

- (void)dismissRedPacket {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
}

@end
