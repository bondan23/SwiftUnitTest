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
        
        let isLessThan3 = input.shopNameTrigger.map{ $0.count < 3 }
        let isContainSpace = input.shopNameTrigger.map{ $0.hasPrefix(" ") || $0.hasSuffix(" ") }
        let isContainEmoji = input.shopNameTrigger.map{ $0.containsEmoji }
        
        let validShopName = Driver.combineLatest(isLessThan3, isContainSpace, isContainEmoji).map{
            !$0 && !$1 && !$2
        }
        
        let checkShopName = input.shopNameTrigger.withLatestFrom(validShopName){
            ($0, $1)
        }
        .filter{ $0.1 }
        .map{ $0.0 }
        .flatMapLatest { [useCase] name in
            useCase.checkShopName(name)
        }
        
        let shopNameError = Driver.merge(
            checkShopName,
            isLessThan3.filter{ $0 }.map{ _ in .some("Less than 3 characters")},
            isContainSpace.filter{ $0 }.map{ _ in .some("Should not start or end with empty space")},
            isContainEmoji.filter{ $0 }.map{ _ in .some("Should not contain emoji")}
        )
        
        return Output(
            domainName: getDomainName,
            shopNameError: shopNameError
        )
    }
}
