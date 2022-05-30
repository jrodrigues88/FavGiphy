//
//  FileManager.swift
//  FavGiphy
//
//  Created by Jephin Rodrigues on 29/05/22.
//

import Foundation

class GifFileManager: NSObject {
    
    static let instance = GifFileManager()
    let manager = FileManager.default
    
    private override init() {
        super.init()
    }
    
    func saveFile(name: String?, data: NSData?) {
        guard let fileName = name, let fileData = data else {
            return
        }
        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent("\(fileName).gif")
        do {
            try fileData.write(to: url)
        } catch {
            print("UNABLE TO WRITE")
        }
    }
    
    func getFileData(name: String) -> NSData? {
        
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = directory.appendingPathComponent("\(name).gif")
        
        if manager.fileExists(atPath: path.path), let data = NSData(contentsOfFile: path.path) {
            return data
        } else {
            return nil
        }
    }
    
    func isFileExist(name: String?) -> Bool {
        guard let fileName = name else {
            return false
        }
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = directory.appendingPathComponent("\(fileName).gif")
        return manager.fileExists(atPath: path.path)
    }
    
    func removeFile(name: String?) {
        guard let fileName = name else {
            return
        }
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = directory.appendingPathComponent("\(fileName).gif")
        
        if manager.fileExists(atPath: path.path) {
            do {
                try manager.removeItem(at: path)
            } catch {
                print("UNABLE TO REMOVE")
            }
        }
    }
    
    func getAllFavoriteFiles(completionHandler: @escaping ([String]) -> Void) {
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let directoryContents = try manager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            let files = directoryContents.map { $0.lastPathComponent }
            completionHandler(files)
        } catch {
            completionHandler([])
        }
        
    }
}
