
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPCustomsInfo.h"
#import "EZPCustomsItem.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPCustomsInfoTests : XCTestCase

@end

@implementation EZPCustomsInfoTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

// FAILS: {"error":{"code":"INTERNAL_SERVER_ERROR","message":"We're sorry, something went wrong. If the problem persists please contact us at support@easypost.com.","errors":[]}}
// Sent email to tech support, got response: "The issue is that cstitem_LeWfJAV4 does not exist. I'll fix the issue on our end, sorry for the confusion."
- (void)xtestCreate {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = @{@"customs_info[customs_certify]": @"true",
                                @"customs_info[customs_signer]": @"Steve Brule",
                                @"customs_info[contents_type]": @"merchandise",
                                @"customs_info[contents_explanation]": @"",
                                @"customs_info[restriction_type]": @"none",
                                @"customs_info[eel_pfc]": @"NOEEI 30.37(a)",
                                @"customs_info[customs_items][0][id]": @"cstitem_LeWfJAV4",
                                @"customs_info[customs_items][1][description]": @"Sweet shirts",
                                @"customs_info[customs_items][1][quantity]": @"2",
                                @"customs_info[customs_items][1][value]": @"23",
                                @"customs_info[customs_items][1][weight]": @"11",
                                @"customs_info[customs_items][1][hs_tariff_number]": @"654321",
                                @"customs_info[customs_items][1][origin_country]": @"US"
                                };
   [EZPCustomsInfo create:parameters completion:^(EZPCustomsInfo *item, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(item);
      XCTAssertTrue([[item customs_signer] isEqualToString:@"Steve Brule"]);
      XCTAssertTrue([[[[item customs_items] firstObject] origin_country] isEqualToString:@"US"]);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

@end
