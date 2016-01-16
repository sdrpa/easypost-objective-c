
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPPostageLabel : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (assign) NSUInteger date_advance;
@property (copy) NSString *integrated_form;
@property (strong) NSDate *label_date;
@property (assign) NSUInteger label_resolution;
@property (copy) NSString *label_size;
@property (copy) NSString *label_type;
@property (copy) NSString *label_url;
@property (copy) NSString *label_file_type;
@property (copy) NSString *label_pdf_url;
@property (copy) NSString *label_epl2_url;
@property (copy) NSString *label_zpl_url;
@property (copy) NSString *mode;

@end
