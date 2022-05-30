//
//  AllGifViewModel.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 24/05/22.
//

import Foundation
import UIKit

class AllGifViewModel: NSObject {
    
    var reloadTableView: (()->())?
    var showLoadingIndicator: (()->())?
    var hideLoadingIndicator: (()->())?
    
    var page = 0
    let pageSize = 15
    
    private var viewData: [GifModel] = [GifModel]()
    
    func loadData() {
        showLoadingIndicator?()
        let offset = page * pageSize
        page += 1
        ApiManager.instance.fetchGifs(offset: offset) { data in
            self.mapToViewModel(response: data)
            self.hideLoadingIndicator?()
        }
    }
    
    func searchData(searchString: String?) {
        guard let text = searchString else {
            page = 0
            viewData.removeAll()
            self.loadData()
            return
        }
        
        showLoadingIndicator?()
        viewData.removeAll()
        ApiManager.instance.searchGifs(searchString: text) { data in
            self.mapToViewModel(response: data)
            self.hideLoadingIndicator?()
        }
    }
    
    private func mapToViewModel(response: [GifData]?) {
        guard let data = response else {
            return
        }
        
        var tempData = [GifModel]()
        for eachVal in data {
            tempData.append(GifModel(id: eachVal.id, url: eachVal.images?.original?.url, title: eachVal.title, isFavorite: GifFileManager.instance.isFileExist(name: eachVal.id)))
            
        }
        self.viewData.append(contentsOf: tempData)
        self.reloadTableView?()
    }
    
    func updateData() {
        for (index, element) in viewData.enumerated() {
            viewData[index].updateFavorite(isFav: GifFileManager.instance.isFileExist(name: element.id))
        }
        self.reloadTableView?()
    }
    
    func numberOfCells() -> Int {
        return viewData.count
    }
    
    func dataForCell( at indexPath: IndexPath ) -> GifModel {
        return viewData[indexPath.row]
    }
    
    func toggleFavoriteForCell( at indexPath: IndexPath, gifName: String?, gifData: NSData?) {
        let value = viewData[indexPath.row]
        let isFav = !value.isFavorite
        if isFav {
            GifFileManager.instance.saveFile(name: gifName, data: gifData)
        } else {
            GifFileManager.instance.removeFile(name: gifName)
        }
        viewData[indexPath.row].updateFavorite(isFav: isFav)
    }
}
