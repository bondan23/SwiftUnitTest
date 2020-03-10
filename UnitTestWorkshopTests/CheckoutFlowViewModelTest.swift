//
//  CheckoutFlowViewModelTest.swift
//  UnitTestWorkshopTests
//
//  Created by Bondan Prasetyo on 10/03/20.
//  Copyright © 2020 Tokopedia. All rights reserved.
//

import Quick
import RxCocoa
import RxSwift

@testable import UnitTestWorkshop

class MockNavigator: CheckoutFlowNavigator {
    func goToOpen1() -> Driver<String> {
        return .just("Bondan")
    }
    
    func goToOpen2() -> Driver<Int> {
        return .just(26)
    }
    
    func goToOpen3() -> Driver<Bool> {
        return .just(true)
    }
}

public class CheckoutFlowViewModelTest: QuickSpec {
    // MARK: Input
    private let inputFlowTrigger = PublishSubject<CheckoutFlow>()
    
    // MARK: Output
    private var goToOpen1: TestObserver<String>!
    private var goToOpen2: TestObserver<Int>!
    private var goToOpen3: TestObserver<Bool>!
    private var closeAll: TestObserver<CheckoutFlowData>!
    
    let navigator = MockNavigator()
    
    var disposebag = DisposeBag()
    
    private func setupBinding(viewModel: CheckoutFlowViewModel) {
        disposebag = DisposeBag()
        
        goToOpen1 = TestObserver<String>()
        goToOpen2 = TestObserver<Int>()
        goToOpen3 = TestObserver<Bool>()
        closeAll = TestObserver<CheckoutFlowData>()
        
        let input = CheckoutFlowViewModel.Input(flowTrigger: inputFlowTrigger.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.goToOpen1.drive(goToOpen1.observer).disposed(by: disposebag)
        output.goToOpen2.drive(goToOpen2.observer).disposed(by: disposebag)
        output.goToOpen3.drive(goToOpen3.observer).disposed(by: disposebag)
        output.closeAll.drive(closeAll.observer).disposed(by: disposebag)
        
//        domainNameValue = TestObserver<String>()
//        shopNameErrorValue = TestObserver<String?>()
//
//        let input = OpenShopViewModel.Input(
//            shopNameTrigger: inputShopNameTrigger.asDriverOnErrorJustComplete()
//        )
//
//        let output = viewModel.transform(input: input)
//
//        output.domainName.drive(domainNameValue.observer).disposed(by: disposebag)
//        output.shopNameError.drive(shopNameErrorValue.observer).disposed(by: disposebag)
    }
    
    
    public override func spec() {
        beforeEach {
            let viewModel = CheckoutFlowViewModel(navigator: self.navigator)
            self.setupBinding(viewModel: viewModel)
        }

        describe("Give me screen") {
            context("When open screen 1") {
                it("Then will generate name") {
                    self.inputFlowTrigger.onNext(.goToOpen1)
                    self.goToOpen1.assertValue("Bondan")
                }
            }
            
            context("When open screen 2") {
                fit("Lala") {
                    self.inputFlowTrigger.onNext(.goToOpen1)
                    self.goToOpen1.assertValue("Bondan")
                    self.inputFlowTrigger.onNext(.goToOpen2)
                    self.goToOpen2.assertValue(26)
                    self.inputFlowTrigger.onNext(.goToOpen3)
                    self.goToOpen3.assertValue(true)
                    self.inputFlowTrigger.onNext(.closeAll)
                    self.closeAll.assertValue(CheckoutFlowData(name: "Bondan", age: 26, isVerified: true))
                }
            }
        }
    }
}
