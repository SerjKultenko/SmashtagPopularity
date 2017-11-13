//
//  OperationsResults.swift
//  HBCRM
//
//  Created by Sergei Kultenko on 24/10/2017.
//  Copyright © 2017 Sergei Kultenko. All rights reserved.
//

import Foundation

enum ResultWithoutData {
    case fail(withError: Error)
    case success
}

typealias CompletionClosureWithoutData = (_ result: ResultWithoutData) -> Void

enum RequestResult<DataType> {
    case fail(withError: Error)
    case success(withObject: DataType)
}

typealias RequestCompletionClosure<DataType> = (_ result: RequestResult<DataType>) -> Void
