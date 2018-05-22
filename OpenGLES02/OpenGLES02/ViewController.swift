//
//  ViewController.swift
//  OpenGLES02
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
    var textureCoords: GLKVector2
}

var vertices = [
    SceneVertex(positionCoords: GLKVector3Make(-0.5, -0.5, 0.0),
                textureCoords: GLKVector2Make(0.0, 1.0)),
    SceneVertex(positionCoords: GLKVector3Make(0.5, -0.5, 0.0),
                textureCoords: GLKVector2Make(1.0, 1.0)),
    SceneVertex(positionCoords: GLKVector3Make(0.5, 0.5, 0.0),
                textureCoords: GLKVector2Make(1.0, 0.0)),
    SceneVertex(positionCoords: GLKVector3Make(-0.5, 0.5, 0.0),
                textureCoords: GLKVector2Make(0.0, 0.0))
]

class ViewController: GLKViewController {

    var vertexBuffer = AGLKVertexAttribArrayBuffer()
    var baseEffect = GLKBaseEffect()
    var context: AGLKContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! GLKView
        self.context = AGLKContext(api: .openGLES3)
        view.context = self.context!
        AGLKContext.setCurrent(view.context)

        self.vertexBuffer.config(withAttribStride: GLsizei(MemoryLayout<SceneVertex>.size),
                                 vertexCount: GLsizei(vertices.count),
                                 data: vertices,
                                 usage: GLenum(GL_STATIC_DRAW))

        let imageRef = UIImage(named: "sky")?.cgImage

        var textureInfo: GLKTextureInfo!
        do {
            textureInfo = try GLKTextureLoader.texture(with: imageRef!, options: nil)
        } catch {

        }

        self.baseEffect.texture2d0.name = textureInfo.name
        self.baseEffect.texture2d0.target = GLKTextureTarget(rawValue: textureInfo.target)!
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        baseEffect.prepareToDraw()

        self.context!.clear(GLbitfield(GL_COLOR_BUFFER_BIT))

        self.vertexBuffer.prepareToDraw(withVertexAttrib: .position,
                                        coordsCount: 3,
                                        attribOffset: 0,
                                        enableVertexAttribArray: true)

        self.vertexBuffer.prepareToDraw(withVertexAttrib: .texCoord0,
                                        coordsCount: 2,
                                        /*
                                         GLfloat // <-- structure start
                                         GLfloat // <-- position
                                         GLfloat
                                         GLfloat
                                         GLfloat // <-- texture
                                         GLfloat
                                         ptr = sizeof(GLfloat) * 4œ
                                         */
                                        attribOffset: MemoryLayout<GLfloat>.size * 4,
                                        enableVertexAttribArray: true)


        self.vertexBuffer.drawArray(withMode: GLenum(GL_TRIANGLE_FAN), startVertexIndex: 0, vertexCount: GLsizei(vertices.count))
    }

}
