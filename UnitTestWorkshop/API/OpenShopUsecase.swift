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
}

private func _getDomainName(name: String) -> Driver<String> {
    fatalError()
}
