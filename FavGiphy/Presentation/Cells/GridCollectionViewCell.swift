//
//  GridCollectionViewCell.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 24/05/22.
//

import UIKit

protocol FavGifCellDelegate: AnyObject {
    func removeFavorite(for cell: GridCollectionViewCell, gifName: String?, gifData: NSData?)
}

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: CustomImageView!
    @IBOutlet weak var favButtonImage: UIImageView!
    var gifId: String?
    
    weak var delegate: FavGifCellDelegate?
    
    func setupData(data: GifModel) {
        guard let id = data.id else {
            return
        }
        gifId = id
        favButtonImage.image = data.isFavorite ? UIImage(named: "favFilled") : UIImage(named: "fav")
        let url = URL(string: data.url ?? "")
        gifImageView.load(url: url, name: id)
    }

    @IBAction func favButtonAction(_ sender: Any) {
        guard gifImageView.image != UIImage(named: "placeholder") else {
            return
        }
        delegate?.removeFavorite(for: self, gifName: gifId, gifData: gifImageView.getGifData(name: gifId))
    }
}
