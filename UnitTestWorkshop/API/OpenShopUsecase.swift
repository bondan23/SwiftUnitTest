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

class OpenShopUsecase {
    var getDomainName = _getDomainName
    var checkShopName = _checkShopName
}

private func _getDomainName(name: String) -> Driver<String> {
    fatalError()
}

private func _checkShopName(name: String) -> Driver<String?> {
    fatalError()
}
