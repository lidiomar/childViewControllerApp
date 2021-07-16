//
//  ViewController.swift
//  ChildViewInScrollView
//
//  Created by Ali Tosuner on 6.06.2020.
//  Copyright © 2020 Ali Tosuner. All rights reserved.
//

import UIKit

final class MissionsListViewController: UIViewController {
    //MARK: - Privates
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var customViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        switch container {
        case is MissionListDetailViewController:
            customViewHeightConstraint.constant = container.preferredContentSize.height
        default:
            break
        }
    }
    
    private func addChildViewController() {
        guard let childViewController = UIStoryboard(name: "Missions", bundle: nil)
            .instantiateViewController(withIdentifier: "MissionListDetailViewController") as? MissionListDetailViewController
            else { return }
        childViewController.viewModel = ModelFactory.makeMissionModel()
        addChild(childViewController)
        customView.addSubview(childViewController.view)
        activateRequiredConstraints(for: childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    private func activateRequiredConstraints(for childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 0),
            childView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: 0),
            childView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 0),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


