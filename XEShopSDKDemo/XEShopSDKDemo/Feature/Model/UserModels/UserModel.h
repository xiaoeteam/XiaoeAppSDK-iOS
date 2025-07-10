//
//  UserModel.h
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

//@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *token;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
