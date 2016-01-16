
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPScanForm.h"
#import "EZPScanFormList.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPScanFormTests : XCTestCase

@end

@implementation EZPScanFormTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testList {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPScanForm list:nil completion:^(EZPScanFormList *scanFormList, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(scanFormList);
      for (EZPScanForm *form in [scanFormList scan_forms]) {
         XCTAssertNotNil(form);
      }
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

@end
