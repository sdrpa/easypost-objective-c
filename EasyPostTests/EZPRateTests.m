
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPRate.h"
#import "EZPAddress.h"
#import "EZPShipment.h"
#import "EZPParcel.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPRateTests : XCTestCase

@end

@implementation EZPRateTests

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
   NSMutableDictionary *parameters = [[[self shipment] toDictionaryWithPrefix:@"shipment"] mutableCopy];
   parameters[@"shipment[carrier]"] = @"USPS";
   parameters[@"shipment[service]"] = @"Priority";
   
   [EZPShipment create:parameters completion:^(EZPShipment *shipment, NSError *error) {
      [shipment fetchRates:^(NSError *error) {
         [EZPRate retrieve:shipment.rates[0].itemId completion:^(EZPRate *rate, NSError *error) {
            XCTAssertTrue([rate.itemId isEqualToString:shipment.rates[0].itemId]);
            
            XCTAssertNotNil(rate.rate);
            XCTAssertNotNil(rate.currency);
            XCTAssertNotNil(rate.list_rate);
            XCTAssertNotNil(rate.list_currency);
            [expectation fulfill];
         }];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

#pragma mark

- (EZPShipment *)shipment {
   NSDictionary *parcelDictionary = @{@"length": @8,
                                      @"width": @6,
                                      @"height": @5,
                                      @"weight": @10};
   EZPParcel *parcel = [[EZPParcel alloc] initWithDictionary:parcelDictionary];
   
   EZPShipment *shipment = [EZPShipment new];
   shipment.from_address = [self fromAddress];
   shipment.to_address = [self toAddress];
   shipment.parcel = parcel;
   shipment.reference = @"ShipmentRef";
   
   return shipment;
}

- (EZPAddress *)toAddress {
   NSDictionary *toAddressDictionary = @{@"company": @"Simpler Postage Inc",
                                         @"street1": @"164 Townsend Street",
                                         @"street2": @"Unit 1",
                                         @"city": @"San Francisco",
                                         @"state": @"CA",
                                         @"country": @"US",
                                         @"zip": @"94107"};
   EZPAddress *toAddress = [[EZPAddress alloc] initWithDictionary:toAddressDictionary];
   XCTAssertNotNil(toAddress);
   return toAddress;
}

- (EZPAddress *)fromAddress {
   NSDictionary *fromAddressDictionary = @{@"name": @"Andrew Tribone",
                                           @"street1": @"480 Fell St",
                                           @"street2": @"#3",
                                           @"city": @"San Francisco",
                                           @"state": @"CA",
                                           @"country": @"US",
                                           @"zip": @"94102"};
   EZPAddress *fromAddress = [[EZPAddress alloc] initWithDictionary:fromAddressDictionary];
   XCTAssertNotNil(fromAddress);
   return fromAddress;
}

@end
