//
//  Created by Mikhail Sergeev on 18.10.2020.
//

import Foundation

class Matrix {
    
    // MARK: - Public Property
    
    var result: [String] = []
    
    // MARK: - Private Property
    
    private var matrixA: [[Double]] = []
    private var matrixB: [Double] = []
    
    // MARK: - Initializers
    
    init(matrixA a: [[Double]], matrixB b: [Double]) {
        self.matrixA = a
        self.matrixB = b
    }
    
    // MARK: - Public methods
    
    func gauss() -> [Double] {
        let count = matrixA.count
        
        for step in 0 ..< count-1 {
            
            changeRows(step: step)
            
            for j in step..<count - 1 {
                let m: Double = matrixA[j + 1][step]/matrixA[step][step]
                let bMain: Double = matrixB[step]
                let bCurrent: Double = matrixB[j + 1]
                let bNew = bCurrent - bMain*m
                
                matrixB[j + 1] = bNew
                
                for i in step..<count {
                    let aMain = matrixA[step][i]
                    let aCurrent = matrixA[j + 1][i]
                    let aNew = aCurrent - aMain*m
                    matrixA[j + 1][i]=aNew
                }
            }
        }
        
        var step = count - 1
        var arrayXn: [Double] = Array(repeating: 0, count: count)
        
        while step>=0 {
            let b = matrixB[step]
            var sumXn: Double = 0
            
            for i in step ..< count {
                sumXn += matrixA[step][i]*arrayXn[i]
            }
            
            let Xn=(b - sumXn)/matrixA[step][step]
            arrayXn[step] = Xn
            step -= 1
        }
        
        result = arrayXn.map({String(format: "%.03f", $0)})
        return arrayXn
    }
    
    // MARK: - Private Methods
    
    private func changeRows(step: Int) -> () {
        var commonMatrix = {() -> [[Double]] in
            var new: [[Double]] = []
            
            for i in 0 ..< matrixB.count {
                new.append(matrixA[i])
                new[i].append(matrixB[i])
            }
            
            return new
        }()
        
        let commonMatrix1 = commonMatrix.prefix(upTo: step)
        
        var commonMatrix2 = Array(commonMatrix.suffix(from: step))
        commonMatrix2.sort(by: {abs($0[step]) > abs($1[step])})
        
        commonMatrix = commonMatrix1 + commonMatrix2
        
        matrixB = commonMatrix.map({$0.last!})
        matrixA = commonMatrix.map({$0.dropLast()})
    }
    
}
