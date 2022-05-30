//
//  ApiManager.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 24/05/22.
//

import Foundation

class ApiManager: NSObject {
    
    static let instance = ApiManager()
    let trendingUrl = "https://api.giphy.com/v1/gifs/trending?api_key=av9hgPM5S2ufBCsjFFhcdugSblOBb7Ps&offset=%d&limit=%d"
    let searchUrl = "https://api.giphy.com/v1/gifs/search?api_key=av9hgPM5S2ufBCsjFFhcdugSblOBb7Ps&q=%@"
    
    private override init() {
        super.init()
    }
    
    func fetchGifs(offset: Int, completionHandler: @escaping ([GifData]) -> Void) {
        let urlString = String(format: trendingUrl, offset, 15)
        guard let url = URL(string: urlString) else {
            completionHandler([])
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data, let gifs = try? JSONDecoder().decode(GifResponse.self, from: data) {
            completionHandler(gifs.data ?? [])
          }
        })
        task.resume()
    }
    
    func searchGifs(searchString: String, completionHandler: @escaping ([GifData]) -> Void) {
        let urlString = String(format: searchUrl, searchString)
        guard let url = URL(string: urlString) else {
            completionHandler([])
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data, let gifs = try? JSONDecoder().decode(GifResponse.self, from: data) {
            completionHandler(gifs.data ?? [])
          }
        })
        task.resume()
    }
}
