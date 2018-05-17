//
//  AGLKVertexAttribArrayBuffer.swift
//  OpenGL
//
//  Created by Qingpu Shi on 2018/5/16.
//  Copyright © 2018 Qish. All rights reserved.
//

import GLKit

enum AGLKVertexAttrib: GLuint {
    case position = 0
    case normal = 1
    case color = 2
    case texCoord0 = 3
    case texCoord1 = 4
}

class AGLKVertexAttribArrayBuffer: NSObject {

    var stride = GLsizei()              // 每个顶点的字节数
    var bufferByteSize = GLsizeiptr()   // 缓存大小
    var bufferID = GLuint()             // 缓存标识

    /// 创建顶点数组缓存
    ///
    /// - Parameters:
    ///   - stride:         步幅
    ///   - vertexCount:    顶点数目
    ///   - data:           顶点内存地址
    ///   - usage:          是否缓存于GPU
    func config(withAttribStride stride: GLsizei, vertexCount: GLsizei, data: UnsafeRawPointer, usage: GLenum) {
        self.stride = stride
        self.bufferByteSize = GLsizeiptr(stride * vertexCount)

        glGenBuffers(1, &self.bufferID)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.bufferID)
        glBufferData(GLenum(GL_ARRAY_BUFFER), self.bufferByteSize, data, usage)
    }

    /// 准备绘制
    ///
    /// - Parameters:
    ///   - index:                      顶点属性
    ///   - coordsCount:                坐标轴数
    ///   - attribOffset:               从每个起始顶点的偏移量
    ///   - enableVertexAttribArray:    启动或禁用
    func prepareToDraw(withVertexAttrib index: AGLKVertexAttrib, coordsCount: GLint, attribOffset: GLsizeiptr, enableVertexAttribArray: Bool) {
        if (enableVertexAttribArray) {
            glEnableVertexAttribArray(index.rawValue)
        }

        glVertexAttribPointer(index.rawValue,
                              coordsCount,
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              self.stride,
                              UnsafeRawPointer(bitPattern: attribOffset))
    }

    func drawArray(withMode mode: GLenum, startVertexIndex: GLint, vertexCount: GLsizei) {
        glDrawArrays(mode, startVertexIndex, vertexCount)
    }

    deinit {
        if 0 != self.bufferID {
            glDeleteBuffers(1, &self.bufferID)
            self.bufferID = 0
        }
    }
}
