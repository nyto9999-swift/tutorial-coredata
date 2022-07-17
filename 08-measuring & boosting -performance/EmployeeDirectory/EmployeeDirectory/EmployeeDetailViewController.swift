import UIKit
import CoreData

class EmployeeDetailViewController: UIViewController {
  // MARK: - Properties
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter
  }()

  var employee: Employee?

  // MARK: IBOutlets
  @IBOutlet var headShotImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var departmentLabel: UILabel!
  @IBOutlet var emailLabel: UILabel!
  @IBOutlet var phoneNumberLabel: UILabel!
  @IBOutlet var startDateLabel: UILabel!
  @IBOutlet var vacationDaysLabel: UILabel!
  @IBOutlet var salesCountLabel: UILabel!
  @IBOutlet var bioTextView: UITextView!

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }

  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "SegueEmployeeDetailToEmployeePicture",
      let controller = segue.destination as? EmployeePictureViewController else {
        return
    }

    controller.employee = employee
  }
}

// MARK: Private
private extension EmployeeDetailViewController {
  func configureView() {
    guard let employee = employee else { return }

    title = employee.name

    if let picture = employee.pictureThumbnail {
      let image = UIImage(data: picture)
      headShotImageView.image = image
    }

    nameLabel.text = employee.name
    departmentLabel.text = employee.department
    emailLabel.text = employee.email
    phoneNumberLabel.text = employee.phone

    if let startDate = employee.startDate {
      startDateLabel.text = dateFormatter.string(from: startDate)
    }

    vacationDaysLabel.text = employee.vacationDays?.stringValue

    bioTextView.text = employee.about

    salesCountLabel.text = salesCountForEmployeeFast(employee)
  }
}

// MARK: Internal
extension EmployeeDetailViewController {
  func salesCountForEmployee(_ employee: Employee) -> String {
    let fetchRequest: NSFetchRequest<Sale> = Sale.fetchRequest()
    fetchRequest.predicate = NSPredicate(
      format: "%K = %@",
      argumentArray: [#keyPath(Sale.employee), employee]
    )

    let context = employee.managedObjectContext
    do {
      let results = try context?.fetch(fetchRequest)
      return "\(results?.count ?? 0)"
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
  
  func salesCountForEmployeeFast(_ employee: Employee) -> String {
    let fetchRequest: NSFetchRequest<Sale> = Sale.fetchRequest()
    fetchRequest.predicate = NSPredicate(
      format: "%K = %@",
      argumentArray: [#keyPath(Sale.employee), employee]
    )

    let context = employee.managedObjectContext
    do {
      let results = try context?.count(for: fetchRequest)
      return "\(results ?? 0)"
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
  
  func salesCountForEmployeeSimple(_ employee: Employee) -> String {
    "\(employee.sales?.count ?? 0)"
  }
  
}
