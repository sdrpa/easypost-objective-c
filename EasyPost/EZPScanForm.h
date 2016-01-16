
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPAddress;

@interface EZPScanForm : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (strong) NSArray <NSString *> *tracking_codes;
@property (strong) EZPAddress *address;
@property (copy) NSString *form_url;
@property (copy) NSString *form_file_type;
@property (copy) NSString *mode;
@property (copy) NSString *status;
@property (copy) NSString *message;

+ (void)list:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;

@end
