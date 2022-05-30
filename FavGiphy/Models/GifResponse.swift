//
//  GifResponse.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 24/05/22.
//

import Foundation

struct GifResponse: Codable {
    
    var data: [GifData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([GifData].self, forKey: .data)
    }
}

struct GifData: Codable  {
    var type : String?
    var id : String?
    var url : String?
    var title : String?
    var images : GifImages?
}

struct GifImages: Codable {
    var original : GifOriginalImages?
}

struct GifOriginalImages: Codable {
    var url : String?
}
