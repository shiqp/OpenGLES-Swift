//
//  ViewController.swift
//  OpenGLES01
//
//  Created by Qingpu Shi on 2018/5/17.
//  Copyright © 2018 Qish. All rights reserved.
//

import UIKit
import GLKit

extension Array {
    func size() -> Int {
        if self.count > 0 {
            return self.count * MemoryLayout.size(ofValue: self[0])
        }
        return 0
    }
}

struct SceneVertex {
    var positionCoords : GLKVector3
}

var vertices = [
    SceneVertex(positionCoords: GLKVector3Make(-0.5, -0.5, 0.0)),
    SceneVertex(positionCoords: GLKVector3Make(0.5, -0.5, 0.0)),
    SceneVertex(positionCoords: GLKVector3Make(0.5, 0.5, 0.0)),
    SceneVertex(positionCoords: GLKVector3Make(-0.5, 0.5, 0.0))
]

enum AGLKVertexAttrib: GLuint {
    case position = 0
    case normal = 1
    case color = 2
    case texCoord0 = 3
    case texCoord1 = 4
}

class ViewController: GLKViewController {

    var bufferID = GLuint()
    var baseEffect = GLKBaseEffect()

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view as! GLKView
        view.context = EAGLContext(api: .openGLES3)!
        EAGLContext.setCurrent(view.context)

        glGenBuffers(1, &self.bufferID)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.bufferID)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.size(), vertices, GLenum(GL_STATIC_DRAW))

        self.baseEffect.useConstantColor = GLboolean(GL_TRUE)
        self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0)

        glClearColor(0.0, 0.0, 0.0, 1.0)
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        self.baseEffect.prepareToDraw()

        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        glEnableVertexAttribArray(AGLKVertexAttrib.position.rawValue)

        glVertexAttribPointer(AGLKVertexAttrib.position.rawValue,
                              3,
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<SceneVertex>.size),
                              nil)

        glDrawArrays(GLenum(GL_TRIANGLE_FAN),
                     0,
                     GLsizei(vertices.count))
    }

}
