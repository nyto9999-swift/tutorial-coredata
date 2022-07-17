 

import UIKit
import XCTest
@testable import EmployeeDirectory
import CoreData

class DepartmentDetailsViewControllerTests: XCTestCase {
  func testTotalEmployeesFetchPerformance() {
    measureMetrics(
      [.wallClockTime],
      automaticallyStartMeasuring: false
    ) {
      let departmentDetails = DepartmentDetailsViewController()
      departmentDetails.coreDataStack = CoreDataStack(modelName: "EmployeeDirectory")
      startMeasuring()
      _ = departmentDetails.totalEmployees("Engineering")
      stopMeasuring()
    }
  }
   
}
