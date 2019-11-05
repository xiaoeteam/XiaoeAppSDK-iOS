//
//  UserModel.m
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)shared {
    static UserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[self alloc] init];
    });
    return userModel;
}

@end
