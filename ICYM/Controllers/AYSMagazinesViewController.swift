//
//  AYSMagazinesViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 20/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

enum TableType {
    case Magazines
    case Bearers
    case Reports
}
class AYSMagazinesViewController: UIViewController {
    
    // MARK:- Variables
    private var magazines: [AYSMagazine] = []
    private var bearers: [Bearer] = []
    private var reports: [AnnualReport] = []
    
    private var regionId: Int?
    
    private var tableType: TableType = .Magazines
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK:- Life Cycle Methods
    internal func configure(tableType: TableType, regionId: Int?) {
        self.tableType = tableType
        self.regionId = regionId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationBackWithNoText()
        title = tableType == .Magazines ? "APNA YUVA SPANDAN" : tableType == .Bearers ? "REXCO" : "REGIONAL CIRCULAR" 
        tableType == .Magazines ? getMagazines() : tableType == .Bearers ? getOfficeBearers() : getAnnualReports()
        tableView.rowHeight = getRowHeight()
    }
    
    // MARK:- Private Methods
    private func getMagazines() {
        APICaller.getInstance().getAYSMagazine(onSuccess: { aysMagazines in
            self.magazines = aysMagazines?.magazines.reversed() ?? []
            self.reload()
        }, onError: { _ in })
    }
    
    private func getOfficeBearers() {
        APICaller.getInstance().getRegionalOfficeBearers(
            regionID: regionId ?? 1, onSuccess: { officeBearers in
                self.bearers = officeBearers?.bearers.reversed() ?? []
                self.reload()
        }, onError: { _ in })
    }
    
    private func getAnnualReports() {
        APICaller.getInstance().getRegionalAnnualReport(
            regionID: regionId ?? 1, onSuccess: { annualReports in
                self.reports = annualReports?.reports.reversed() ?? []
                self.reload()
        }, onError: { _ in })
    }
    
    private func reload() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    private func getRowHeight() -> CGFloat {
        return [.Magazines : 110, .Bearers : 130, .Reports : 100][tableType] ?? 110
    }
    
    private func getRowCount() -> Int {
        return [.Magazines : magazines.count, .Bearers : bearers.count, .Reports : reports.count][tableType] ?? 0
    }
}

extension AYSMagazinesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableType {
        case .Magazines:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MagazineTableCell.self)) as? MagazineTableCell
            cell?.delegate = self
            cell?.loadData(magazine: magazines[indexPath.row])
            return cell ?? UITableViewCell()
        case .Bearers:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OfficeBearersTableCell.self)) as? OfficeBearersTableCell
            cell?.loadData(bearer: bearers[indexPath.row])
            return cell ?? UITableViewCell()
        case .Reports:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnnualReportTableCell.self)) as? AnnualReportTableCell
            cell?.delegate = self
            cell?.pdfUrl = reports[indexPath.row].pdfLink
            cell?.titleLabel.text = reports[indexPath.row].title
            return cell ?? UITableViewCell()
        }
    }
}

extension AYSMagazinesViewController: ViewPdfDelegate {
    func viewPdf(pdfUrl: String) {
        pushWebPage(url: pdfUrl, title: "ICYM")
    }
}

class MagazineTableCell: UITableViewCell {
    
    fileprivate weak var delegate: ViewPdfDelegate?
    private var pdfUrl = ""
    
    // MARK:- IBOutlets
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var magazineImageView: UIImageView!
    
    // MARK:- Private Method
    fileprivate func loadData(magazine: AYSMagazine) {
        magazineImageView.downloadImageFrom(link: magazine.image, contentMode: .scaleToFill)
        dateLabel.text = magazine.month
        nameLabel.text = magazine.name
        pdfUrl = magazine.urlPdf
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = nil
        let shadowPath = UIBezierPath(rect: CGRect(x: 0 , y: 0, width: screenWidth-16, height: containerView.frame.size.height))
        containerView.layer.shadowColor =  UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.15
        layer.shadowPath = shadowPath.cgPath
    }
    
    // MARK:- IBAction
    @IBAction private func viewButton_Tapped() {
        delegate?.viewPdf(pdfUrl: pdfUrl)
    }
}

class OfficeBearersTableCell: UITableViewCell {
    
    // MARK:- IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var dioceseLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var designationLabel: UILabel!
    @IBOutlet private weak var bearerImageView: UIImageView!
    
    // MARK:- Private Method
    fileprivate func loadData(bearer: Bearer) {
        bearerImageView.downloadImageFrom(link: bearer.image, contentMode: .scaleToFill)
        nameLabel.text = bearer.name
        emailLabel.text = "Email : " + bearer.email
        dioceseLabel.text = "Diocese : " + bearer.diocese
        designationLabel.text = bearer.designation
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = nil
        let shadowPath = UIBezierPath(rect: CGRect(x: 0 , y: 0, width: screenWidth-16, height: containerView.frame.size.height))
        containerView.layer.shadowColor =  UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.15
        layer.shadowPath = shadowPath.cgPath
    }
}

class AnnualReportTableCell: UITableViewCell {
    
    fileprivate weak var delegate: ViewPdfDelegate?
    fileprivate var pdfUrl = ""
    
    // MARK:- IBOutlets
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    @IBAction private func previewButton_Tapped() {
        delegate?.viewPdf(pdfUrl: pdfUrl)
    }
}

protocol ViewPdfDelegate: class {
    func viewPdf(pdfUrl: String)
}
