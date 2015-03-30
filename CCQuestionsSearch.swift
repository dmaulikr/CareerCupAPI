//
//  QuestionsSearch.swift
//  AlgorithmMatch
//
//  Created by Tullie on 24/03/2015.
//  Copyright (c) 2015 Tullie. All rights reserved.
//

import UIKit

class CCQuestionsSearch: NSObject {
   
    // Retrieves all recently added interview questions
    func loadRecentQuestions(page: UInt, companyID: String?, job: String?, topic: String?) -> [CCQuestion] {
        var questions: [CCQuestion] = []
        let questionsURLString = buildQuestionsURLString(page, company: companyID, job: job, topic: topic)
        let questionsURL = NSURL(string: questionsURLString)
        
        // Ensure CareerCup html data was found
        if let questionsPageHTMLData = NSData(contentsOfURL: questionsURL!) {
            let questionsParser = TFHpple(HTMLData: questionsPageHTMLData)
            let questionsQuery = "//li[@class='question']"
            let questionsNodes = questionsParser.searchWithXPathQuery(questionsQuery)
            
            // Iterate through each question text
            for element in questionsNodes as [TFHppleElement] {
                let questionText = extractQuestionText(element)
                let id = extractID(element)
                let company = extractCompany(element)
                let tags = extractTags(element)
               
                // Create question as long as question text is found
                if var safeText = questionText {
                    var question = CCQuestion(text: safeText, id: id, company: company, tags: tags)
                    questions += [question]
                }
            }
        } else {
           println("Career Cup page data can not be retrived")
        }
        
        return questions;
    }
    
    // Build url for recent Career Cup interview questions based on supplied paramters
    private func buildQuestionsURLString(page: UInt, company: String?, job: String?, topic: String?) -> String {
        var questionsURLString = "\(CareerCup.DOMAIN)/page?n=\(page)"
        if company != nil {
          questionsURLString += "&pid=\(company!)"
        }
        if job != nil {
            questionsURLString += "&job=\(job!)"
        }
        if topic != nil {
            questionsURLString += "&topic=\(topic!)"
        }
        return questionsURLString
    }
    
    // Extract question text from question element
    private func extractQuestionText(element: TFHppleElement) -> String? {
        let entryElement = element.firstChildWithClassName("entry")
        let questionElement = entryElement.firstChildWithTagName("a")
        return questionElement.content
    }
    
    // Extract question ID by parsing the id parameter from the question url endpoint
    private func extractID(element: TFHppleElement) -> String? {
        let entryElement = element.firstChildWithClassName("entry")
        let questionElement = entryElement.firstChildWithTagName("a")
        let hrefString = questionElement.attributes["href"] as String
        let startIndex = advance(find(hrefString, "=")!, 1)
        let range = Range(start: startIndex, end: hrefString.endIndex)
        return hrefString.substringWithRange(range)
    }
    
    // Extract company by looking at title attribute of image
    private func extractCompany(element: TFHppleElement) -> String? {
        let companyAndVoteElement = element.firstChildWithClassName("companyAndVote")
        let companyElement = companyAndVoteElement.childrenWithClassName("company")
        let imgElement = companyElement.first!.firstChildWithTagName("img")
        return imgElement.attributes["title"] as String?
    }
    
    // Extract any found tags
    private func extractTags(element: TFHppleElement) -> [String] {
        let tagsElement = element.firstChildWithClassName("tags")
        let tagsLinkElements = tagsElement.children as [TFHppleElement]
        return tagsLinkElements.map({$0.content as String})
    }
}
