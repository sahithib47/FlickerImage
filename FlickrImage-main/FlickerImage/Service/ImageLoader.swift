import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    private var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    self.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                }
            }
        }.resume()
    }
}
