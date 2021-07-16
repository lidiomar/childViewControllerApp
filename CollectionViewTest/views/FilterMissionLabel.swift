import Foundation
import UIKit

final class FilterMissionLabel: UILabel {
    
    private let labelBrandPrimaryMedium: UIColor = .orange
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        setupButtonState(state: .unselected)
    }
    
    func setupButtonState(state: FilterMissionLabelState) {
        setupBackgroundColor(state: state)
        setupBorderStyle(state: state)
        setupTextColor(state: state)
    }
    
    private func setupTextColor(state: FilterMissionLabelState) {
        switch state {
        case .unselected:
            self.textColor = labelBrandPrimaryMedium
        case .selected:
            self.textColor = .white
        }
    }
    
    private func setupBorderStyle(state: FilterMissionLabelState) {
        switch state {
        case .unselected:
            self.layer.borderColor = labelBrandPrimaryMedium.cgColor
            self.layer.borderWidth = 1.0
        case .selected:
            self.layer.borderWidth = 0
        }
    }
    
    private func setupBackgroundColor(state: FilterMissionLabelState) {
        switch state {
        case .unselected:
            self.backgroundColor = .white
        case .selected:
            self.backgroundColor = labelBrandPrimaryMedium
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += 32
        contentSize.width += 32
        return contentSize
    }
}

enum FilterMissionLabelState: Int {
    case selected, unselected
}
