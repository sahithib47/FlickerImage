import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError(Error)
}

class APIClient {
    let session: URLSession

    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    func makeRequest<T: Decodable>(with url: URL, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {

        let request = URLRequest(url: url)

        // Create a data task to handle the request
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            // Handle the response data
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }
}
