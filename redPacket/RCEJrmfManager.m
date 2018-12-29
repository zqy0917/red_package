//
//  RCEJrmfManager.m
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import "RCEJrmfManager.h"

NSString *const HBSaveMessageId = @"HBSaveMessageId";
NSString *const HBSaveAutoRobRedPacket = @"HBSaveAutoRobRedPacket";
NSString *const HBSaveRobRedPacketLevel = @"HBSaveRobRedPacketLevel";

@implementation RCEJrmfManager

+ (instancetype)shareManager{
    static RCEJrmfManager *manager;
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[RCEJrmfManager alloc] init];
        });
    }
    return manager;
}

static NSMutableDictionary *hongbaoDict;

- (void)addHongbaoId: (NSString *)modelId{
    if (hongbaoDict == nil) {
        hongbaoDict = [[NSMutableDictionary alloc] init];
    }
    [hongbaoDict setObject:@"RCEJrmf" forKey:modelId];
}

- (BOOL)hasInDict: (NSString *)modelId{
    if ([hongbaoDict objectForKey:modelId] != nil) {
        return YES;
    }
    return NO;
}

- (void)saveToUserDefaults {
    NSDictionary *dic = [hongbaoDict copy];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:HBSaveMessageId];
}

- (void)getHongBaoDict {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:HBSaveMessageId];
    hongbaoDict = [dic mutableCopy];
}

- (BOOL)autoRob {
    NSNumber *rob = [[NSUserDefaults standardUserDefaults] objectForKey:HBSaveAutoRobRedPacket];
    return [rob boolValue];
}

- (void)setAutoRob:(BOOL)autoRob {
    [[NSUserDefaults standardUserDefaults] setObject:@(autoRob) forKey:HBSaveAutoRobRedPacket];
}

- (float)robLevel {
    NSNumber *robLevel = [[NSUserDefaults standardUserDefaults] objectForKey:HBSaveRobRedPacketLevel];
    return [robLevel floatValue];
}

- (void)setRobLevel:(float)robLevel {
    [[NSUserDefaults standardUserDefaults] setObject:@(robLevel) forKey:HBSaveRobRedPacketLevel];
}

@end
