//
//  QosParam.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 14/07/22.
//

import Foundation
import CourierCore

class QosParam: EnumParam<QoS>{

    override func build() -> QoS {
        switch value {
        case "ZERO" :
            return QoS.zero
        case "ONE" :
            return QoS.one
        case "TWO" :
            return QoS.two
        default:
            fatalError("unknown qos : " + value)

        }
    }
}
