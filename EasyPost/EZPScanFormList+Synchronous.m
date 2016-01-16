
// Created by Sinisa Drpa, 2015.

#import "EZPScanFormList+Synchronous.h"
#import "EZPScanForm+Synchronous.h"

@implementation EZPScanFormList (Synchronous)

/**
 * Get the next page of scan forms based on the original parameters passed to ScanForm.List()
 */
- (EZPScanFormList *)next {
      self.filters = self.filters ? self.filters : [NSMutableDictionary dictionary];
      self.filters[@"before_id"] = [self.scan_forms lastObject].itemId;
      
      return [EZPScanForm list:self.filters];
}

@end
