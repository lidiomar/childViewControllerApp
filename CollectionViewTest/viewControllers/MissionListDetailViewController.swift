import UIKit

class MissionListDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var missionDetailTableView: UITableView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    // MARK: - Constants
    private let identifierCellCollectionView = String(describing: FilterMissionCell.self)
    private let identifierCellTableView = String(describing: BadgeTableViewCell.self)
    private let defaultCollectionViewIndexPath = IndexPath(row: 0, section: 0)
    private let sectionHeaderHeight = 80
    private let tableViewRowHeight = 96
    private let filterCollectionViewHeight = 128
    
    // MARK: - Internal vars
    internal var viewModel: MissionListDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterCollectionView()
        setupMissionDetailTableView()
    }
    
    private func setupMissionDetailTableView() {
        missionDetailTableView.dataSource = self
        missionDetailTableView.delegate = self
        missionDetailTableView.isScrollEnabled = false
        let nibCell = UINib(nibName: identifierCellTableView, bundle: nil)
        missionDetailTableView.register(nibCell, forCellReuseIdentifier: identifierCellTableView)
    }
    
    private func setupFilterCollectionView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.allowsMultipleSelection = true
        let nibCell = UINib(nibName: identifierCellCollectionView, bundle: nil)
        filterCollectionView.register(nibCell, forCellWithReuseIdentifier: identifierCellCollectionView)
        selectCollectionViewCellAt(indexPath: defaultCollectionViewIndexPath)
        missionDetailTableView.reloadData()
    }
    
    private func setupContentSizeHeight() {
        let numberOfSections = viewModel?.numberOfCategories() ?? 5
        let numberOfRows = viewModel?.numberOfBadges() ?? 20
        
        let missionDetailTableViewHeight = (numberOfSections * sectionHeaderHeight) + (numberOfRows * tableViewRowHeight)
        let viewHeight = filterCollectionViewHeight + missionDetailTableViewHeight
        preferredContentSize = CGSize(width: missionDetailTableView.contentSize.width, height: CGFloat(viewHeight))
    }
}

extension MissionListDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.badgesCountInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = missionDetailTableView.dequeueReusableCell(withIdentifier: identifierCellTableView,
                                                                    for: indexPath) as? BadgeTableViewCell else { return UITableViewCell() }
        
        viewModel?.updateBadgeItemUI(indexPath: indexPath,
                                     badgeNameLabel: cell.badgeName,
                                     badgeIndicator: cell.badgeIndicatorView)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.selectedFilterCount() ?? 0
    }
}

extension MissionListDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionName = viewModel?.loyaltyCategoryNameBy(section: section) ?? ""
        let label = createSectionHeaderLabel(with: sectionName)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: CGFloat(sectionHeaderHeight)))
        
        containerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(sectionHeaderHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableViewRowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller: MissionDescriptionViewController = MissionDescriptionViewController.instantiate()
        let badge = viewModel?.badgeAt(section: indexPath.section, index: indexPath.row)
        controller.badge = badge
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func createSectionHeaderLabel(with sectionName: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = sectionName
        label.textColor = #colorLiteral(red: 0.2609540224, green: 0.1810970008, blue: 0.4384740293, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }
}

extension MissionListDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterMissionCell else { return }
        
        viewModel?.updateFilterLabelUI(label: cell.filterLabel, state: .selected)
        viewModel?.updateMissionDetailFilterState(index: indexPath.row, isSelected: true)
        
        if defaultCollectionViewIndexPath == indexPath {
            viewModel?.deSelectAllButItem(itemIndex: indexPath.row)
            deSelectCollectionViewItemsBut(item: indexPath.row)
        } else if filterCollectionView.indexPathsForSelectedItems?.contains(defaultCollectionViewIndexPath) ?? false {
            viewModel?.deSelectItemAt(itemIndex: defaultCollectionViewIndexPath.row)
            deSelectCollectionViewCellAt(indexPath: defaultCollectionViewIndexPath)
        }
        filter()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterMissionCell else { return }
        viewModel?.updateFilterLabelUI(label: cell.filterLabel, state: .unselected)
        viewModel?.updateMissionDetailFilterState(index: indexPath.row, isSelected: false)
        updateDefaultCell()
        filter()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return indexPath != defaultCollectionViewIndexPath
    }
    
    private func updateDefaultCell() {
        if filterCollectionView.indexPathsForSelectedItems?.count ?? 0 == 0 {
            viewModel?.updateMissionDetailFilterState(index: defaultCollectionViewIndexPath.row, isSelected: true)
            selectCollectionViewCellAt(indexPath: defaultCollectionViewIndexPath)
            filterCollectionView.reloadItems(at: [defaultCollectionViewIndexPath])
        }
    }
    
    private func deSelectCollectionViewItemsBut(item: Int) {
        self.filterCollectionView.performBatchUpdates(nil) { _ in
            for index in 0..<(self.viewModel?.missionDetailFiltersCount() ?? 0) where index != item {
                self.filterCollectionView.deselectItem(at: IndexPath(row: index, section: 0), animated: false)
                self.filterCollectionView.delegate?.collectionView?(self.filterCollectionView, didDeselectItemAt: IndexPath(row: index, section: 0))
            }
        }
    }
    
    private func deSelectCollectionViewCellAt(indexPath: IndexPath) {
        self.filterCollectionView.performBatchUpdates(nil) { _ in
            self.filterCollectionView.deselectItem(at: indexPath, animated: false)
            self.filterCollectionView.delegate?.collectionView?(self.filterCollectionView, didDeselectItemAt: indexPath)
        }
    }
    
    private func selectCollectionViewCellAt(indexPath: IndexPath) {
        self.filterCollectionView.performBatchUpdates(nil) { _ in
            self.filterCollectionView.selectItem(at: indexPath,
                                                 animated: true,
                                                 scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            self.filterCollectionView.delegate?.collectionView?(self.filterCollectionView, didSelectItemAt: indexPath)
        }
    }
    
    private func filter() {
        viewModel?.filter()
        missionDetailTableView.reloadData()
        setupContentSizeHeight()
    }
}

extension MissionListDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.missionDetailFiltersCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: identifierCellCollectionView, for: indexPath) as? FilterMissionCell else {
            return UICollectionViewCell()
        }
        viewModel?.updateMissionDetailFilterUI(label: cell.filterLabel, index: indexPath.row)
        return cell
    }
}

extension MissionListDetailViewController: StoryboardInstantiable {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Missions", bundle: nil)
        let identifier = String(describing: MissionListDetailViewController.self)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self {
            return viewController
        } else {
            return Self()
        }
    }
}
