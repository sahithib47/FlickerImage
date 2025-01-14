import XCTest
@testable import FlickerImage

class FlickerimageViewModelTests: XCTestCase {

    var viewModel: FlickerimageViewModel!
    var mockFlickrService: MockFlickrService!

    override func setUp() {
        super.setUp()
        mockFlickrService = MockFlickrService()
        viewModel = FlickerimageViewModel(flickrService: mockFlickrService)
    }

    override func tearDown() {
        viewModel = nil
        mockFlickrService = nil
        super.tearDown()
    }

    func testFetchImagesFromLocalJSON() {
        let expectation = self.expectation(description: "Fetching images from local JSON")
        viewModel.getImages()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.viewModel.flickerData)
            XCTAssertEqual(self.viewModel.flickerData?.title, "Recent Uploads tagged porcupine")
            XCTAssertEqual(self.viewModel.itemsData?.count, 20)

            let firstItem = self.viewModel.itemsData?.first
            XCTAssertEqual(firstItem?.title, "Over the Shoulder")
            XCTAssertEqual(firstItem?.author, "nobody@flickr.com (\"MTSOfan\")")
            XCTAssertEqual(firstItem?.media.m, "https://live.staticflickr.com/65535/54025349347_fdc356ae01_m.jpg")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

}

