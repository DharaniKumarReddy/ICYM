//
//  RegionPhotoVideoViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 24/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class RegionPhotoVideoViewController: UIViewController {

    // MARK:- Variables
    private var photos: [Photo] = []
    private var videos: [Video] = []
    
    internal var isPhotos = true
    internal var regionId: Int?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBackWithNoText()
        isPhotos ? getRegionPhotos() : getRegionVideos()
    }
    
    // MARK:- Private Methods
    private func getRegionPhotos() {
        APICaller.getInstance().getRegionalPhotos(regionID: regionId ?? 1, onSuccess: { regionalPhotos in
            self.photos = regionalPhotos?.photos.reversed() ?? []
            self.reload()
        }, onError: { _ in })
    }
    
    private func getRegionVideos() {
        APICaller.getInstance().getRegionalVideos(regionID: regionId ?? 1, onSuccess: { regionalPhotos in
            self.videos = regionalPhotos?.videos.reversed() ?? []
            self.reload()
        }, onError: { _ in })
    }
    
    private func reload() {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
}

extension RegionPhotoVideoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth-2)/2, height: isPhotos ? screenWidth/2 : screenWidth/2-20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isPhotos ? photos.count : videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isPhotos {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:  RegionPhotoCollectionCell.self), for: indexPath) as? RegionPhotoCollectionCell
            cell?.photoImageView.downloadImageFrom(link: photos[indexPath.row].img, contentMode: .scaleAspectFill)
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:  RegionVideoCollectionCell.self), for: indexPath) as? RegionVideoCollectionCell
            cell?.loadData(video: videos[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isPhotos else {
            return
        }
        let youtubeId = videos[indexPath.row].videoId
        var youtubeUrl = URL(string:"youtube://\(youtubeId)")!
        if UIApplication.shared.canOpenURL(youtubeUrl){
            UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
        } else{
            youtubeUrl = URL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
            UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
        }
    }
}

class RegionPhotoCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
}

class RegionVideoCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoImageView: UIImageView!
    
    internal func loadData(video: Video) {
        videoTitleLabel.text = video.title
        videoImageView.downloadImageFrom(link: "https://img.youtube.com/vi/\(video.videoId)/default.jpg", contentMode: .scaleAspectFill)
    }
}
