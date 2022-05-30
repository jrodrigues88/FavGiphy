//
//  FavGifViewController.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 22/05/22.
//

import UIKit

class FavGifViewController: UIViewController {

    @IBOutlet weak var gifCollectionView: UICollectionView!
    @IBOutlet weak var gifSegmentView: UISegmentedControl!
    @IBOutlet weak var noDataLabel: UILabel!
    var favGifViewModel = FavGifViewModel()
    var isListView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favGifViewModel.loadData()
    }
    
    func setupViewModel(){
        favGifViewModel.reloadCollectionView = {
            DispatchQueue.main.async { self.gifCollectionView.reloadData() }
        }
    }
    
    @IBAction func segmentValueChange(_ sender: Any) {
        let segemnt = sender as! UISegmentedControl
        isListView = segemnt.selectedSegmentIndex == 1
        self.gifCollectionView.reloadData()
    }
}

extension FavGifViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = favGifViewModel.numberOfItems()
        noDataLabel.isHidden = count > 0
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
        cell.delegate = self
        cell.setupData(data: favGifViewModel.dataForItem(at: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension FavGifViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ht = isListView ? 200 : (collectionView.bounds.width-30)/3
        let wth = isListView ? collectionView.bounds.width : ht
        return CGSize(width: wth, height: ht)
    }
}

extension FavGifViewController: FavGifCellDelegate {
    func removeFavorite(for cell: GridCollectionViewCell, gifName: String?, gifData: NSData?) {
        guard let indexPath = gifCollectionView.indexPath(for: cell) else {
            return
        }
        favGifViewModel.removeFavoriteForCell(at: indexPath, gifName: gifName, gifData: gifData)
    }
}
