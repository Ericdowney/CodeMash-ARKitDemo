//
//  UIStoryboard+Utilities.swift
//  ARDemo
//
//  Created by Eric Downey on 12/10/18.
//  Copyright © 2018 downey. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiate(withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
