//
//  Dispatch.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 20/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:() -> Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    public class func once(token: String, block:() -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
