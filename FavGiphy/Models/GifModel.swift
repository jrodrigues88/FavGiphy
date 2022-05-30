//
//  GifModel.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 28/05/22.
//

import Foundation
import UIKit

struct GifModel  {
    var id : String?
    var url : String?
    var title : String?
    var isFavorite : Bool
    
    mutating func updateFavorite(isFav: Bool) {
        self.isFavorite = isFav
    }
}
