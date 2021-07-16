import UIKit

class MissionDescriptionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var badgeName: UILabel!
    @IBOutlet weak var badgeIndicatorView: BadgeIndicatorView!
    @IBOutlet weak var badgeDescription: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var categoryName: UILabel!
    
    var badge: Badge?
    private lazy var viewModel: MissionDescriptionViewModel? = {
        guard let badge = self.badge else { return nil}
        return MissionDescriptionViewModel(badge: badge)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupUI(badgeName: badgeName,
                           badgeIndicatorView: badgeIndicatorView,
                           badgeDescription: badgeDescription,
                           callToActionButton: callToActionButton,
                           categoryName: categoryName)
    }
    
    // MARK: - Actions
    @IBAction func buttonBackTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MissionDescriptionViewController: StoryboardInstantiable {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Missions", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "MissionDescriptionViewController") as? Self {
            return viewController
        } else {
            return Self()
        }
    }
}
