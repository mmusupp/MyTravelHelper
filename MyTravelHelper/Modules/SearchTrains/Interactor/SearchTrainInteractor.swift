//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing
import Alamofire

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        if Reach().isNetworkReachable() == true {
            WebServiceHelper().requestDataTask(WebServiceURLs.fetchallStations) { (data) in
                let station = try? XMLDecoder().decode(Stations.self, from: data!)
                print(String(decoding: data!, as: UTF8.self))
                self.presenter!.stationListFetched(list: station!.stationsList)
            } failure: { (response, error) in
                self.presenter!.handleWebServiceError(error: error)
            }

            /*Alamofire.request("http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML")
                .response { (response) in
                let station = try? XMLDecoder().decode(Stations.self, from: response.data!)
                print(String(decoding: response.data!, as: UTF8.self)
)
                self.presenter!.stationListFetched(list: station!.stationsList)
            }*/
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        let urlString = "\(WebServiceURLs.fetchTrainsFromSource)\(sourceCode)"
        if Reach().isNetworkReachable() {
            /*Alamofire.request(urlString).response { (response) in
                let stationData = try? XMLDecoder().decode(StationData.self, from: response.data!)
                if let _trainsList = stationData?.trainsList {
                    self.proceesTrainListforDestinationCheck(trainsList: _trainsList)
                } else {
                    self.presenter!.showNoTrainAvailbilityFromSource()
                }
            }*/
            
            WebServiceHelper().requestDataTask(urlString) { (data) in
                let stationData = try? XMLDecoder().decode(StationData.self, from: data!)
                if let _trainsList = stationData?.trainsList {
                    self.proceesTrainListforDestinationCheck(trainsList: _trainsList)
                } else {
                    self.presenter!.showNoTrainAvailbilityFromSource()
                }
            } failure: { (response, error) in
                
            }
            
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        let today = Date()
        let group = DispatchGroup()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: today)
        
        for index  in 0...trainsList.count-1 {
            group.enter()
            let _urlString = "\(WebServiceURLs.proceesTrainListforDestinationCheck)\(trainsList[index].trainCode)&TrainDate=\(dateString)"
            if Reach().isNetworkReachable() {
                WebServiceHelper().requestDataTask(_urlString) { (data) in
                    let trainMovements = try? XMLDecoder().decode(TrainMovementsData.self, from: data!)
                    if let _movements = trainMovements?.trainMovements {
                        let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                        let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                        let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                        let isDestinationAvailable = desiredStationMoment.count == 1

                        if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                            _trainsList[index].destinationDetails = desiredStationMoment.first
                        }
                    }
                    group.leave()
                    
                } failure: { (response, error) in
                    
                }
                
                /*Alamofire.request(_urlString).response { (movementsData) in
                    let trainMovements = try? XMLDecoder().decode(TrainMovementsData.self, from: movementsData.data!)

                    if let _movements = trainMovements?.trainMovements {
                        let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                        let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                        let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                        let isDestinationAvailable = desiredStationMoment.count == 1

                        if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                            _trainsList[index].destinationDetails = desiredStationMoment.first
                        }
                    }
                    group.leave()
                }*/
            } else {
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
}
