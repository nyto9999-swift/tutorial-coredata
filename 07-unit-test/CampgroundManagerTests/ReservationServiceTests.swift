import CoreData
import CampgroundManager
import UIKit
import XCTest

class ReservationServiceTests: XCTestCase {
  var campSiteService: CampSiteService!
  var camperService: CamperService!
  var reservationService: ReservationService!
  var coreDataStack: CoreDataStack!
  
  override func setUp() {
    super.setUp()
    coreDataStack = TestCoreDataStack()
    camperService = CamperService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    campSiteService = CampSiteService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    reservationService = ReservationService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
  }
  
  override func tearDown() {
    super.tearDown()
    camperService = nil
    campSiteService = nil
    reservationService = nil
    coreDataStack = nil
  }
  
  func testReserveCampSiteNegativeNumberOfDays() {
    let camper = camperService.addCamper(
      "Johnny Appleseed",
      phoneNumber: "408-555-1234")!
    let campSite = campSiteService.addCampSite(
      15,
      electricity: false,
      water: false)

    let result = reservationService!.reserveCampSite(
      campSite,
      camper: camper,
      date: Date(),
      numberOfNights: -1)

    XCTAssertNotNil(
      result.reservation,
      "Reservation should not be nil")
    XCTAssertNotNil(
      result.error,
      "An error should be present")
    XCTAssertTrue(
      result.error?.userInfo["Problem"] as? String == "Invalid number of days",
      "Error problem should be present")
    XCTAssertTrue(
      result.reservation?.status == "Invalid",
      "Status should be Invalid")
  }

}
