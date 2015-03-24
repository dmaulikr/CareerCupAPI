//
//  CareerCup.swift
//  AlgorithmMatch
//
//  Created by Tullie on 16/03/2015.
//  Copyright (c) 2015 Tullie. All rights reserved.
//

import UIKit

// Career Cup API Facade
public class CareerCup: NSObject {
    let DOMAIN = "http://www.careercup.com"
    private let answersSearch = CCAnswersSearch()
    private let questionsSearch = CCQuestionsSearch()
    
    // Retrieves all recently added interview questions
    public func loadRecentQuestions(page: UInt, companyID: String?, job: String?, topic: String?) -> [CCQuestion] {
        return questionsSearch.loadRecentQuestions(page, companyID: companyID, job: job, topic: topic)
    }
    
    // Retrive answers from question ID
    public func loadAnswersWithID(id: String) -> [CCAnswer] {
       return answersSearch.loadAnswersWithID(id)
    }
}
