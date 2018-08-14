//
//  Service.swift
//  Grocery Challenge
//
//  Created by Andrew Crookston on 5/29/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

protocol Requests {
    var url: URL { get }
}

protocol Service {
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void)
}

extension Service {

    func get(request: Requests, completion: @escaping (Result<Data>) -> Void) {

        URLSession.shared.dataTask(with: request.url) { data, response, error in

            if let error = error {
                completion(.error(.otherError(error)))
                return
            }

            guard let data = data else {
                completion(.error(APIError.invalidData))
                return
            }

            completion(.success(data))

            }.resume()
    }
}
