//
//  CCAnswersSearch.swift
//  AlgorithmMatch
//
//  Created by Tullie on 24/03/2015.
//  Copyright (c) 2015 Tullie. All rights reserved.
//

import UIKit

class CCAnswersSearch: NSObject {
   
    // Retrive answers from question ID
    func loadAnswersWithID(id: String) -> [CCAnswer] {
        var answers: [CCAnswer] = []
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
                    var answer = CCAnswer(text: answerText!, upvotes: votes!)
                    answers += [answer]
                }
            }
            
        } else {
           println("Page data can not be retrived")
        }
        
        return answers;
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
    
}
