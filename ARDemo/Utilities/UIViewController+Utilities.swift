//
//  UIViewController+Utilities.swift
//  ARDemo
//
//  Created by Eric Downey on 12/4/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit

protocol StoryboardCreatable {
    static var storyboardId: String { get }
}

extension StoryboardCreatable where Self: UIViewController {
    static func instantiate() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
}
