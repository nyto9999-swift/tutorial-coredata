import UIKit

class EmployeePictureViewController: UIViewController {
  // MARK: - Properties
  var employee: Employee?

  // MARK: - IBOutlets
  @IBOutlet var employeePictureImageView: UIImageView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }
}

// MARK: - IBActions
extension EmployeePictureViewController {
  @IBAction func userTappedPicture(_ sender: UITapGestureRecognizer) {
    dismiss(animated: true)
  }
}

// MARK: - Private
private extension EmployeePictureViewController {
  func configureView() {
    guard let employeePicture = employee?.picture?.picture else {
      return
    }

    employeePictureImageView.image = UIImage(data: employeePicture)
  }
}
