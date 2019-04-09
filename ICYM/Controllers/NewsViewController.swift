//
//  NewsViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 15/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    // MARK:- Variables
    private var news: [News] = []
    internal var regionNews = true
    internal var regionId: Int?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        title = "News"
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        navigationBackWithNoText()
        regionNews ? getNews() : getNYCNews()
    }
    
    // MARK:- Private Methods
    private func getNews() {
        APICaller.getInstance().getNews(regionID: regionId ?? 1, onSuccess: { newsDetails in
            self.news = newsDetails?.news.reversed() ?? []
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }, onError: { error in
            
        })
    }
    
    private func getNYCNews() {
        APICaller.getInstance().getNYCNews(onSuccess: { newsDetails in
            self.news = newsDetails?.news.reversed() ?? []
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }, onError: { error in
            
        })
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell") as? NewsTableCell
        cell?.loadData(news: news[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsDetailedController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NewsDetailedViewController.self)) as! NewsDetailedViewController
        let newsObject = news[indexPath.row]
        let share = "http://youthactiv8.com/icym_app/nyc_newsshare.php?id=\(newsObject.id)"
        newsDetailedController.configure(id: newsObject.id, share: share,title: newsObject.title, description: newsObject.newsDescription, image: newsObject.image, date: newsObject.newsDate)
        navigationController?.pushViewController(newsDetailedController, animated: true)
    }
}

class NewsTableCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsDateLabel: UILabel!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsDescLabel: UILabel!
    
    fileprivate func loadData(news: News) {
        newsImageView.image = #imageLiteral(resourceName: "default_image")
        newsImageView.downloadImageFrom(link: news.image, contentMode: .scaleToFill)
        newsDateLabel.text = news.newsDate
        newsTitleLabel.text = news.title
        newsDescLabel.text = news.newsDescription
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = nil
        let shadowPath = UIBezierPath(rect: CGRect(x: 0 , y: 0, width: screenWidth-12, height: containerView.frame.size.height))
        containerView.layer.shadowColor =  UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.15
        layer.shadowPath = shadowPath.cgPath
    }
}
