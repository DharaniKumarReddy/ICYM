//
//  LeadershipNationalsViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 25/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class LeadershipNationalsViewController: UIViewController {

    // MARK:- Variables
    private var governingBodies: [Bearer] = []
    
    internal var isNationalCouncil = false
    internal var isNexco = false
    
    // MARK:- IBActions
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if isNationalCouncil {
            getNationalCouncil()
        } else {
            isNexco ? getNexcoData() : getGoverningBody()
        }
        tableView.rowHeight = isNationalCouncil ? 80 : 130
        navigationBackWithNoText()
    }
    
    // MARK:- Private Methods
    private func getGoverningBody() {
        APICaller.getInstance().getGoverningBody(
            updatedAt: "2016-10-16 22:20:25", onSuccess: { governingBody in
                self.loadData(data: governingBody?.governingBodies)
        }, onError: { _ in })
    }
    
    private func getNexcoData() {
        APICaller.getInstance().getNexcoData(
            updatedAt: "2017-04-04 20:58:27", onSuccess: { nexcoData in
                self.loadData(data: nexcoData?.governingBodies)
        }, onError: { _ in })
    }
    
    private func getNationalCouncil() {
        APICaller.getInstance().getNationalCouncilData(
            updatedAt: "2016-05-04 20:42:39", onSuccess: { councilData in
                self.loadData(data: councilData?.governingBodies.reversed())
        }, onError: { _ in })
    }
    
    private func loadData(data: [Bearer]?) {
        governingBodies = data ?? []
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
}

extension LeadershipNationalsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return governingBodies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNationalCouncil {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NationalCouncilTableCell.self)) as? NationalCouncilTableCell
            cell?.loadData(national: governingBodies[indexPath.row])
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NationalGoverningBodyTableCell.self)) as? NationalGoverningBodyTableCell
            cell?.loadData(national: governingBodies[indexPath.row])
            return cell ?? UITableViewCell()
        }
    }
}

class NationalGoverningBodyTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var designationLabel: UILabel!
    @IBOutlet private weak var nationalImageView: UIImageView!
    
    // MARK:- Private Methods
    fileprivate func loadData(national: Bearer) {
        nationalImageView.downloadImageFrom(link: national.image, contentMode: .scaleAspectFill)
        titleLabel.text = national.name
        designationLabel.text = national.designation
    }
}

class NationalCouncilTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var designationLabel: UILabel!
    
    // MARK:- Private Methods
    fileprivate func loadData(national: Bearer) {
        titleLabel.text = national.name
        designationLabel.text = national.designation
    }
}
