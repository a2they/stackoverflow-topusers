//
//  ImageLoader.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

import UIKit

class ImageLoader: ObservableObject {

    @Published var image: UIImage?

    func loadImage(from stringURL: String) {
        guard let url = URL(string: stringURL) else { return }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)

        // Check if image is in cache
        if let cachedResponse = cache.cachedResponse(for: request) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        // Fetch image not cached
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error downloading image: \(error.debugDescription)")
                return
            }
        
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }

            // Store image in cache
            let cachedData = CachedURLResponse(response: httpResponse, data: data)
            cache.storeCachedResponse(cachedData, for: request)
        }.resume()
    }
}
