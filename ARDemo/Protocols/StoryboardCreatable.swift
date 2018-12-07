//
//  StoryboardCreatable.swift
//  ARDemo
//
//  Created by Downey, Eric on 12/5/18.
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
