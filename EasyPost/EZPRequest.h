
// Created by Sinisa Drpa, 2015.

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperationManager;
@class AFHTTPSessionManager;

@interface EZPRequest : NSObject

+ (AFHTTPRequestOperationManager *)manager;

+ (AFHTTPSessionManager *)sessionManager;
+ (AFHTTPSessionManager *)liveSessionManager;

@end
