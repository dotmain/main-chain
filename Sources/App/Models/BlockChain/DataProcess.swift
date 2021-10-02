//
//  DataProcess.swift
//  
//
//  Created by m4m4 on 24.06.21.
//

protocol Processor {
    func apply(to value: inout Double)
}

struct DataProcess: Processor {
    func apply(to value: inout Double) {
        value = value * 1.25
    }
}
