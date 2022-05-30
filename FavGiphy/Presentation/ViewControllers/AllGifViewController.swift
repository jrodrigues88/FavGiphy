//
//  AllGifViewController.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 22/05/22.
//

import UIKit

class AllGifViewController: UIViewController {

    @IBOutlet weak var gifTableView: UITableView!
    @IBOutlet weak var gifSearchView: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    var allGifViewModel = AllGifViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFavChanged {
            allGifViewModel.updateData()
            isFavChanged = false
        }
    }
    
    func setupViewModel(){
        allGifViewModel.reloadTableView = {
            DispatchQueue.main.async { self.gifTableView.reloadData() }
        }
        allGifViewModel.showLoadingIndicator = {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        }
        allGifViewModel.hideLoadingIndicator = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.noDataLabel.isHidden = self.allGifViewModel.numberOfCells() > 0
            }
        }
        allGifViewModel.loadData()
    }
}

extension AllGifViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGifViewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGifTableViewCell", for: indexPath) as! AllGifTableViewCell
        cell.delegate = self
        cell.setupData(data: allGifViewModel.dataForCell(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == allGifViewModel.numberOfCells() - 1 {
            allGifViewModel.loadData()
        }
    }
}

extension AllGifViewController: AllGifCellDelegate {
    func toggleFavoriteValue(for cell: AllGifTableViewCell, gifName: String?, gifData: NSData?) {
        guard let indexPath = gifTableView.indexPath(for: cell) else {
            return
        }
        allGifViewModel.toggleFavoriteForCell(at: indexPath, gifName: gifName, gifData: gifData)
    }
}

extension AllGifViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        allGifViewModel.searchData(searchString: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        allGifViewModel.searchData(searchString: searchBar.text)
    }
}
