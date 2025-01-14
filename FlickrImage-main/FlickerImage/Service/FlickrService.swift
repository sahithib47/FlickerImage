import Foundation


protocol FlickrServiceProtocol {
    func fetchImages(with tagString: String, completion: @escaping (Result<FlickrPhoto, APIError>) -> Void)
}

class FlickrService: FlickrServiceProtocol {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchImages(with tagString: String, completion: @escaping (Result<FlickrPhoto, APIError>) -> Void) {
        
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tagString)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        apiClient.makeRequest(with: url, responseType: FlickrPhoto.self) { result in
            completion(result)
        }
    }
}

