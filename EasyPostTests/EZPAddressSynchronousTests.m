
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPAddress+Synchronous.h"

@interface EZPAddressSynchronousTests : XCTestCase

@end

@implementation EZPAddressSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieve {
   NSDictionary *parameters = [[self toAddress] toDictionaryWithPrefix:@"address"];
   EZPAddress *address = [EZPAddress createAndVerify:parameters];
   XCTAssertNotNil(address.itemId);
   XCTAssertTrue([address.company isEqualToString:@"Simpler Postage Inc"]);
   XCTAssertNil(address.name);
   
   EZPAddress *retrieved = [EZPAddress retrieve:address.itemId];
   XCTAssertTrue([address.itemId isEqualToString:retrieved.itemId]);
}

- (void)testCreateInstance {
   EZPAddress *address = [self toAddress];
   [address create];
   XCTAssertNotNil(address.itemId);
}

- (void)testCreateAndVerify {
   NSDictionary *parameters = [[self toAddress] toDictionaryWithPrefix:@"address"];
   EZPAddress *address = [EZPAddress createAndVerify:parameters];
   XCTAssertNotNil(address.itemId);
   XCTAssertTrue([address.company isEqualToString:@"Simpler Postage Inc"]);
   XCTAssertNil(address.name);
}

- (void)testVerify {
   NSDictionary *parameters = [[self toAddress] toDictionaryWithPrefix:@"address"];
   EZPAddress *address = [EZPAddress create:parameters];
   [address verify:nil];
   XCTAssertNotNil(address.itemId);
   XCTAssertTrue([address.company isEqualToString:@"Simpler Postage Inc"]);
   XCTAssertNil(address.name);
   XCTAssertTrue(address.residential);
}

- (void)testVerifyCarrier {
   NSDictionary *parameters = [[self toAddress] toDictionaryWithPrefix:@"address"];
   EZPAddress *address = [EZPAddress create:parameters];
   [address verify:@"usps"];
   XCTAssertNotNil(address.itemId);
   XCTAssertTrue([address.company isEqualToString:@"Simpler Postage Inc"]);
   XCTAssertTrue([address.street1 isEqualToString:@"164 TOWNSEND ST"]);
   XCTAssertNil(address.name);
}

- (void)testVerifyBeforeCreate {
   EZPAddress *address = [self toAddress];
   [address verify:nil];
   XCTAssertNotNil(address.itemId);
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
