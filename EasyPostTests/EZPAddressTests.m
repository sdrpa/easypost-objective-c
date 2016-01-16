
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPAddress.h"

static CGFloat const kRequestTimeout = 15.0;

@interface EZPAddressTests : XCTestCase

@end

@implementation EZPAddressTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testRetrieve {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPAddress retrieve:@"adr_b782a5c1b5af405cb7b4ee15c3ca15cb" completion:^(EZPAddress *address, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(address);
      //XCTAssertTrue([[address itemId] isEqualToString:@"adr_b782a5c1b5af405cb7b4ee15c3ca15cb"]);
      XCTAssertTrue([[address name] isEqualToString:@"Dr. Steve Brule"]);
      XCTAssertTrue([[address street1] isEqualToString:@"179 N Harbor Dr"]);
      XCTAssertTrue([[address city] isEqualToString:@"Redondo Beach"]);
      XCTAssertTrue([[address state] isEqualToString:@"CA"]);
      XCTAssertTrue([[address zip] isEqualToString:@"90277"]);
      XCTAssertTrue([[address email] isEqualToString:@"dr_steve_brule@gmail.com"]);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testCreate {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = @{@"address[name]": @"Dr. Steve Brule",
                                @"address[street1]": @"179 N Harbor Dr",
                                @"address[city]": @"Redondo Beach",
                                @"address[state]": @"CA",
                                @"address[zip]": @"90277",
                                @"address[country]": @"US",
                                @"address[email]": @"dr_steve_brule@gmail.com"
                                };
   [EZPAddress create:parameters completion:^(EZPAddress *address, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(address);
      XCTAssertTrue([[address name] isEqualToString:@"Dr. Steve Brule"]);
      XCTAssertTrue([[address street1] isEqualToString:@"179 N Harbor Dr"]);
      XCTAssertTrue([[address city] isEqualToString:@"Redondo Beach"]);
      XCTAssertTrue([[address state] isEqualToString:@"CA"]);
      XCTAssertTrue([[address zip] isEqualToString:@"90277"]);
      XCTAssertTrue([[address email] isEqualToString:@"dr_steve_brule@gmail.com"]);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testCreateInstance {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   EZPAddress *address = [self toAddress];
   [address create:^(EZPAddress *address, NSError *error) {
      XCTAssertNotNil(address.itemId);
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testVerifyRetrievedAddress {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPAddress retrieve:@"adr_b782a5c1b5af405cb7b4ee15c3ca15cb" completion:^(EZPAddress *address, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      [address verify:nil completion:^(EZPAddress *address, NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         XCTAssertNotNil(address);
         XCTAssertTrue([[address name] caseInsensitiveCompare:@"Dr. Steve Brule"] == NSOrderedSame);
         XCTAssertTrue([[address street1] caseInsensitiveCompare:@"179 N Harbor Dr"] == NSOrderedSame);
         XCTAssertTrue([[address city] caseInsensitiveCompare:@"Redondo Beach"] == NSOrderedSame);
         XCTAssertTrue([[address state] caseInsensitiveCompare:@"CA"] == NSOrderedSame);
         XCTAssertTrue([[address email] caseInsensitiveCompare:@"dr_steve_brule@gmail.com"] == NSOrderedSame);
         
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testCreateAndVerify {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = @{@"name": @"Dr. Steve Brule",
                                @"street1": @"179 N Harbor Dr",
                                @"city": @"Redondo Beach",
                                @"state": @"CA",
                                @"zip": @"90277",
                                @"country": @"US",
                                @"email": @"dr_steve_brule@gmail.com"
                                };
   EZPAddress *address = [[EZPAddress alloc] initWithDictionary:parameters];
   [address verify:nil completion:^(EZPAddress *address, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(address);
      XCTAssertTrue([[address name] caseInsensitiveCompare:@"Dr. Steve Brule"] == NSOrderedSame);
      XCTAssertTrue([[address street1] caseInsensitiveCompare:@"179 N Harbor Dr"] == NSOrderedSame);
      XCTAssertTrue([[address city] caseInsensitiveCompare:@"Redondo Beach"] == NSOrderedSame);
      XCTAssertTrue([[address state] caseInsensitiveCompare:@"CA"] == NSOrderedSame);
      XCTAssertTrue([[address email] caseInsensitiveCompare:@"dr_steve_brule@gmail.com"] == NSOrderedSame);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testCreateAndVerify2 {
   NSDictionary *parameters;
   // You can use either
   //parameters = [[self toAddress] toDictionaryWithPrefix:@"address"];
   // or
   parameters = @{@"address[company]": @"Simpler Postage Inc",
                  @"address[street1]": @"164 Townsend Street",
                  @"address[street2]": @"Unit 1",
                  @"address[city]": @"San Francisco",
                  @"address[state]": @"CA",
                  @"address[country]": @"US",
                  @"address[zip]": @"94107"};
   [EZPAddress createAndVerify:parameters completion:^(EZPAddress *address, NSError *error) {
      XCTAssertNotNil(address.itemId);
      XCTAssertTrue([address.company isEqualToString:@"Simpler Postage Inc"]);
      XCTAssertNil(address.name);
   }];
}

- (void)testVerifyCarrier {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = [[self toAddress] toDictionaryWithPrefix:@"address"];
   [EZPAddress create:parameters completion:^(EZPAddress *address, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      [address verify:@"usps" completion:^(EZPAddress *address, NSError *error) {
         XCTAssertNotNil(address.itemId);
         XCTAssertTrue([address.company isEqualToString:@"Simpler Postage Inc"]);
         XCTAssertTrue([address.street1 isEqualToString:@"164 Townsend Street"]);
         XCTAssertNil(address.name);
         
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testVerifyBeforeCreate {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   EZPAddress *address = [self toAddress];
   [address verify:nil completion:^(EZPAddress *address, NSError *error) {
      XCTAssertNotNil(address.itemId);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

#pragma mark

- (EZPAddress *)toAddress {
    NSDictionary *toAddressDictionary = @{@"company": @"Simpler Postage Inc",
                                          @"street1": @"164 Townsend Street",
                                          @"street2": @"Unit 1",
                                          @"city": @"San Francisco",
                                          @"state": @"CA",
                                          @"country": @"US",
                                          @"zip": @"94107",
                                          @"residential": @YES};
    EZPAddress *toAddress = [[EZPAddress alloc] initWithDictionary:toAddressDictionary];
    XCTAssertNotNil(toAddress);
    return toAddress;
}

@end
