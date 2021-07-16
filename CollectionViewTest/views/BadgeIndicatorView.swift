import Foundation
import UIKit

final class BadgeIndicatorView: UIView {
    
    @IBOutlet private weak var circularProgressbarView: CircularProgressView!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var centerImageIcon: UIImageView!
    private var imageLinkAttributeCode = "ATT01_IMG_URL"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BadgeIndicatorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        backgroundImage.isHidden = true
        circularProgressbarView.isHidden = true
    }
    
    func setupBadgeIndicatorLayout(badge: Badge) {
        setupBadgeBackground(badge: badge)
        setupBadgeCenterIcon(badge: badge)
    }
    
    private func setupBadgeBackground(badge: Badge) {
        switch badgeStatus(badge) {
        case .statusCompleted:
            setupLayoutWithBackgroundImage()
        default:
            setupLayoutWithCircularProgressView(badge)
        }
    }
    
    private func setupBadgeCenterIcon(badge: Badge) {
        guard let imageLink = badge.attributes.first(where: { $0.code == imageLinkAttributeCode })?.value else { return }
        centerImageIcon.image = UIImage(systemName: "pencil.circle.fill")
        centerImageIcon.image = centerImageIcon.image?.withRenderingMode(.alwaysTemplate)
        centerImageIcon.tintColor = badgeStatus(badge).tintColor()
        
    }
    
    private func setupLayoutWithBackgroundImage() {
        backgroundImage.image = UIImage(named: "badgeCompleted")
        backgroundImage.isHidden = false
        circularProgressbarView.isHidden = true
    }
    
    private func setupLayoutWithCircularProgressView(_ badge: Badge) {
        let maxValue = badge.tracker.maxValue
        let currValue = badge.tracker.currValue
        circularProgressbarView.setupCircularProgressBarLayout(currentValue: currValue, maxValue: maxValue)
        circularProgressbarView.isHidden = false
        backgroundImage.isHidden = true
    }
    
    private func badgeStatus(_ badge: Badge) -> BadgeIndicatorStatus {
        let isAchieved = badge.achieved
        let maxValue = badge.tracker.maxValue
        let currValue = badge.tracker.currValue
        
        if isAchieved {
            return .statusCompleted
        } else if currValue > 0 && currValue < maxValue {
            return .statusInProgress
        }
        return .statusDefault
    }
}

enum BadgeIndicatorStatus {
    case statusCompleted
    case statusDefault
    case statusInProgress
    
    func tintColor() -> UIColor {
        switch self {
        case .statusDefault, .statusCompleted:
            return #colorLiteral(red: 0.2588235294, green: 0.1803921569, blue: 0.4392156863, alpha: 1)
        case .statusInProgress:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
