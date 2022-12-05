//
//  HomeViewControllerTests.swift
//  ByCodersAppTests
//
//  Created by Pedro Henrique Calado on 04/12/22.
//

import XCTest

@testable import ByCodersApp
class HomeViewControllerTests: XCTestCase {
    func test_init_doesNotSaveUserLocation() {
        let (_, viewModel) = makeSUT()
        
        XCTAssertEqual(viewModel.saveUserLocationCount, 0, "Expect no save requests before view is loaded")
    }
    
    func test_userLocation_callsSaveUserLocationOnViewDidLoad() {
        let (sut, viewModel) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(viewModel.saveUserLocationCount, 1, "Expect save user requests after view is loaded")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: HomeViewController, viewModel: HomeViewModelSpy) {
        let viewModel = HomeViewModelSpy()
        let sut = HomeViewController(viewModel: viewModel)
    
        return (sut, viewModel)
    }
    
    class HomeViewModelSpy: HomeViewModelProtocol {
        var saveUserLocationCount = 0
        
        func saveUserLocation(latitude: Double?, longitude: Double?) {
            saveUserLocationCount += 1
        }
    }
}
