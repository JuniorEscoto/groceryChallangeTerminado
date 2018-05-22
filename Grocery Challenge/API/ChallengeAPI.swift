//
//  ChallengeAPI.swift
//  Grocery Challenge
//
//  Created by Andrew Crookston on 5/14/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

protocol API {
    func image(from url: URL, _ completion: @escaping (Result<URL>) -> Void)
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void)
}

enum Requests: String {
    case questions = "https://gist.github.com/acrookston/e1af7bf2e2607db3d27a0b44ed1843c1/raw/490d746e54e774476652cf8ab65f9c912e54e95f/question.json"

    var url: URL {
        return URL(string: self.rawValue)!
    }
}

class ChallengeAPI: API {
    init() { }

    func get(request: Requests, completion: @escaping (Result<Data>) -> Void) {
        URLSession.shared.dataTask(with: request.url) { (data, response, error) in
            if let error = error {
                completion(.error(error))
                return
            }
            guard let data = data else {
                completion(.error(APIError.invalidData))
                return
            }
            completion(.success(data))
        }.resume()
    }

    func image(from url: URL, _ completion: @escaping (Result<URL>) -> Void) {
        URLSession.shared.downloadTask(with: url) { (url, response, error) in
            if let error = error {
                completion(.error(error))
                return
            }
            guard let url = url else {
                completion(.error(APIError.invalidData))
                return
            }
            completion(.success(url))
        }.resume()
    }
}

enum APIError: Error {
    case invalidData
}
