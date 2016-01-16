
// Created by Sinisa Drpa, 2015.

#import "EZPScanForm+Synchronous.h"
#import "EZPScanFormList.h"
#import "EZPRequest.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPScanForm (Synchronous)

/**
 * Get list of shipments
 */
+ (EZPScanFormList *)list:(NSDictionary *)parameters {
   NSError *error;
   NSDictionary *response = [[EZPRequest manager] syncGET:@"scan_forms"
                                               parameters:parameters
                                                operation:nil
                                                    error:&error];
   if (error) {
      NSAssert(false, [error localizedDescription]);
   }
   EZPScanFormList *scanFormList = error ? nil: [EZPScanFormList resultObjectWithResponse:response];
   scanFormList.filters = [parameters mutableCopy];
   return scanFormList;
}

@end
