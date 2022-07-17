import UIKit
import CoreData

public class EmployeePicture: NSManagedObject {
  
}

extension EmployeePicture {
  
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<EmployeePicture> {
    return NSFetchRequest<EmployeePicture>(entityName: "EmployeePicture")
  }
  
  @NSManaged public var picture: Data?
  @NSManaged public var employee: Employee?
}
