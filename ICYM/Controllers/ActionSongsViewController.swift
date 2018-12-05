//
//  ActionSongsViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 25/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class ActionSongsViewController: UIViewController {

    // MARK:- Variables
    private var videos: [Video] = []
    
    // MARK:- IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationBackWithNoText()
        getRegionVideos()
    }
    
    // MARK:- Private Methods
    
    private func getRegionVideos() {
        APICaller.getInstance().getAnimationSongs(updatedAt: "2017-07-04", onSuccess: { songs in
            self.videos = songs
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }, onError: { _ in })
    }
}

extension ActionSongsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth-2)/2, height: screenWidth/2-20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:  RegionVideoCollectionCell.self), for: indexPath) as? RegionVideoCollectionCell
        cell?.loadData(video: videos[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
