import UIKit
import CoreData

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var people: [NSManagedObject] = []
   
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "The List"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    ///Also note NSFetchRequest is a generic type. This use of generics specifies a fetch request’s expected return type, in this case NSManagedObject.
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    
    do {
      people = try managedContext.fetch(fetchRequest)
    }
    catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

  }
  
  @IBAction func addName(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "New Name",
                                  message: "Add a new name",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) {
      [unowned self] action in
      
      guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
        return
      }
      
      self.save(name: nameToSave)
      self.tableView.reloadData()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  func save(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
    let person = NSManagedObject(entity: entity, insertInto: managedContext)
    person.setValue(name, forKey: "name")
    
    do {
      try managedContext.save()
      people.append(person)
    }
    catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }

  }
  
}
extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let person = people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    return cell
  }
}


