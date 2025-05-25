//
//  MultiplicationExample.swift
//  MetalStudy
//
//  Created by 임영택 on 5/26/25.
//

import Foundation
import Metal
import MetalPerformanceShaders

struct MultiplicationExample {
    static func mpsMatrixMultiplication() -> String {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return "Metal 디바이스를 찾을 수 없습니다."
        }
        
        let commandQueue = device.makeCommandQueue()!
        
        let rowsA = 512
        let colsA = 1024
        let rowsB = 1024
        let colsB = 256
        
        let resultRows = rowsA
        let resultCols = colsB
        
        // 고정된 값으로 테스트 일관성 유지
        let aValues = (0..<(rowsA * colsA)).map { _ in Float.random(in: 0..<1) }
        let bValues = (0..<(rowsB * colsB)).map { _ in Float.random(in: 0..<1) }
        
        let aBuffer = device.makeBuffer(bytes: aValues, length: MemoryLayout<Float>.size * aValues.count, options: [])!
        let bBuffer = device.makeBuffer(bytes: bValues, length: MemoryLayout<Float>.size * bValues.count, options: [])!
        let resultBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * resultRows * resultCols, options: [])!
        
        let rowBytesA = colsA * MemoryLayout<Float>.size
        let rowBytesB = colsB * MemoryLayout<Float>.size
        let rowBytesR = resultCols * MemoryLayout<Float>.size
        
        let matrixA = MPSMatrix(buffer: aBuffer, descriptor: MPSMatrixDescriptor(rows: rowsA, columns: colsA, rowBytes: rowBytesA, dataType: .float32))
        let matrixB = MPSMatrix(buffer: bBuffer, descriptor: MPSMatrixDescriptor(rows: rowsB, columns: colsB, rowBytes: rowBytesB, dataType: .float32))
        let matrixR = MPSMatrix(buffer: resultBuffer, descriptor: MPSMatrixDescriptor(rows: resultRows, columns: resultCols, rowBytes: rowBytesR, dataType: .float32))
        
        let mm = MPSMatrixMultiplication(device: device,
                                         transposeLeft: false,
                                         transposeRight: false,
                                         resultRows: resultRows,
                                         resultColumns: resultCols,
                                         interiorColumns: colsA,
                                         alpha: 1.0,
                                         beta: 0.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        mm.encode(commandBuffer: commandBuffer, leftMatrix: matrixA, rightMatrix: matrixB, resultMatrix: matrixR)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        let resultPointer = resultBuffer.contents().bindMemory(to: Float.self, capacity: resultRows * resultCols)
        
        // 결과 문자열 (일부만 출력: 5x5)
        var output = ""
        for i in 0..<min(5, resultRows) {
            for j in 0..<min(5, resultCols) {
                let value = resultPointer[i * resultCols + j]
                output += String(format: "%.2f\t", value)
            }
            output += "\n"
        }
        
        return output
    }
    
    static func cpuMatrixMultiplication() -> String {
        let rowsA = 512
        let colsA = 1024
        let rowsB = 1024
        let colsB = 256
        
        let aFlat = (0..<(rowsA * colsA)).map { _ in Float.random(in: 0..<1) }
        let bFlat = (0..<(rowsB * colsB)).map { _ in Float.random(in: 0..<1) }
        
        // 2D로 변환
        let a = (0..<rowsA).map { i in
            Array(aFlat[(i * colsA)..<(i * colsA + colsA)])
        }
        
        let b = (0..<rowsB).map { i in
            Array(bFlat[(i * colsB)..<(i * colsB + colsB)])
        }
        
        var result = Array(repeating: Array(repeating: Float(0), count: colsB), count: rowsA)
        
        for i in 0..<rowsA {
            for j in 0..<colsB {
                var sum: Float = 0
                for k in 0..<colsA {
                    sum += a[i][k] * b[k][j]
                }
                result[i][j] = sum
            }
        }
        
        // 결과 문자열 (일부만 출력: 5x5)
        var output = ""
        for i in 0..<min(5, rowsA) {
            for j in 0..<min(5, colsB) {
                output += String(format: "%.2f\t", result[i][j])
            }
            output += "\n"
        }
        
        return output
    }
}
