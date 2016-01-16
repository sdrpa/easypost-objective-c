
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPTracker+Synchronous.h"
#import "EZPTrackerList+Synchronous.h"

@interface EZPTrackerSynchronousTests : XCTestCase

@end

@implementation EZPTrackerSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieve {
   EZPTracker *tracker = [EZPTracker create:@"USPS" trackingCode:@"EZ1000000001"];
   XCTAssertTrue([[tracker tracking_code] isEqualToString:@"EZ1000000001"]);
   XCTAssertNotNil(tracker.est_delivery_date);
   XCTAssertNotNil(tracker.carrier);
   
   EZPTracker *retrieved = [EZPTracker retrieve:tracker.itemId];
   XCTAssertTrue([retrieved.itemId isEqualToString:tracker.itemId]);
}

- (void)testList {
   EZPTrackerList *trackerList = [EZPTracker list:nil];
   XCTAssertNotEqual(0, trackerList.trackers.count);
   
   EZPTrackerList *nextTrackerList = [trackerList next];
   XCTAssertNotEqual(trackerList.trackers[0].itemId, nextTrackerList.trackers[0].itemId);
}

@end
