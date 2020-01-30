//
//  API.swift
//  QuizChallenge
//
//  Created by Fernanda de Lima on 30/01/20.
//  Copyright © 2020 Felima. All rights reserved.
//

import Foundation

enum Endpoint {
    case challenge(Int)
    func pathEndpoint() -> String {
        switch self {
        case .challenge(let number): return "quiz/\(number)"
        }
    }
}

class API {
    static let baseUrl = "https://codechallenge.arctouch.com/"
    static func get <T: Any>
        (_ type: T.Type,
         endpoint: Endpoint,
         success:@escaping (_ item: T) -> Void,
         fail:@escaping (_ error: Error) -> Void) where T: Decodable {
        let url = "\(baseUrl)\(endpoint.pathEndpoint())"
        print("===>url: \(url)")
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //create session to connection
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                //verify response
                if let httpResponse = response as? HTTPURLResponse {
                    print("===>code response: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200 { //it's ok
                        //verify if have response data
                        if let data = data {
                            let jsonDecoder = JSONDecoder()
                            let jsonArray = try jsonDecoder.decode(type.self, from: data)
                            success(jsonArray)
                        }
                    }
                }
            } catch {
                fail(error)
            }
        })
        task.resume()
    }
}
