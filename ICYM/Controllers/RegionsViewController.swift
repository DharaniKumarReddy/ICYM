//
//  RegionsViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 20/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class RegionsViewController: UIViewController {

    // MARK:- Variables
    private var regions: [Region] = []
    
    // MARK:- IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationBackWithNoText()
        title = "REGIONS IN INDIA"
        getRegions()
    }
    
    // MARK:- Private Methods
    private func getRegions() {
        APICaller.getInstance().getRegionsList(onSuccess: { icymRegions in
            self.regions = icymRegions?.regions.filter({ $0.id != "1" }) ?? []
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }, onError: {_ in
            
        })
    }
}

extension RegionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth-8)/3
        return CGSize(width: width, height: width+0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RegionsCollectionCell.self), for: indexPath) as? RegionsCollectionCell
        cell?.loadData(region: regions[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let regionDetailsController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: RegionDetailsViewController.self)) as! RegionDetailsViewController
        regionDetailsController.region = regions[indexPath.row]
        navigationController?.pushViewController(regionDetailsController, animated: true)
    }
}

class RegionsCollectionCell: UICollectionViewCell {
    
    // MARK:- IBOutlets
    @IBOutlet private weak var regionNameLabel: UILabel!
    @IBOutlet private weak var regionImageView: UIImageView!
    
    // MARK:- Private Method
    fileprivate func loadData(region: Region) {
        regionNameLabel.text = region.regionName
        regionImageView.downloadImageFrom(link: region.image, contentMode: .scaleAspectFill)
    }
}
