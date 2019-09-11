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
    var getDomainNameSuggestion = OpenShopUsecase.getDomainNameSuggestion
    var checkShopName = OpenShopUsecase.checkShopName
    
    static func getDomainNameSuggestion(name: String) -> Observable<String> {
        return Observable.empty()
    }
    
    static func checkShopName(name: String) -> Observable<String?> {
        return Observable.empty()
    }
}
