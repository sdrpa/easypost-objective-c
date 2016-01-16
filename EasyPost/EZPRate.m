
// Created by Sinisa Drpa, 2015.

#import "EZPRate.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPRate

/**
 * Retrieve rates
 */
//+ (void)retrieve:(EZPRequestCompletion)completion {
//   [[EZPRequest sessionManager] GET:@"rates"
//                         parameters:nil
//                            success:^(NSURLSessionDataTask *task, id responseObject) {
//                               [EZPRate success:responseObject completion:completion];
//                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                               completion(nil, error);
//                            }];
//}

/**
 * Retrieve a Rate from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"rates/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPRate success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

#pragma mark

- (BOOL)isEqualToRate:(EZPRate *)rate {
   if (!rate) {
      return NO;
   }
   
   BOOL haveEqualServise = (!self.service && !rate.service) || [self.service isEqualToString:rate.service];
   BOOL haveEqualCarrier = (!self.carrier && !rate.carrier) || [self.carrier isEqualToString:rate.carrier];
   BOOL haveEqualRate    = (!self.rate && !rate.rate) || [self.rate isEqualToString:rate.rate];
   
   return haveEqualServise && haveEqualCarrier && haveEqualRate;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
   if (self == object) {
      return YES;
   }
   
   if (![object isKindOfClass:[EZPRate class]]) {
      return NO;
   }
   
   return [self isEqualToRate:(EZPRate *)object];
}

- (NSUInteger)hash {
   return [self.service hash] ^ [self.carrier hash] ^ [self.rate hash];
}

@end
