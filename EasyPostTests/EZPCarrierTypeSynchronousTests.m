
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPCarrierType+Synchronous.h"
#import "EZPConfiguration.h"

@interface EZPCarrierTypeSynchronousTests : XCTestCase

@end

@implementation EZPCarrierTypeSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

// REQUIRES kLiveSecretAPIKey
- (void)testAll {
   if (!kProductionEnviroment) {
      return;
   }
   NSArray *types = [EZPCarrierType list];
   XCTAssertNotEqual(0, types.count);
}

@end
