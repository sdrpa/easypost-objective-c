
// Created by Sinisa Drpa, 2015.

#import "EZPTracker+Synchronous.h"
#import "EZPObject+Synchronous.h"
#import "EZPTrackerList.h"
#import "EZPRequest.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPTracker (Synchronous)

/**
 * Get list of trackers
 */
+ (EZPTrackerList *)list:(NSDictionary *)parameters {
   NSError *error;
   NSDictionary *response = [[EZPRequest manager] syncGET:@"trackers"
                                               parameters:parameters
                                                operation:nil
                                                    error:&error];
   if (error) {
      NSAssert(false, [error localizedDescription]);
   }
   EZPTrackerList *trackerList = error ? nil: [EZPTrackerList resultObjectWithResponse:response];
   trackerList.filters = [parameters mutableCopy];
   return trackerList;
}

/**
 * Create a tracker
 */
+ (EZPTracker *)create:(NSString *)carrier trackingCode:(NSString *)trackingCode {
   NSDictionary *parameters = @{@"tracker[tracking_code]": trackingCode,
                                @"tracker[carrier]": carrier};
   return [self POST:@"trackers" parameters:parameters];
}

/**
 * Retrieve a Tracker from its id
 */
+ (EZPTracker *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"trackers/%@", itemId]
         parameters:nil];
}

@end
