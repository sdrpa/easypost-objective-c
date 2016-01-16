
// Created by Sinisa Drpa, 2015.

#import "EZPScanFormList.h"
#import "EZPScanForm.h"

@implementation EZPScanFormList

+ (InCodeMappingProvider *)mappingProvider {
   InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
   NSDictionary *propertyMap = [EZPObject propertyMap];
   for (NSString *key in propertyMap) {
      [mappingProvider mapFromDictionaryKey:key toPropertyKey:propertyMap[key] forClass:[self class]];
   }
   
   [mappingProvider mapFromDictionaryKey:@"scan_forms" toPropertyKey:@"scan_forms"
                          withObjectType:[EZPScanForm class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPScanForm class]];
   
   return mappingProvider;
}

@end
