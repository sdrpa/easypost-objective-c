
// Created by Sinisa Drpa, 2015.

#import "EZPScanForm.h"

@class EZPScanFormList;

@interface EZPScanForm (Synchronous)

+ (EZPScanFormList *)list:(NSDictionary *)parameters;

@end
