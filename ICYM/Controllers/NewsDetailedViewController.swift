//
//  NewsDetailedViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 16/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NewsDetailedViewController: UIViewController {
    
    // MARK:- Variables
    private var newsImages: [UIImage] = []
    
    private var newsId: String?
    private var share: String?
    private var imageUrl: String?
    private var titleString: String?
    private var desc: String?
    private var date: String?
    fileprivate var activityController : UIActivityViewController!
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK:- Life Cycle Methods
    func configure(id: String?, share: String?, title: String?, description: String?, image: String?, date: String?) {
        newsId = id
        self.share = share
        titleString = title
        desc = description
        imageUrl = image
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 330
        tableView.rowHeight = UITableView.automaticDimension
        title = "News"
        navigationBackWithNoText()
        getMultipleImages()
        loadActivityController()
    }
    
    // MARK:- Private Methods
    private func getMultipleImages() {
        APICaller.getInstance().getNewsMultipleImges(newsId: newsId ?? "", onSuccess: { newsImages in
            self.downloadImages(newsImages?.news ?? [])
        }, onError: { _ in })
    }
    
    private func downloadImages(_ newsImages: [News]) {
        for newsImage in newsImages {
            newsImage.image.downloadImage(completion: { image in
                self.newsImages.append(image)
                if self.newsImages.count == newsImages.count {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    private func loadActivityController() {
        let url = URL(string: share ?? "")!
        let activityItems = [url] as [Any]
        activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.excludedActivityTypes = [.print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList]
    }
}

extension NewsDetailedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDetailedTableCell") as! NewsDetailedTableCell
        cell.delegate = self
        cell.loadData(title: titleString, description: desc, images: newsImages, image: imageUrl, date: date)
        return cell
    }
}

extension NewsDetailedViewController: shareDetailsDelegate {
    func shareDetails(link: String) {
        present(activityController, animated: true, completion: nil)
    }
}

class NewsDetailedTableCell: UITableViewCell {
    
    // MARK:- Variables
    fileprivate weak var delegate: shareDetailsDelegate?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitle: UILabel!
    @IBOutlet private weak var newsDate: UILabel!
    @IBOutlet private weak var newsDesc: UILabel!
    
    fileprivate func loadData(title: String?, description: String?, images: [UIImage]?, image: String?, date: String?) {
        if images?.isEmpty ?? false {
            newsImageView.downloadImageFrom(link: image ?? "", contentMode: .scaleAspectFill)
        } else {
            newsImageView.animationImages = images ?? []
            newsImageView.animationDuration = TimeInterval((images?.count ?? 1) * 2)
            newsImageView.startAnimating()
        }
        newsTitle.text = title
        newsDesc.text = description
        newsDate.text = date
    }
    
    // MARK:- IBActions
    @IBAction private func shareButton_Tapped() {
        delegate?.shareDetails(link: "")
    }
}

protocol shareDetailsDelegate: class {
    func shareDetails(link: String)
}
