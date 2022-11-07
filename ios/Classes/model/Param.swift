//
//  Param.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 14/07/22.
//

import Foundation


class Param{
    
    let value: Dictionary<String, Any?>
    
    init(value: Dictionary<String, Any?>){
        self.value = value
    }
    

    func setClassParam(value: Any? , onNotNull: (Dictionary<String, Any?>) -> Void){
        if let param = value as? Dictionary<String, Any?> {
            onNotNull(param)
        }
    }
    
    func setBasicParam<T>(value: Any? , onNotNull: (T) -> Void){
        if let param = value as? T {
            onNotNull(param)
        }
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
