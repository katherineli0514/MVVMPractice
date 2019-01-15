//
//  ViewModel.swift
//  MVVMPractice
//
//  Created by Katherine Li on 1/10/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import Foundation
import UIKit

/**
 #1 - Define a closure TYPE for updating a UIImageView once an image downloads.
 
 - parameter imageData: raw NSData making up the image
 */

public typealias ImageDownloadCompletationClosure = (_ imageData: NSData) -> Void

// MARK: - #2 - App data through ViewModel

var messierViewModel: [MessierViewModel] =
    [MessierViewModel(messierDataModel: Messier1),
     MessierViewModel(messierDataModel: Messier8),
     MessierViewModel(messierDataModel: Messier57)]

// MARK: - #3 - View Model

class MessierViewModel {
    // #4 - I use some private properties solely for
    // preparing data for presentation in the UI.
    
    private let messierDataModel: MessierDataModel
    private var imageURL: URL
    private var updatedDate: Date?
    
    init(messierDataModel: MessierDataModel)
    {
        self.messierDataModel = messierDataModel
        self.imageURL = URL(string: messierDataModel.imageLink)!
    }
    
    public var formalName: String {
        return "Formal name: " + messierDataModel.formalName
    }
    
    public var commonName: String {
        return "Common name: " + messierDataModel.commonName
    }
    
    // #5 - Data is made available for presentation only
    // through public getters. No direct access to Model.
    // Some getters prepare data for presentation.
    
    public var dateUpdated: String {
        let dateString = String(messierDataModel.updateDate.year) + "-" +
                         String(messierDataModel.updateDate.month) + "-" +
                         String(messierDataModel.updateDate.day)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: dateString) {
            updatedDate = date
            return "Updated: " + dateFormatterPrint.string(from: date)
        } else {
            return "There was an error decoding the string"
        }
    }
    
    // #6 - Controversial? Should this SOLELY live in the UI?
    public var textDescription: NSAttributedString {
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "Georgia", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor.blue]
        let markedUpDescription = NSAttributedString(string: messierDataModel.description, attributes: fontAttributes)
        return markedUpDescription
    }
    
    public var thumbnail: String {
        return messierDataModel.thumbnail
    }
    
    //#7 - Controversial? Is passing a completion handler into the view model problematic?
    // Should I use KVO or delegation?
    // All's I'm doing is getting some NSData/Data
    func download(completationHandler: @escaping ImageDownloadCompletationClosure) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: imageURL)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    let rawImageData = NSData(contentsOf: tempLocalUrl)
                    completationHandler(rawImageData!)
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(String(describing: error?.localizedDescription))")
            }
        } // end let task
        task.resume()
    } // end func download
} // end class MessierViewModel

