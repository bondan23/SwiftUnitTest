//
//  CreateShopViewModel.swift
//  TokopediAlone
//
//  Created by Bondan Eko Prasetyo on 15/07/19.
//  Copyright © 2019 Jefferson Setiawan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxOptional

class OpenShopViewModel: ViewModelType {
    struct Input {
        let inputShopNameTrigger: Driver<String>
    }
    
    struct Output {
        let domainNameValue: Driver<String>
    }
    
    private let useCase: OpenShopUsecase
    
    init(useCase: OpenShopUsecase) {
        self.useCase = useCase
    }
    
    func transform(input: OpenShopViewModel.Input) -> OpenShopViewModel.Output {
        return Output(domainNameValue: .empty())
    }
}
