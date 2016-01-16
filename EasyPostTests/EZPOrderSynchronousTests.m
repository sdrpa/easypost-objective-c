
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPOrder+Synchronous.h"
#import "EZPShipment+Synchronous.h"
#import "EZPAddress+Synchronous.h"
#import "EZPParcel.h"
#import "EZPCarrierAccount.h"

@interface EZPOrderSynchronousTests : XCTestCase

@end

@implementation EZPOrderSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieveOrder {
   NSDictionary *parameters = [[self order] toDictionaryWithPrefix:@"order"];
   EZPOrder *order = [EZPOrder create:parameters];
   
   XCTAssertNotNil(order.itemId);
   XCTAssertTrue([order.reference isEqualToString:@"OrderRef"]);
   
   EZPOrder *retrieved = [EZPOrder retrieve:order.itemId];
   XCTAssertTrue([order.itemId isEqualToString:retrieved.itemId]);
}

// FAILS: Request failed: client error (422)? 
// "error": {
//   "code": "SHIPMENT.RATES.UNAVAILABLE",
//   "message": "Missing required data to get rates.",
//   "errors": []
// }
- (void)xtestCreateFromInstance {
   EZPOrder *order = [EZPOrder new];
   order.to_address = [EZPAddress create:[[self toAddress] toDictionaryWithPrefix:@"address"]];
   order.from_address = [EZPAddress create:[[self fromAddress] toDictionaryWithPrefix:@"address"]];
   order.reference = @"OrderRef",
   order.shipments = @[[EZPShipment create:[[self shipment] toDictionaryWithPrefix:@"shipment"]]];
   
   [order create];
   
   XCTAssertNotNil(order.itemId);
   XCTAssertTrue([order.reference isEqualToString:@"OrderRef"]);
}

- (void)testBuyOrder {
   NSDictionary *parameters = [[self order] toDictionaryWithPrefix:@"order"];
   EZPOrder *order = [EZPOrder create:parameters];
   [order buy:@"USPS" service:@"Priority"];
   
   XCTAssertNotNil(order.shipments[0].postage_label);
}

#pragma mark

- (EZPOrder *)order {
   EZPOrder *order = [EZPOrder new];
   order.to_address = [self toAddress];
   order.from_address = [self fromAddress];
   order.reference = @"OrderRef";
   order.shipments = @[[self shipment], [self shipment]];
   
   return order;
}

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
