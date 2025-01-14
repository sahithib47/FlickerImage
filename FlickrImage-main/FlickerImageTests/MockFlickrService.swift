import Foundation
import XCTest
@testable import FlickerImage

class MockFlickrService: FlickrServiceProtocol {
    
    // Function to load the local JSON file for testing
    private func loadLocalJSONFile(named fileName: String) -> Data? {
        let bundle = Bundle(for: type(of: self)) // Test bundle
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            return try? Data(contentsOf: url)
        }
        return nil
    }
    
    func fetchImages(with tagString: String, completion: @escaping (Result<FlickrPhoto, APIError>) -> Void) {
        if let data = loadLocalJSONFile(named: "response") {
            do {
                let decodedData = try JSONDecoder().decode(FlickrPhoto.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        } else {
            completion(.failure(.noData))
        }
    }
}
