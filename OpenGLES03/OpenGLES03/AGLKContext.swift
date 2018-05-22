//
//  AGLKContext.swift
//  OpenGL
//
//  Created by Qingpu Shi on 2018/5/16.
//  Copyright © 2018 Qish. All rights reserved.
//

import GLKit

class AGLKContext: EAGLContext {

    var clearColor: GLKVector4 {
        set {
            self.clearColor = newValue
            glClearColor(
                newValue.r,
                newValue.g,
                newValue.b,
                newValue.a
            )
        }
        get {
            return self.clearColor
        }
    }

    func clear(_ mask: GLbitfield) {
        glClear(mask)
    }

    func disable(_ capability: GLenum) {
        glDisable(capability)
    }

    func enable(_ capability: GLenum) {
        glEnable(capability)
    }
}
