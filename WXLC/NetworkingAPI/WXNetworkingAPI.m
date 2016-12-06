//
//  WXNetworkingAPI.m
//  WXJR
//
//  Created by liangpengshuai on 8/31/16.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

#import "WXNetworkingAPI.h"


@implementation WXNetworkingAPI

+ (void)GET:(NSString *)URLString params:(NSMutableDictionary *)params completionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject success: %@", responseObject);
        completionBlock(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"responseObject failure: %@", error);
        completionBlock(nil, error);
    }];
    
}

+ (void)POST:(NSString *)URLString params:(NSDictionary *)params completionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject success: %@", responseObject);
        completionBlock(responseObject, nil);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"responseObject failure: %@", error);
        completionBlock(nil, error);

    }];
}

+ (void)POST:(NSString *)URLString params:(NSMutableDictionary *)params contentType:(NSString *)content completionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject success: %@", responseObject);
        completionBlock(responseObject, nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"responseObject failure: %@", error);
        completionBlock(nil, error);
        
    }];
}


@end
