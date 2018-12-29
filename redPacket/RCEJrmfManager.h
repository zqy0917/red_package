//
//  RCEJrmfManager.h
//  RongEnterpriseApp
//
//  Created by Zqy on 2018/2/7.
//  Copyright © 2018年 rongcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RCEJrmfManager : NSObject

+ (instancetype)shareManager;

@property(nonatomic, assign) BOOL autoRob;

@property(nonatomic, assign) float robLevel;

@property(weak, nonatomic) UIView *jrmfView;

@property(weak, nonatomic) UIView *jrmfImageView;

@property(nonatomic, assign) BOOL didTipMessage;

- (void)addHongbaoId: (NSString *)modelId;

- (BOOL)hasInDict: (NSString *)modelId;

- (void)saveToUserDefaults;

- (void)getHongBaoDict;

@end
