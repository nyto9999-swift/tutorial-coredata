import UIKit
import CoreData

class ViewController: UIViewController {
  // MARK: - Properties
  private let filterViewControllerSegueIdentifier = "toFilterViewController"
  private let venueCellIdentifier = "VenueCell"
  
  lazy var coreDataStack = CoreDataStack(modelName: "BubbleTeaFinder")
  
  var fetchRequest: NSFetchRequest<Venue>?
  var venues: [Venue] = []
  
  /// it's a subclass of nspersistentsotrerequest
  var asyncFetchRequest: NSAsynchronousFetchRequest<Venue>?
  
  
  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    importJSONSeedDataIfNeeded()
    
    ///update your Core Data objects without loading them into memory
    let batchUpdate = NSBatchUpdateRequest(entityName: "Venue")
    batchUpdate.propertiesToUpdate = [#keyPath(Venue.favorite): true]
    
    batchUpdate.affectedStores = coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores
    batchUpdate.resultType = .updatedObjectsCountResultType
    do {
      let batchResult = try coreDataStack.managedContext.execute(batchUpdate) as? NSBatchUpdateResult
      print("Record updated \(String(describing: batchResult?.result))")
    } catch let error as NSError {
      print("Could not update \(error), \(error.userInfo)")
    }
    
    let venueFetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
    fetchRequest = venueFetchRequest
    
    asyncFetchRequest = NSAsynchronousFetchRequest<Venue>(fetchRequest: venueFetchRequest) { [unowned self] (result: NSAsynchronousFetchResult) in
      guard let venues = result.finalResult else { return }
      self.venues = venues
      self.tableView.reloadData()
    }
    
    do {
      guard let asyncFetchRequest = asyncFetchRequest else { return }
      try coreDataStack.managedContext.execute(asyncFetchRequest)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == filterViewControllerSegueIdentifier,
          let navController = segue.destination as? UINavigationController,
    let filterVC = navController.topViewController as? FilterViewController
    else { return }
    filterVC.coreDataStack = coreDataStack
    filterVC.delegate = self
  }
}

// MARK: - IBActions
extension ViewController {
  @IBAction func unwindToVenueListViewController(_ segue: UIStoryboardSegue) {
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    venues.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier, for: indexPath)
    let venue = venues[indexPath.row]
    cell.textLabel?.text = venue.name
    cell.detailTextLabel?.text = venue.priceInfo?.priceCategory
    return cell
  }
}

// MARK: - Data loading
extension ViewController {
  func importJSONSeedDataIfNeeded() {
    let fetchRequest = NSFetchRequest<Venue>(entityName: "Venue")
    
    do {
      let venueCount = try coreDataStack.managedContext.count(for: fetchRequest)
      guard venueCount == 0 else { return }
      try importJSONSeedData()
    } catch let error as NSError {
      print("Error fetching: \(error), \(error.userInfo)")
    }
  }
  
  func importJSONSeedData() throws {
    // swiftlint:disable:next force_unwrapping
    let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")!
    let jsonData = try Data(contentsOf: jsonURL)
    
    guard
      let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: [.fragmentsAllowed]) as? [String: Any],
      let responseDict = jsonDict["response"] as? [String: Any],
      let jsonArray = responseDict["venues"] as? [[String: Any]]
    else {
      return
    }
    
    for jsonDictionary in jsonArray {
      guard
        let contactDict = jsonDictionary["contact"] as? [String: String],
        let specialsDict = jsonDictionary["specials"] as? [String: Any],
        let locationDict = jsonDictionary["location"] as? [String: Any],
        let priceDict = jsonDictionary["price"] as? [String: Any],
        let statsDict = jsonDictionary["stats"] as? [String: Any]
      else {
        continue
      }
      
      let venueName = jsonDictionary["name"] as? String
      let venuePhone = contactDict["phone"]
      let specialCount = specialsDict["count"] as? Int32 ?? 0
      
      let location = Location(context: coreDataStack.managedContext)
      location.address = locationDict["address"] as? String
      location.city = locationDict["city"] as? String
      location.state = locationDict["state"] as? String
      location.zipcode = locationDict["postalCode"] as? String
      location.distance = locationDict["distance"] as? Float ?? 0
      
      let category = Category(context: coreDataStack.managedContext)
      
      let priceInfo = PriceInfo(context: coreDataStack.managedContext)
      priceInfo.priceCategory = priceDict["currency"] as? String
      
      let stats = Stats(context: coreDataStack.managedContext)
      stats.checkinsCount = statsDict["checkinsCount"] as? Int32 ?? 0
      stats.tipCount = statsDict["tipCount"] as? Int32 ?? 0
      
      let venue = Venue(context: coreDataStack.managedContext)
      venue.name = venueName
      venue.phone = venuePhone
      venue.specialCount = specialCount
      venue.location = location
      venue.category = category
      venue.priceInfo = priceInfo
      venue.stats = stats
    }
    
    coreDataStack.saveContext()
  }
}

//MARK: - Helper methods
extension ViewController {
  func fetchAndReload() {
    guard let fetchRequest = fetchRequest else { return }
    do {
      venues = try coreDataStack.managedContext.fetch(fetchRequest)
      tableView.reloadData()
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
}

extension ViewController: FilterViewControllerDelegate {
  func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
    
    guard let fetchRequest = fetchRequest else { return }
    fetchRequest.predicate = nil
    fetchRequest.sortDescriptors = nil
    fetchRequest.predicate = predicate
    
    if let sort = sortDescriptor {
      fetchRequest.sortDescriptors = [sort]
    }
    
    fetchAndReload()
  }
  
  
}
