//
//  UIViewController+Reactive.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit

private var UIViewControllerSeguesConfigDictionaryKey: UInt8 = 0

typealias ViewModelConfiguration = (UIStoryboardSegue) -> Void

final private class ConfigurationsWrapper: NSObject {
    let configurations: [String: ViewModelConfiguration]?
    init(_ configurations: [String: ViewModelConfiguration]?) {
        self.configurations = configurations
    }
}

extension UIViewController {
    fileprivate var seguesConfigurationDictionary: [String: ViewModelConfiguration]? {
        get {
            let configurationsWrapper = objc_getAssociatedObject(self, &UIViewControllerSeguesConfigDictionaryKey) as? ConfigurationsWrapper
            return configurationsWrapper?.configurations
        }
        set {
            objc_setAssociatedObject(self, &UIViewControllerSeguesConfigDictionaryKey, ConfigurationsWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func set(configuration: ViewModelConfiguration?, forSegueWithIdentifier segueIdentifier: String?) {
        guard let segueIdentifier = segueIdentifier else {
            return
        }
        var seguesConfigurationMutableDictionary = self.seguesConfigurationDictionary ?? [:]
        guard let configuration = configuration else {
            seguesConfigurationMutableDictionary.removeValue(forKey: segueIdentifier)
            return
        }
        seguesConfigurationMutableDictionary[segueIdentifier] = configuration
        self.seguesConfigurationDictionary = seguesConfigurationMutableDictionary
    }
    
    fileprivate func configurationForSegue(_ segue: UIStoryboardSegue) -> ViewModelConfiguration? {
        guard let segueIdentifier = segue.identifier else {
            return .none
        }
        return self.seguesConfigurationDictionary?[segueIdentifier]
    }
    
    func performSegue(withIdentifier: String, sender: Any?, configuration: @escaping ViewModelConfiguration) {
        self.set(configuration: configuration, forSegueWithIdentifier: withIdentifier)
        self.performSegue(withIdentifier: withIdentifier, sender: sender)
    }
}
