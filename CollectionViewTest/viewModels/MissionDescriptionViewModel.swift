import Foundation
import UIKit

final class MissionDescriptionViewModel {
    
    private var badge: Badge
    private let callToActionCode = "Call_To_Action"
    
    init(badge: Badge) {
        self.badge = badge
    }
    
    func setupUI(badgeName: UILabel,
                 badgeIndicatorView: BadgeIndicatorView,
                 badgeDescription: UILabel,
                 callToActionButton: UIButton,
                 categoryName: UILabel) {
        
        badgeName.text = badge.name
        badgeIndicatorView.setupBadgeIndicatorLayout(badge: badge)
        badgeDescription.text = badge.description
        categoryName.text = badge.category.name
        setupCallToActionButton(callToActionButton: callToActionButton)
    }
    
    private func setupCallToActionButton(callToActionButton: UIButton) {
        guard let buttonTitle = badge.attributes.first(where: { $0.code == callToActionCode })?.value else {
            callToActionButton.isHidden = true
            return
        }
        callToActionButton.isEnabled = false
        callToActionButton.setTitle(buttonTitle, for: .normal)
        callToActionButton.alpha = 0.5
    }
}
