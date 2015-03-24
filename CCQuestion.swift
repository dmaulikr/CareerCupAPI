//
//  Question.swift
//  AlgorithmMatch
//
//  Created by Tullie on 16/03/2015.
//  Copyright (c) 2015 Tullie. All rights reserved.
//

import UIKit

public class CCQuestion: NSObject {
    var questionText: String = ""
    var id: String?
    var company: String?
    var tags: [String] = []
    
    init(text: String, id: String?, company: String?, tags: [String]) {
        super.init()
        self.questionText = text.capitilizedFirstLetter
        self.id = id
        self.company = company
        self.tags = tags
    }
    
}
