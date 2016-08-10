//
//  Search.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation
import HTMLReader

protocol SearchProtocol {
    var term: String { get }
    var result: String? { get set }
    func search(_ completionHandler: (response: String?) -> Void)
}

extension SearchProtocol {

    /// Performs a search at EtymOnline
    ///
    /// - parameter text: the text to search for
    /// - parameter completionHandler: function to execute once the task is completed
    internal func search (_ completionHandler: (response:String?) -> Void) {

        /// Prepare the session and request objects
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: Config.eoURL + "/" + self.term)!)
        
        /// Define the task to perform - passed in as a closure
        let task : URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in

            /// Guard against missing data or an error
            guard let data = data else {
                print("No data returned")
                return
            }
            guard error == nil else {
                print(error)
                return
            }

            /// Define the response object
            let response = String(data: data, encoding: String.Encoding.utf8)
            print(response)
            completionHandler(response: response)
        }
        task.resume()
    }
}


