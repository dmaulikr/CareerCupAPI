//
//  CareerCup.swift
//  AlgorithmMatch
//
//  Created by Tullie on 16/03/2015.
//  Copyright (c) 2015 Tullie. All rights reserved.
//

import UIKit

public class CareerCup: NSObject {
    let DOMAIN = "http://www.careercup.com"
    
    public func loadAnswersWithID(id: String) -> [Answer] {
        var answers: [Answer] = []
        let answersURLString = "\(DOMAIN)/question?id=\(id)"
        let answersURL = NSURL(string: answersURLString)
        
        // Ensure html data was found
        if let answersPageHTMLData = NSData(contentsOfURL: answersURL!) {
            let answersParser = TFHpple(HTMLData: answersPageHTMLData)
            let answersQuery = "//div[@id='commentThread\(id)']//div[@class='comment']" // //div[@class='commentBody']"
            let answerNodes = answersParser.searchWithXPathQuery(answersQuery)
            
            for element in answerNodes as [TFHppleElement] {
                let answerText = extractAnswerText(element)
                let votes = extractUpVotes(element)
                
                // Print results
                println(answerText)
                println(votes)
                println("--------------------------------------------")
                
                if answerText != nil && votes != nil {
                    var answer = Answer(text: answerText!, upvotes: votes!)
                    answers += [answer]
                }
            }
            
        } else {
           println("Page data can not be retrived")
        }
        
        return answers;
    }
    
    // Returns all recently added interview questions
    public func loadRecentQuestions(page: UInt, companyID: String?, job: String?, topic: String?) -> [Question] {
        var questions: [Question] = []
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
               
                // Print results
                println(questionText)
                println(id)
                println(company)
                println(tags)
                println("--------------------------------------------")
                
                // Create question as long as question text is found
                if var safeText = questionText {
                    var question = Question(text: safeText, id: id, company: company, tags: tags)
                    questions += [question]
                }
            }
        } else {
           println("Page data can not be retrived")
        }
        
        return questions;
    }
    
    // Extracts answer text from answer element
    private func extractAnswerText(element: TFHppleElement) -> String? {
        let answerMainElement = element.firstChildWithClassName("commentMain")
        let answerBody = answerMainElement.firstChildWithClassName("commentBody")
        let answerBodyChildren = answerBody.children as [TFHppleElement]
        
        // Remove author tag element and concatenate text
        let answerTextNodeArray = answerBodyChildren.filter({$0.attributes["class"] as String? != "author"})
        let answerTextArray = answerTextNodeArray.map({$0.content}) as [String]
        return join("", answerTextArray)
    }
    
    // Extracts upvotes from answer element
    private func extractUpVotes(element: TFHppleElement) -> String? {
        let votesWrapperElement = element.firstChildWithClassName("votesWrapper")
        let votesNet = votesWrapperElement.firstChildWithClassName("votesNet")
        return votesNet.content
    }
    
    // Build url for recent Career Cup interview questions based on supplied paramters
    private func buildQuestionsURLString(page: UInt, company: String?, job: String?, topic: String?) -> String {
        var questionsURLString = "\(DOMAIN)/page?n=\(page)"
        if company != nil {
          questionsURLString += "&pid=\(company)"
        }
        if job != nil {
            questionsURLString += "&job=\(job)"
        }
        if topic != nil {
            questionsURLString += "&topic=\(topic)"
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
