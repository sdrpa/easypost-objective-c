
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPCarrierType.h"
#import "EZPConfiguration.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPCarrierTypeTests : XCTestCase

@end

@implementation EZPCarrierTypeTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

// REQUIRES kLiveSecretAPIKey
- (void)testRetrieve {
   if (!kProductionEnviroment) {
      return;
   }
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPCarrierType list:^(NSArray *carrierTypes, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(carrierTypes);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

@end
