//
//  FavGifViewModel.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 24/05/22.
//

import Foundation

class FavGifViewModel: NSObject {
    
    var reloadCollectionView: (()->())?
    
    private var viewData: [GifModel] = [GifModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    func loadData() {
        GifFileManager.instance.getAllFavoriteFiles { files in
            self.mapToViewModel(files: files)
        }
    }
    
    private func mapToViewModel(files: [String]) {
        guard files.count > 0 else {
            return
        }
        
        var tempData = [GifModel]()
        for eachFile in files {
            let id = eachFile.components(separatedBy: ".").first
            tempData.append(GifModel(id: id, isFavorite: true))
            
        }
        self.viewData = tempData
    }
    
    func numberOfItems() -> Int {
        return viewData.count
    }
    
    func dataForItem( at indexPath: IndexPath ) -> GifModel {
        return viewData[indexPath.row]
    }
    
    func removeFavoriteForCell( at indexPath: IndexPath, gifName: String?, gifData: NSData?) {
        GifFileManager.instance.removeFile(name: gifName)
        viewData.remove(at: indexPath.row)
        isFavChanged = true
    }
}
