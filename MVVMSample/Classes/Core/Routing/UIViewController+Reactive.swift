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
    
    class func swizzle() {
        if self !== UIViewController.self {
            return
        }
        DispatchQueue.once {
            let originalSelector = #selector(self.prepare(for:sender:))
            let swizzledSelector = #selector(self.routing_prepareForSegue(_:sender:))
            guard
                let originalMethod = class_getInstanceMethod(self, originalSelector),
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
                else {
                    return
            }
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    @objc func routing_prepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?) {
        self.routing_prepareForSegue(segue, sender: sender)
        if let configuration = self.configurationForSegue(segue) {
            configuration(segue)
        }
        self.set(configuration: nil, forSegueWithIdentifier: segue.identifier)
    }
}
