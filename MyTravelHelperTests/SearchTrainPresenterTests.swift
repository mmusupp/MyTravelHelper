//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    var interactor = SearchTrainInteractorMock()
    
    override func setUp() {
        presenter = SearchTrainPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
    }

    func testFetchallStations_shouldCallSaveFetchedStation_shouldCallSaveFetchedStatins() {
        presenter.fetchallStations()
        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
        XCTAssertNotNil(presenter.stationsList)
        XCTAssertNotNil(view.stationsList)
    }
    
    
    
    func  testFetchallStations_checkWebserviceEoor_ShouldCallHandleWebServiceError()  {
        interactor.isApiSuccess = false
        presenter.fetchallStations()
        XCTAssertTrue(view.isHandleWebServiceErrorCalled)
    }
    
    func  testFetchallStations_checkShowNoTrainAvailbilityFromSourceCall_ShouldCallShowNoTrainAvailbilityFromSourceror()  {
        interactor.isNoTrainAvailbility = true
        presenter.fetchallStations()
        XCTAssertTrue(view.isShowNoTrainAvailbilityFromSourceCalled)
    }
    
    
    func  testFetchallStations_checkshowNoTrainAvailbilityFromSource_shouldCallshowNoTrainAvailbilityFromSource ()  {
        interactor.isNoInterNetAvailability = true
        presenter.fetchallStations()
        XCTAssertTrue(view.isShowNoInterNetAvailabilityMessageCalled)
    }


    func testsearchTapped_withValidCode_shouldReturnStations() {
        presenter.stationsList = self.getMockStation()
        presenter.searchTapped(source: "BFSTC", destination: "BFSTC1")
        XCTAssertTrue(view.isupdateLatestTrainListCalled)
        XCTAssertNotNil(presenter.stationsList)
        XCTAssertNotNil(view.stationsList)
    }
    
    func testsearchTapped_withValidCode_shouldCcall_showNoTrainsFoundAlert() {
        presenter.stationsList = self.getMockStation()
        interactor.fetchTrainsFromSource_WithWrongCode = true
        presenter.searchTapped(source: "BFSTC222", destination: "BFSTC12222")
        XCTAssertTrue(view.isShowNoTrainsFoundAlertCalled)
    }
}

class SearchTrainMockView:PresenterToViewProtocol {

    var isSaveFetchedStatinsCalled = false
    var isupdateLatestTrainListCalled = false
    var isHandleWebServiceErrorCalled = false
    var isShowNoTrainAvailbilityFromSourceCalled  = false
    var isShowNoInterNetAvailabilityMessageCalled  = false
    var isShowNoTrainsFoundAlertCalled = false
    
    var stationsList:[Station]? = [Station]()
    var stationTrains:[StationTrain]? = [StationTrain]()
    
    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
        self.stationsList = stations
    }

    func updateLatestTrainList(trainsList: [StationTrain]) {
        isupdateLatestTrainListCalled = true
        self.stationTrains = trainsList
    }
    
    func showNoTrainAvailbilityFromSource() {
        isShowNoTrainAvailbilityFromSourceCalled = true
    }
    
    func showNoInterNetAvailabilityMessage() {
        isShowNoInterNetAvailabilityMessageCalled = true
    }
    
    func handleWebServiceError(error: Error?) {
        isHandleWebServiceErrorCalled = true
    }
    
    func showNoTrainsFoundAlert() {
        self.isShowNoTrainsFoundAlertCalled = true
    }
    
    func showInvalidSourceOrDestinationAlert() {
        
    }
}

class SearchTrainInteractorMock:PresenterToInteractorProtocol {
    
    var presenter: InteractorToPresenterProtocol?
    var isApiSuccess = true
    var isNoTrainAvailbility = false
    var isNoInterNetAvailability = false
    var isNoTrainsFoundAlert = false
    var fetchTrainsFromSource_WithWrongCode = false
    
    func fetchallStations() {
        let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
        if isNoTrainAvailbility == true {
            presenter?.showNoTrainAvailbilityFromSource()
            return
        }
        
        if isNoInterNetAvailability == true {
            presenter?.showNoInterNetAvailabilityMessage()
            return
        }
        
        if isApiSuccess {
            presenter?.stationListFetched(list: [station])
            return
        }
        
        presenter?.handleWebServiceError(error: nil)

    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        if !fetchTrainsFromSource_WithWrongCode {
            let stationTrain_1 = StationTrain(trainCode: "001", fullName: "Train#0001", stationCode: "BFSTC", trainDate: "2/05/2021", dueIn: 0, lateBy: 20, expArrival: "12.30", expDeparture: "12.55 PM")
            let stationTrain_2 = StationTrain(trainCode: "002", fullName: "Train#0002", stationCode: "BFSTC1", trainDate: "2/05/2021", dueIn: 0, lateBy: 20, expArrival: "12.30", expDeparture: "1.30 PM")
            presenter?.fetchedTrainsList(trainsList: [stationTrain_1, stationTrain_2])
            return
        }
        presenter?.fetchedTrainsList(trainsList: nil)
    }
}


extension SearchTrainPresenterTests {
    func getMockStation() -> [Station] {
        return ([Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228),
                Station(desc: "Belfast Central1", latitude: 54.6123, longitude: -5.91744, code: "BFSTC1", stationId: 228),
                Station(desc: "Belfast Central2", latitude: 54.6123, longitude: -5.91744, code: "BFSTC2", stationId: 228)])
    }
}
