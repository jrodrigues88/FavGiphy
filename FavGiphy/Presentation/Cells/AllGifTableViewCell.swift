//
//  AllGifTableViewCell.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 24/05/22.
//

import UIKit

protocol AllGifCellDelegate: AnyObject {
    func toggleFavoriteValue(for cell: AllGifTableViewCell, gifName: String?, gifData: NSData?)
}

class AllGifTableViewCell: UITableViewCell {

    @IBOutlet weak var gifImageView: CustomImageView!
    @IBOutlet weak var favButtonImage: UIImageView!
    var gifId: String?
    
    weak var delegate: AllGifCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(data: GifModel) {
        guard let urlString = data.url, let url = URL(string: urlString) else {
            return
        }
        gifId = data.id
        favButtonImage.image = data.isFavorite ? UIImage(named: "favFilled") : UIImage(named: "fav")
        gifImageView.load(url: url, name: data.id ?? urlString)
    }

    @IBAction func favButtonAction(_ sender: Any) {
        guard gifImageView.image != UIImage(named: "placeholder") else {
            return
        }
        delegate?.toggleFavoriteValue(for: self, gifName: gifId, gifData: gifImageView.getGifData(name: gifId))
        let isFav = favButtonImage.image == UIImage(named: "favFilled")
        favButtonImage.image = isFav ? UIImage(named: "fav") : UIImage(named: "favFilled")
    }
}
