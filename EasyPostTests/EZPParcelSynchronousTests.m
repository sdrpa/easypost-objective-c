
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPParcel+Synchronous.h"
#import "EZPShipment+Synchronous.h"

@interface EZPParcelSynchronousTests : XCTestCase

@end

@implementation EZPParcelSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieve {
   EZPParcel *parcel = [EZPParcel create:[self parameters]];
   
   EZPParcel *retrieved = [EZPParcel retrieve:parcel.itemId];
   XCTAssertTrue([parcel.itemId isEqualToString:retrieved.itemId]);
}

- (void)testPredefinedPackage {
   EZPParcel *parcel = [EZPParcel new];
   parcel.weight = 1.8;
   parcel.length = 2.0;
   parcel.width = 3.0;
   parcel.height = 4.0;
   parcel.predefined_package = @"SMALLFLATRATEBOX";
   
   EZPShipment *shipment = [EZPShipment new];
   shipment.parcel = parcel;
   [shipment create];
   
   XCTAssertEqual(4.0, shipment.parcel.height);
   XCTAssertTrue([@"SMALLFLATRATEBOX" isEqualToString:shipment.parcel.predefined_package]);
}

#pragma mark

- (NSDictionary *)parameters {
   NSDictionary *parameters = @{@"parcel[length]": @20.2,
                                @"parcel[width]": @10.9,
                                @"parcel[height]": @5,
                                @"parcel[weight]": @65.9
                                };
   return parameters;
}

@end
