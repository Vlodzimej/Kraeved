//
//  ImageManager.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 21.11.2022.
//

import UIKit

// MARK: - ImageManagerProtocol
protocol ImageManagerProtocol: AnyObject {
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

// MARK: - ImageManager
final class ImageManager: ImageManagerProtocol {

    static let shared = ImageManager()

    // MARK: Properties
    let urlCache = URLCache.shared

    private let apiManager: APIManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol

    // MARK: Init
    private init(apiManager: APIManagerProtocol = APIManager.shared, coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
    }

    // MARK: Public Methods
    // Функция получения и кэширования изображений в CoreData
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let result = coreDataManager.find(entityName: "ImageCoreModel", predicates: [NSPredicate(format: "%K = %@", "imageUrl", url.absoluteString)])
        if result.isEmpty {
            apiManager.getData(from: url) { [weak self] data, response, error in
                guard error == nil, let self = self, let data = data, let response = response, let image = UIImage(data: data) else { return }
                ImageCoreModel(data: data, imageUrl: url.absoluteString)
                self.coreDataManager.saveContext()
                print(response.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                completion(image)
            }
        } else if let imageCoreData = result.first as? ImageCoreModel, let data = imageCoreData.data, let image = UIImage(data: data) {
            completion(image)
        }
    }

    func downloadCachedImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let request = URLRequest(url: url)
        if let data = urlCache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            completion(image)
        } else {
            print("Download Started")
            apiManager.getData(from: url) { [weak self] data, response, error in
                guard error == nil, let self = self, let data = data, let response = response, let image = UIImage(data: data) else { return }
                let cacheData = CachedURLResponse(response: response, data: data)
                self.urlCache.storeCachedResponse(cacheData, for: request)
                print(response.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                completion(image)
            }
        }
    }
}
