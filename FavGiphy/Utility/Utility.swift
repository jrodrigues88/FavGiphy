//
//  Utility.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 28/05/22.
//

import Foundation
import UIKit
import SwiftGifOrigin

var imageCache = NSCache<AnyObject, AnyObject>()
var downloadingArray = [String]()
var isFavChanged = false

class CustomImageView: UIImageView {
    
    var imageName: String?
    
    func load(url: URL?, name: String) {
        
        imageName = name
        
        if let dataFromFile = GifFileManager.instance.getFileData(name: name) {
            if nil == imageCache.object(forKey: name as NSString) {
                imageCache.setObject(dataFromFile, forKey: name as NSString)
            }
        }
        
        if let dataFromCache = imageCache.object(forKey: name as NSString) as? NSData {
            if let gifFromCache = UIImage.gif(data: dataFromCache as Data) {
                DispatchQueue.main.async {
                    self.image = gifFromCache
                    return
    //                self.image = UIImage(data: dataFromCache as Data)
    //                return
                }
            }            
        }
        
        image = UIImage(named: "placeholder")
        
        if nil == imageCache.object(forKey: name as NSString) && !downloadingArray.contains(name) {
            downloadingArray.append(name)
            
            DispatchQueue.global().async { [weak self] in
                if let gifUrl = url, let data = try? Data(contentsOf: gifUrl) {
                    imageCache.setObject(data as NSData, forKey: name as NSString)
                    if let gifFromData = UIImage.gif(data: data), self?.imageName == name {
                        DispatchQueue.main.async {
                            self?.image = gifFromData
    //                        if self?.imageName == name {
    //                            self?.image = UIImage(data: data as Data)
    //                        }
                        }
                    }
                }
            }
        }
        
    }
    
    func getGifData(name: String?) -> NSData? {
        if let cacheName = name, let dataFromCache = imageCache.object(forKey: cacheName as NSString) as? NSData {
            return dataFromCache
        }
        return nil
    }
}
