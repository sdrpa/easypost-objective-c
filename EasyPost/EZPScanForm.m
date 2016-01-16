
// Created by Sinisa Drpa, 2015.

#import "EZPScanForm.h"
#import "EZPRequest.h"
#import "EZPScanFormList.h"

#import "AFNetworking.h"

@implementation EZPScanForm

+ (void)list:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] GET:@"scan_forms"
                         parameters:parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPScanForm success:responseObject class:[EZPScanFormList class] completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

@end
