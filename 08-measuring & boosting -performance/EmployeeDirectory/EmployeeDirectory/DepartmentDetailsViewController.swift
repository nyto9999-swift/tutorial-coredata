import UIKit
import CoreData

class DepartmentDetailsViewController: UIViewController {
  // MARK: Properties
  //swiftlint:disable:next implicitly_unwrapped_optional
  var coreDataStack: CoreDataStack!

  var department: String?

  // MARK: IBOutlets
  @IBOutlet var totalEmployeesLabel: UILabel!
  @IBOutlet var activeEmployeesLabel: UILabel!
  @IBOutlet var greaterThanFifteenVacationDaysLabel: UILabel!
  @IBOutlet var greaterThanTenVacationDaysLabel: UILabel!
  @IBOutlet var greaterThanFiveVacationDaysLabel: UILabel!
  @IBOutlet var greaterThanZeroVacationDaysLabel: UILabel!
  @IBOutlet var zeroVacationDaysLabel: UILabel!

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
}

// MARK: Internal
extension DepartmentDetailsViewController {
  func configureView() {
    guard let department = department else { return }

    title = department

    totalEmployeesLabel.text = totalEmployees(department)
    activeEmployeesLabel.text = activeEmployees(department)

    greaterThanFifteenVacationDaysLabel.text =
      greaterThanVacationDays(15, department: department)

    greaterThanTenVacationDaysLabel.text =
      greaterThanVacationDays(10, department: department)

    greaterThanFiveVacationDaysLabel.text =
      greaterThanVacationDays(5, department: department)

    greaterThanZeroVacationDaysLabel.text =
      greaterThanVacationDays(0, department: department)

    zeroVacationDaysLabel.text = zeroVacationDays(department)
  }

  func totalEmployees(_ department: String) -> String {
    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
    fetchRequest.predicate = NSPredicate(
      format: "%K = %@",
      argumentArray: [#keyPath(Employee.department), department]
    )

    do {
      let results = try coreDataStack.mainContext.fetch(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }

  func activeEmployees(_ department: String) -> String {
    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
    fetchRequest.predicate = NSPredicate(
      format: "%K = %@ AND %K = %@",
      argumentArray: [
        #keyPath(Employee.department),
        department,
        #keyPath(Employee.active),
        NSNumber(value: true)
      ]
    )

    do {
      let results = try coreDataStack.mainContext.fetch(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }

  func greaterThanVacationDays(_ vacationDays: Int, department: String) -> String {
    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
    fetchRequest.predicate = NSPredicate(
      format: "%K = %@ AND %K > %@",
      argumentArray: [
        #keyPath(Employee.department),
        department,
        #keyPath(Employee.vacationDays),
        NSNumber(value: vacationDays)
      ]
    )

    do {
      let results = try coreDataStack.mainContext.fetch(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }

  func zeroVacationDays(_ department: String) -> String {
    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
    fetchRequest.predicate = NSPredicate(
      format: "%K = %@ AND %K = 0",
      argumentArray: [
        #keyPath(Employee.department),
        department,
        #keyPath(Employee.vacationDays)
      ]
    )

    do {
      let results = try coreDataStack.mainContext.fetch(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
}
