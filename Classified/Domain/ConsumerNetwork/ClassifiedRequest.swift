//
//  ClassifiedResource.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import Foundation
import NetworkModule

final class ClassifiedRequest: RequestBuilder {
    typealias Response = ClassifiedList

    var method: HTTPMethod = .get
    var path: String = "default/dynamodb-writer"
    var parameters: [String: Parameter]?
    var baseURL: String = "ey3f2y0nre.execute-api.us-east-1.amazonaws.com"
    var additionalHeaders: [AdditionalHeaders] = []

    func parse(data: Data, response: HTTPURLResponse) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(ClassifiedList.self, from: data)
    }

}
