import CampgroundManager
import CoreData
import XCTest
import UIKit

class CamperServiceTest: XCTestCase {
  
  var camperService: CamperService!
  var coreDataStack: CoreDataStack!
  
  override func setUp() {
    super.setUp()
    coreDataStack = TestCoreDataStack()
    camperService = CamperService(
      managedObjectContext: coreDataStack.mainContext,
      coreDataStack: coreDataStack
    )
  }
  
  override func tearDown() {
    super.tearDown()
    coreDataStack = nil
    camperService = nil
  }
  
  func testAddCamper() {
    let camper = camperService.addCamper("Bacon Lover", phoneNumber: "910-543-9000")
    
    XCTAssertNotNil(camper, "Camper should not nill")
    XCTAssertTrue(camper?.fullName == "Bacon Lover")
    XCTAssertTrue(camper?.phoneNumber == "910-543-9000")
  }
    
  ///run on background thread
  func testRootContextIsSavedAfterAddingCamper() {
    
    let derivedContext = coreDataStack.newDerivedContext()
    camperService = CamperService(
      managedObjectContext: derivedContext,
      coreDataStack: coreDataStack)
 
    expectation(
      forNotification: .NSManagedObjectContextDidSave,
      object: coreDataStack.mainContext) { _ in
        return true
    }
 
    derivedContext.perform {
      let camper = self.camperService.addCamper(
        "Bacon Lover",
        phoneNumber: "910-543-9000")
      XCTAssertNotNil(camper)
    }

    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }

  
  
}
