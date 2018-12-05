//
//  NotificationViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 25/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    // MARK:- Variables
    private var notifications: [Notification] = []
    
    // MARK:- IBActions
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        navigationController?.isNavigationBarHidden = false
        getNotifications()
        navigationBackWithNoText()
        title = "NOTIFICATION"
    }
    
    // MARK:- Private Methods
    private func getNotifications() {
        APICaller.getInstance().getNotifications(
            updatedAt: "2017-05-03 02:09:58", onSuccess: { notifications in
                self.notifications = notifications.reversed()
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
        }, onError: { _ in })
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationTableCell.self)) as? NotificationTableCell
        cell?.loadData(notification: notifications[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

class NotificationTableCell: UITableViewCell {
    // MARK:- IBoutlets
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK:- Loading Methods
    fileprivate func loadData(notification: Notification) {
        dateLabel.text = notification.date
        titleLabel.text = notification.title.uppercased()
        descriptionLabel.text = notification.description
    }
}
