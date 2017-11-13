//
//  TweetInfoSection.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 02/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import Foundation

class TweetInfoSection
{
    var sectionTitle: String
    var sectionType: TweetInfoSectionType
    let numberOfRows: Int
    let titleForRowProvider: (Int) -> String
    let objectForRowProvider: (Int) -> Any

    func title(forRow row: Int) -> String {
        return titleForRowProvider(row)
    }

    func object(forRow row: Int) -> Any {
        return objectForRowProvider(row)
    }

    init(title: String,
         type: TweetInfoSectionType,
         rowsNumber: Int,
         titleForRowProvider: @escaping (Int) -> String,
         objectForRowProvider: @escaping (Int) -> Any?)
    {
        sectionTitle = title
        sectionType = type
        numberOfRows = rowsNumber
        self.titleForRowProvider = titleForRowProvider
        self.objectForRowProvider = objectForRowProvider
    }
}
