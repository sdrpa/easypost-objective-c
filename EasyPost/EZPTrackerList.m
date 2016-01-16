
// Created by Sinisa Drpa, 2015.

#import "EZPTrackerList.h"
#import "EZPTracker.h"

@implementation EZPTrackerList

+ (InCodeMappingProvider *)mappingProvider {
   InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
   NSDictionary *propertyMap = [EZPObject propertyMap];
   for (NSString *key in propertyMap) {
      [mappingProvider mapFromDictionaryKey:key toPropertyKey:propertyMap[key] forClass:[self class]];
   }
   
   [mappingProvider mapFromDictionaryKey:@"trackers" toPropertyKey:@"trackers"
                          withObjectType:[EZPTracker class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPTracker class]];
   
   return mappingProvider;
}

@end
