//
//  Answer.swift
//  AlgorithmMatch
//
//  Created by Tullie on 22/03/2015.
//  Copyright (c) 2015 Tullie. All rights reserved.
//

import UIKit

public class Answer: NSObject {
    var answerText: String!
    var upVotes: String!
    
    init(text: String, upvotes: String) {
        self.answerText = text.capitilizedFirstLetter
        self.upVotes = upvotes
    }
}
