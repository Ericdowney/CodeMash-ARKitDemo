//
//  SceneKit+Utilities.swift
//  ARDemo
//
//  Created by Downey, Eric on 12/3/18.
//  Copyright © 2018 downey. All rights reserved.
//

import SceneKit

extension simd_float4x4 {
    var matrix4: SCNMatrix4 {
        return SCNMatrix4(self)
    }
}
