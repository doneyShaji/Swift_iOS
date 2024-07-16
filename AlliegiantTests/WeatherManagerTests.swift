import XCTest
@testable import Alliegiant

class WeatherManagerTests: XCTestCase {
    
    var mockWeatherManager: MockWeatherManager!
    
    override func setUp() {
        super.setUp()
        mockWeatherManager = MockWeatherManager()
    }
    
    func testFetchData() {
        // Arrange
        let expectation = self.expectation(description: "Fetch data")
        mockWeatherManager.mockData = [("Item 1", "thumb1.jpg", "Description 1", 10.0, "Brand 1")]
        
        // Act
        mockWeatherManager.fetchData(for: "electronics") { result in
            // Assert
            XCTAssertTrue(self.mockWeatherManager.fetchDataCalled)
            XCTAssertEqual(self.mockWeatherManager.lastFetchedCategory, "electronics")
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result[0].0, "Item 1")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPerformRequest() {
        // Arrange
        let expectation = self.expectation(description: "Perform request")
        mockWeatherManager.mockData = [("Item 2", "thumb2.jpg", "Description 2", 20.0, "Brand 2")]
        let testURL = "https://example.com/api"
        
        // Act
        mockWeatherManager.performRequest(weatherURL: testURL) { result in
            // Assert
            XCTAssertTrue(self.mockWeatherManager.performRequestCalled)
            XCTAssertEqual(self.mockWeatherManager.lastRequestedURL, testURL)
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result[0].1, "thumb2.jpg")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testParseJSON() {
        // Arrange
        mockWeatherManager.mockData = [("Item 3", "thumb3.jpg", "Description 3", 30.0, "Brand 3")]
        let dummyData = Data()
        
        // Act
        let result = mockWeatherManager.parseJSON(weatherData: dummyData)
        
        // Assert
        XCTAssertTrue(mockWeatherManager.parseJSONCalled)
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[0].2, "Description 3")
    }
}
