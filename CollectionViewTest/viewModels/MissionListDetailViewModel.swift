import Foundation
import UIKit

final class MissionListDetailViewModel {
    
    private let defaultCategoryIndex = 0
    private let defaultCategoryName = "Todas"
    private var missionDetailFilters: [MissionListDetailFilter] = []
    private var defaultCategoryCodes: [String] = []
    private var loyaltyCategories: [LoyaltyCategory]
    private var badges: [Badge]
    private var badgesDictionary: [String: [Badge]] = [:]
    private var filteredBadgesDictionary: [String: [Badge]] = [:]
    
    init(loyaltyCategories: [LoyaltyCategory],
         badges: [Badge]) {
        
        self.badges = badges
        self.loyaltyCategories = loyaltyCategories
        setupData()
    }
    
    private func setupData() {
        loyaltyCategories.forEach { defaultCategoryCodes.append($0.code)}
        prepareMissionListDetailFilterData()
        prepareBadgesData()
        filterByAllCategories()
    }
    
    // MARK: Categories
    
    func numberOfCategories() -> Int {
        if isDefaultCategorySelected() {
            return missionDetailFiltersCount()-1
        }
        return selectedFilterIndexes().count
    }
    
    func missionDetailFiltersCount() -> Int {
        return missionDetailFilters.count
    }
    
    func updateMissionDetailFilterState(index: Int, isSelected: Bool) {
        missionDetailFilters[index].isSelected = isSelected
    }
    
    func updateFilterLabelUI(label: FilterMissionLabel, state: FilterMissionLabelState) {
        label.setupButtonState(state: state)
    }
    
    func updateMissionDetailFilterUI(label: FilterMissionLabel, index: Int) {
        label.text = missionDetailFilters[index].category.name
        if missionDetailFilters[index].isSelected {
            label.setupButtonState(state: .selected)
        } else {
            label.setupButtonState(state: .unselected)
        }
    }
    
    func deSelectAllButItem(itemIndex: Int) {
        for index in 0..<missionDetailFiltersCount() where index != itemIndex {
            updateMissionDetailFilterState(index: index, isSelected: false)
        }
    }
    
    func deSelectItemAt(itemIndex: Int) {
        updateMissionDetailFilterState(index: itemIndex, isSelected: false)
    }
    
    private func filterMissionDetailSelected() -> [MissionListDetailFilter] {
        return missionDetailFilters.filter { $0.isSelected }
    }
    
    private func prepareMissionListDetailFilterData() {
        var filteredCategories = loyaltyCategories.sorted(by: { $0.displayPriority < $1.displayPriority })
        let defaultCategory = LoyaltyCategory(code: "", name: defaultCategoryName, displayPriority: -1)
        filteredCategories.insert(defaultCategory, at: defaultCategoryIndex)
        
        filteredCategories.forEach { category in
            missionDetailFilters.append(MissionListDetailFilter(category: category, isSelected: false))
        }
    }
    
    // MARK: Badges
    
    func updateBadgeItemUI(indexPath: IndexPath,
                           badgeNameLabel: UILabel,
                           badgeIndicator: BadgeIndicatorView) {
        
        let badge = badgeAt(section: indexPath.section, index: indexPath.row)
        badgeNameLabel.text = badge.name
        badgeIndicator.setupBadgeIndicatorLayout(badge: badge)
    }
    
    func numberOfBadges() -> Int {
        if isDefaultCategorySelected() {
            return badges.count
        }
        var count = 0
        filteredBadgesDictionary.forEach { count = count + $0.value.count }
        return count
    }
    
    func badgesCountInSection(_ section: Int) -> Int {
        if isDefaultCategorySelected() {
            let categoryCode = defaultCategoryCodes[section]
            return filteredBadgesDictionary[categoryCode]?.count ?? 0
        }
        
        let filtered = filterMissionDetailSelected()
        let categoryCode = filtered[section].category.code
        return filteredBadgesDictionary[categoryCode]?.count ?? 0
    }
    
    func badgeAt(section: Int, index: Int) -> Badge {
        var categoryCode = ""
        if isDefaultCategorySelected() {
            categoryCode = defaultCategoryCodes[section]
        } else {
            let filtered = filterMissionDetailSelected()
            categoryCode = filtered[section].category.code
        }
        
        let badges = filteredBadgesDictionary[categoryCode]
        let badge = badges?[index]
        return badge!
    }
    
    func filter() {
        if isDefaultCategorySelected() {
            filterByAllCategories()
        } else {
            filterBySelectedCategories()
        }
    }
    
    func selectedFilterCount() -> Int {
        if isDefaultCategorySelected() {
            return missionDetailFiltersCount()-1
        } else {
            return selectedFilterIndexes().count
        }
    }
    
    func loyaltyCategoryNameBy(section: Int) -> String {
        if isDefaultCategorySelected() {
            return loyaltyCategories[section].name
        }
        let filtered = filterMissionDetailSelected()
        return filtered[section].category.name
    }
    
    private func selectedFilterIndexes() -> [Int] {
        var categoriesIndexes: [Int] = []
        for index in 0..<missionDetailFilters.count where missionDetailFilters[index].isSelected {
            categoriesIndexes.append(index)
        }
        return categoriesIndexes
    }
    
    private func filterByAllCategories() {
        filteredBadgesDictionary = filterBadgesBy(categoryCodes: defaultCategoryCodes)
    }
    
    private func filterBySelectedCategories() {
        let categoriesIndex = selectedFilterIndexes()
        var codes: [String] = []
        for index in categoriesIndex where index != defaultCategoryIndex {
            codes.append(missionDetailFilters[index].category.code)
        }
        filteredBadgesDictionary = filterBadgesBy(categoryCodes: codes)
    }
    
    private func filterBadgesBy(categoryCodes: [String]) -> [String: [Badge]] {
        return badgesDictionary.filter { categoryCodes.contains($0.key) }
    }
    
    private func isDefaultCategorySelected() -> Bool {
        return selectedFilterIndexes().count == 1 && selectedFilterIndexes().contains(defaultCategoryIndex)
    }
    
    private func prepareBadgesData() {
        for categoryCode in defaultCategoryCodes {
            let badgesFiltered = badges.filter({ $0.category.code == categoryCode})
            badgesDictionary[categoryCode] = badgesFiltered
        }
    }
}

struct MissionListDetailFilter {
    let category: LoyaltyCategory
    var isSelected: Bool
}
