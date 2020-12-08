//
//  PrepareMatrix.swift
//  Gauss
//
//  Created by Mikhail Sergeev on 24.10.2020.
//

import Foundation
import Cocoa

class PrepareMatrix {
    
    // MARK: - Public property
    
    var matrixA: [[Double]] = []
    var matrixB: [Double] = []
    
    // MARK: - Private Property
    
    private var arrayA: [NSTextField] = []
    private var arrayB: [NSTextField] = []
    private var size: Int = 0
    
    // MARK: - Initializers
    
    init(arrayA: [NSTextField], arrayB: [NSTextField], size: Int) {
        self.arrayA = arrayA
        self.arrayB = arrayB
        self.size = size
    }
    
    // MARK: - Public Methods
    
    func prepareMatrix() {
        var a = Array(repeating: Array(repeating: 0.00, count: size), count: size)

        for i in 0 ..< arrayA.count {
            a[i/size][i % size] = Double(arrayA[i].stringValue) ?? 0.00
        }
        
        var b = Array(repeating: 0.00, count: size)
        
        for i in 0 ..< arrayB.count {
            b[i] = Double(arrayB[i].stringValue) ?? 0.00
        }
        
        matrixA = a
        matrixB = b
    }
    
}
