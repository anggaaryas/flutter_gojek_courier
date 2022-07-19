//
//  Param.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 14/07/22.
//

import Foundation


class Param<T>{
    
    let value: Dictionary<String, Any?>
    
    init(value: Dictionary<String, Any?>){
        self.value = value
    }
    
    func build() -> T? {
        fatalError("build has not been implemented")
    }
}

class EnumParam<T> {
    
    let value: String
    
    init(value: String) {
        self.value = value
    }
    
    func build() -> T? {
        fatalError("build has not been implemented")
    }
}
