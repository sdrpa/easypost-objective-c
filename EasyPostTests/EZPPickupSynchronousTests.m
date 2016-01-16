
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPPickup+Synchronous.h"
#import "EZPShipment+Synchronous.h"
#import "EZPParcel+Synchronous.h"
#import "EZPAddress+Synchronous.h"
#import "EZPRate.h"

@interface EZPPickupSynchronousTests : XCTestCase

@end

@implementation EZPPickupSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieve {
   NSDictionary *parameters = [[self pickup] toDictionaryWithPrefix:@"pickup"];
   EZPPickup *pickup = [EZPPickup create:parameters];
   
   XCTAssertNotNil(pickup.itemId);
   XCTAssertTrue([pickup.address.street1 isEqualToString:@"164 Townsend Street"]);
   
   EZPPickup *retrieved = [EZPPickup retrieve:pickup.itemId];
   XCTAssertTrue([pickup.itemId isEqualToString:retrieved.itemId]);
}

// FAILS: messages": [{
// "carrier": "USPS",
// "type": "rate_error",
// "message": "Service availability unknown. serverError = 1012   serverMessage = More than one facility found for address."
// }],
- (void)xtestBuyAndCancel {
   NSDictionary *parameters = [[self pickup] toDictionaryWithPrefix:@"pickup"];
   EZPPickup *pickup = [EZPPickup create:parameters];
   
   [pickup buyWithCarrier:@"FEDEX" service:@"Same Day"];
   XCTAssertNotNil(pickup.confirmation);
   
   [pickup cancel];
   XCTAssertTrue([pickup.status isEqualToString:@"canceled"]);
}

#pragma mark

- (EZPPickup *)pickup {
   EZPPickup *pickup = [EZPPickup new];
   pickup.is_account_address = NO;
   pickup.address = [self toAddress];
   pickup.min_datetime = [NSDate date];
   pickup.max_datetime = [NSDate date];
   pickup.instructions = @"Special pickup instructions.";
   EZPShipment *shipment = [self shipment];
   [shipment create];
   [shipment buyWithRate:[shipment lowestRate]];

   pickup.shipment = shipment;
   
   return pickup;
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
                                         @"zip": @"94107",
                                         @"phone": @"1234567890"};
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
