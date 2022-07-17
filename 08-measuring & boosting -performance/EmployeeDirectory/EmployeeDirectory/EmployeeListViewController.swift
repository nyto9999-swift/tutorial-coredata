
import UIKit
import CoreData

class EmployeeListViewController: UITableViewController {
  // MARK: - Properties
  //swiftlint:disable:next implicitly_unwrapped_optional
  var coreDataStack: CoreDataStack!

  var fetchedResultController: NSFetchedResultsController<Employee> = NSFetchedResultsController()

  var department: String?

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "SegueEmployeeListToDetail",
      let indexPath = tableView.indexPathForSelectedRow,
      let controller = segue.destination as? EmployeeDetailViewController else {
        return
    }

    let selectedEmployee = fetchedResultController.object(at: indexPath)
    controller.employee = selectedEmployee
  }
}

// MARK: - Private
private extension EmployeeListViewController {
  func configureView() {
    fetchedResultController = employeesFetchedResultControllerFor(department)
  }
}

// MARK: - NSFetchedResultsController
extension EmployeeListViewController {
  func employeesFetchedResultControllerFor(_ department: String?) -> NSFetchedResultsController<Employee> {
    fetchedResultController = NSFetchedResultsController(
      fetchRequest: employeeFetchRequest(department),
      managedObjectContext: coreDataStack.mainContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchedResultController.delegate = self
    do {
      try fetchedResultController.performFetch()
      return fetchedResultController
    } catch let error as NSError {
      fatalError("Error: \(error.localizedDescription)")
    }
  }

  func employeeFetchRequest(_ department: String?) -> NSFetchRequest<Employee> {
    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
    fetchRequest.fetchBatchSize = 10

    let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    guard let department = department else {
      return fetchRequest
    }

    fetchRequest.predicate = NSPredicate(
      format: "%K = %@",
      argumentArray: [#keyPath(Employee.department), department]
    )

    return fetchRequest
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension EmployeeListViewController: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension EmployeeListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    fetchedResultController.sections?.count ?? 0
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    fetchedResultController.sections?[section].numberOfObjects ?? 0
  }

  //swiftlint:disable force_cast
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = "EmployeeCellReuseIdentifier"
    let cell = tableView.dequeueReusableCell(
      withIdentifier: reuseIdentifier,
      for: indexPath) as! EmployeeTableViewCell

    let employee = fetchedResultController.object(at: indexPath)

    cell.nameLabel.text = employee.name
    cell.departmentLabel.text = employee.department
    cell.emailLabel.text = employee.email
    cell.phoneNumberLabel.text = employee.phone
    if let picture = employee.pictureThumbnail {
      cell.pictureImageView.image = UIImage(data: picture)
    }

    return cell
  }
  //swiftlint:enable force_cast
}
