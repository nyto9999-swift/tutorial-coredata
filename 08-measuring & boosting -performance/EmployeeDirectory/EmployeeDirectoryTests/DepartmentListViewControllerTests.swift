import UIKit
import XCTest
@testable import EmployeeDirectory

class DepartmentListViewControllerTests: XCTestCase {
  
  func testTotalEmployeesPerDepartment() {
    measureMetrics(
      [.wallClockTime],
      automaticallyStartMeasuring: false) {
        let departmentList = DepartmentListViewController()
        departmentList.coreDataStack = CoreDataStack(modelName: "EmployeeDirectory")
        startMeasuring()
        _ = departmentList.totalEmployeesPerDepartment()
        stopMeasuring()
      }
  }
  
  func testTotalEmployeesPerDepartmentFast() {
    measureMetrics(
      [.wallClockTime],
      automaticallyStartMeasuring: false
    ) {
      let departmentList = DepartmentListViewController()
      departmentList.coreDataStack = CoreDataStack(modelName: "EmployeeDirectory")
      
      startMeasuring()
      _ = departmentList.totalEmployeesPerDepartmentFast()
      stopMeasuring()
    }
  }
  
  
}
