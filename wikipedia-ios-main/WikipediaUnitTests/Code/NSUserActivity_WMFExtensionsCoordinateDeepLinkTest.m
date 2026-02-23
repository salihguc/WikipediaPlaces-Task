#import <XCTest/XCTest.h>
#import "NSUserActivity+WMFExtensions.h"

@interface NSUserActivity_WMFExtensionsCoordinateDeepLinkTest: XCTestCase
@end

@implementation NSUserActivity_WMFExtensionsCoordinateDeepLinkTest

- (void)testPlacesURLWithCoordinates {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLatitude=52.3547&WMFLongitude=4.8339"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertTrue([activity wmf_hasCoordinate]);
    CLLocationCoordinate2D coord = [activity wmf_coordinate];
    XCTAssertEqual(coord.latitude, 52.3547);
    XCTAssertEqual(coord.longitude, 4.8339);
}

- (void)testPlacesURLWithNegativeCoordinates {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLatitude=-33.8688&WMFLongitude=-151.2093"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertTrue([activity wmf_hasCoordinate]);
    CLLocationCoordinate2D coord = [activity wmf_coordinate];
    XCTAssertEqual(coord.latitude, -33.8688);
    XCTAssertEqual(coord.longitude, -151.2093);
}

- (void)testPlacesURLWithArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFArticleURL=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FAmsterdam"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertFalse([activity wmf_hasCoordinate]);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Amsterdam");
}

- (void)testPlacesURLWithoutCoordinatesHasNoCoordinate {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertFalse([activity wmf_hasCoordinate]);
}

- (void)testPlacesURLWithOnlyLatHasNoCoordinate {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLatitude=52.3547"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertFalse([activity wmf_hasCoordinate]);
}

- (void)testPlacesURLWithOnlyLonHasNoCoordinate {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLongitude=4.8339"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertFalse([activity wmf_hasCoordinate]);
}

- (void)testPlacesURLWithInvalidLatNoCoordinate {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLatitude=91.0&WMFLongitude=4.8339"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertFalse([activity wmf_hasCoordinate]);
}

- (void)testPlacesURLWithInvalidLonNoCoordinate {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLatitude=52.3547&WMFLongitude=181.0"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertFalse([activity wmf_hasCoordinate]);
}

- (void)testPlacesURLWithBoundaryCoordinates {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLatitude=90.0&WMFLongitude=180.0"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertTrue([activity wmf_hasCoordinate]);
    CLLocationCoordinate2D coord = [activity wmf_coordinate];
    XCTAssertEqual(coord.latitude, 90.0);
    XCTAssertEqual(coord.longitude, 180.0);
}

- (void)testPlacesURLWithZeroCoordinates {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFLatitude=0&WMFLongitude=0"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertTrue([activity wmf_hasCoordinate]);
    CLLocationCoordinate2D coord = [activity wmf_coordinate];
    XCTAssertEqual(coord.latitude, 0.0);
    XCTAssertEqual(coord.longitude, 0.0);
}

- (void)testCoordinateOnActivityWithoutCoordinateReturnsInvalid {
    NSURL *url = [NSURL URLWithString:@"wikipedia://explore"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertFalse([activity wmf_hasCoordinate]);
    CLLocationCoordinate2D coord = [activity wmf_coordinate];
    XCTAssertFalse(CLLocationCoordinate2DIsValid(coord));
}

@end


