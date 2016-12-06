//
//  WXNetworkingAPI.h
//  WXJR
//
//  Created by liangpengshuai on 8/31/16.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WXNetworkingAPI : NSObject

+ (void)GET:(NSString *)URLString params:(NSMutableDictionary *)params completionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

+ (void)POST:(NSString *)URLString params:(NSDictionary *)params completionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

+ (void)POST:(NSString *)URLString params:(NSMutableDictionary *)params contentType:(NSString *)content completionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

@end
