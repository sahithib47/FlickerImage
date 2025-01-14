import Foundation

class FlickerimageViewModel: ObservableObject {
    private let flickrService: FlickrServiceProtocol
    
    @Published var flickerData: FlickrPhoto?
    @Published var itemsData: [Item]?
    @Published var showSpinner: Bool = false
    
    init(flickrService: FlickrServiceProtocol = FlickrService()) {
        self.flickrService = flickrService
        getImages()
    }
    
    func getImages(tagString: String = "porcupine") {
        self.showSpinner = true
        flickrService.fetchImages(with: tagString) { result in
            DispatchQueue.main.async {
                self.showSpinner = false
                switch result {
                case .success(let data):
                    self.flickerData = data
                    self.itemsData = data.items
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
}
