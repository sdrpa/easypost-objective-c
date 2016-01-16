
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPRate+Synchronous.h"
#import "EZPShipment+Synchronous.h"
#import "EZPParcel+Synchronous.h"
#import "EZPAddress+Synchronous.h"

@interface EZPRateSynchronousTests : XCTestCase

@end

@implementation EZPRateSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testRetrieve {
   NSMutableDictionary *parameters = [[[self shipment] toDictionaryWithPrefix:@"shipment"] mutableCopy];
   parameters[@"shipment[carrier]"] = @"USPS";
   parameters[@"shipment[service]"] = @"Priority";
   
   EZPShipment *shipment = [EZPShipment create:parameters];
   [shipment fetchRates];
   EZPRate *rate = [EZPRate retrieve:shipment.rates[0].itemId];
   XCTAssertTrue([rate.itemId isEqualToString:shipment.rates[0].itemId]);
   
   XCTAssertNotNil(rate.rate);
   XCTAssertNotNil(rate.currency);
   XCTAssertNotNil(rate.list_rate);
   XCTAssertNotNil(rate.list_currency);
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
