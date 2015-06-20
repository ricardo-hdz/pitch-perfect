//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ricardo Hdz on 6/17/15.
//  Copyright (c) 2015 Ricardo Hdz. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: NSString!

    init(filePathUrl: NSURL!, title: NSString!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}