//
//  DateFormatter.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit

enum DateFormat: String {
    case shortDate           = "d MMMM"
    case shortDateAndTime    = "dd MMMM HH:mm"
    case longDateAndTime     = "dd MMMM yyyy HH:mm"
    case longDate            = "d MMMM yyyy"
    case numericDate         = "d'.'MM'.'yy"
    case numericDateAndTime  = "HH:mm d'.'MM'.'yy"
}

class DateFormatter: NSObject {
    
    private static let sharedInstance = DateFormatter()
    private var dateFormatters: [String: Foundation.DateFormatter] = [:]
    
    private let accessQueue = DispatchQueue(label: "com.MVVMSample.date-foramtter")
    
    private override init() {}
    
    class func stringFromDate(_ date: Date?, dateFormat: DateFormat) -> String? {
        return date.flatMap { sharedInstance.stringFromDate($0, dateFormat: dateFormat) }
    }
    
    //use this method to get formatted data string
    private func stringFromDate(_ date: Date?, dateFormat: DateFormat) -> String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = dateFormatters(withDateFormat: dateFormat.rawValue)
        
        return dateFormatter.string(from: date)
    }
    
    private func dateFormatters(withDateFormat dateFormat: String) -> Foundation.DateFormatter {
        
        var dateFormatter: Foundation.DateFormatter?
        self.accessQueue.sync {
            dateFormatter = self.dateFormatters[dateFormat]
            
            if dateFormatter == nil {
                dateFormatter = Foundation.DateFormatter()
                dateFormatter!.locale = Locale.current
                dateFormatter!.dateFormat = dateFormat
                self.dateFormatters[dateFormat] = dateFormatter
            }
        }
        return dateFormatter!
    }
}
