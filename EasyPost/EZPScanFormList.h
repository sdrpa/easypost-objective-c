
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPScanForm;

@interface EZPScanFormList : EZPObject

@property (strong) NSArray<EZPScanForm *> *scan_forms;
@property (assign) BOOL has_more;

@property (strong) NSMutableDictionary *filters;

@end
