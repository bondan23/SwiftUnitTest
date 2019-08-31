//
//  CreateShopViewModel.swift
//  TokopediAlone
//
//  Created by Bondan Eko Prasetyo on 15/07/19.
//  Copyright © 2019 Jefferson Setiawan. All rights reserved.
//

import Foundation
import RxCocoa
import RxOptional
import RxSwift

class OpenShopViewModel: ViewModelType {
    struct Input {
        let shopNameTrigger: Driver<String>
    }
    
    struct Output {
        let domainName: Driver<String>
        let shopNameError: Driver<String?>
    }
    
    private let useCase: OpenShopUsecase
    
    init(useCase: OpenShopUsecase) {
        self.useCase = useCase
    }
    
    func transform(input: OpenShopViewModel.Input) -> OpenShopViewModel.Output {
        let getDomainName = input.shopNameTrigger.flatMapLatest { [useCase] name in
            useCase.getDomainName(name)
        }
        
        let lessThan3 = input.shopNameTrigger
            .filter {
                $0.count < 3 && !$0.hasPrefix(" ") && !$0.hasSuffix(" ")
            }
            .map { _ -> String? in
                .some("Less than 3 characters")
            }
        
        let containEmptySpace = input.shopNameTrigger
            .filter { $0.hasPrefix(" ") || $0.hasSuffix(" ") }
            .map { _ -> String? in
                .some("Should not start or end with empty space")
            }
        
        let checkShopName = input.shopNameTrigger.filter {
            $0.count > 3 && !$0.hasPrefix(" ") && !$0.hasSuffix(" ")
        }
        .flatMapLatest { [useCase] name in
            useCase.checkShopName(name)
        }
        
        let shopNameError = Driver.merge(
            lessThan3,
            containEmptySpace,
            checkShopName
        )
        
        return Output(
            domainName: getDomainName,
            shopNameError: shopNameError
        )
    }
}
