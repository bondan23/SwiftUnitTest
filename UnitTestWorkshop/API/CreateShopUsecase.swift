//
//  DummyUsecase.swift
//  TokopediAlone
//
//  Created by Bondan Eko Prasetyo on 12/07/19.
//  Copyright © 2019 Jefferson Setiawan. All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation

class CreateShopUsecase {
    var getDomainName = _getDomainName
    var checkShopNameAvailability = _checkShopNameAvailability
    var checkDomainNameAvailability = _checkDomainNameAvailability
    var getPostalCode = _getPostalCode
}

func _getDomainName(_ name: String) -> Driver<String> {
    fatalError()
}

func _checkShopNameAvailability(_ name: String) -> Driver<String?> {
    fatalError()
}

func _checkDomainNameAvailability(_ name: String) -> Driver<String?> {
    fatalError()
}

func _getPostalCode(_ city: City) -> Driver<String?> {
    fatalError()
}
