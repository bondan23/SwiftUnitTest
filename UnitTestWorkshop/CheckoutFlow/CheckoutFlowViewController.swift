//
//  CheckoutFlowViewController.swift
//  UnitTestWorkshop
//
//  Created by Bondan Prasetyo on 10/03/20.
//  Copyright © 2020 Tokopedia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


protocol CheckoutFlowNavigator {
    func goToOpen1() -> Driver<String>
    func goToOpen2() -> Driver<Int>
    func goToOpen3() -> Driver<Bool>
}

internal struct DefaultNavigator: CheckoutFlowNavigator  {
    let navVc: UINavigationController
    init(navVc: UINavigationController) {
        self.navVc = navVc
    }
    
    func goToOpen1() -> Driver<String> {
//        let vc = Open1ViewController()
////        vc.onSuccess -> Driver<String>
//        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//        return vc.onSuccess
        return .empty()
    }
    
    func goToOpen2() -> Driver<Int> {
        return .empty()
    }
    
    func goToOpen3() -> Driver<Bool> {
        return .empty()
    }
}

struct CheckoutFlowData: Equatable {
    let name: String
    let age: Int
    let isVerified: Bool
}


enum CheckoutFlow {
    case goToOpen1
    case goToOpen2
    case goToOpen3
    case closeAll
}

class CheckoutFlowViewModel: ViewModelType {
    let navigator: CheckoutFlowNavigator
    
    init(navigator: CheckoutFlowNavigator) {
        self.navigator = navigator
    }
    
    struct Input {
        let flowTrigger: Driver<CheckoutFlow>
    }
    
    struct Output {
        let goToOpen1: Driver<String>
        let goToOpen2: Driver<Int>
        let goToOpen3: Driver<Bool>
        let closeAll: Driver<CheckoutFlowData>
    }
    
    
    func transform(input: Input) -> Output {
        
        let flowTrigger = input.flowTrigger
        
        let goToOpen1 = flowTrigger.filter { flow -> Bool in
            if case .goToOpen1 = flow {
                return true
            }
            
            return false
        }.flatMapLatest { [navigator] _ in
            navigator.goToOpen1()
        }
        
        let goToOpen2 = flowTrigger.filter { flow -> Bool in
            if case .goToOpen2 = flow {
                return true
            }
            
            return false
        }.flatMapLatest { [navigator] _ in
            navigator.goToOpen2()
        }
        
        let goToOpen3 = flowTrigger.filter { flow -> Bool in
            if case .goToOpen3 = flow {
                return true
            }
            
            return false
        }.flatMapLatest { [navigator] _ in
            navigator.goToOpen3()
        }
        
        let allData = Driver.combineLatest(goToOpen1, goToOpen2, goToOpen3)
        
        let closeAll = flowTrigger
            .filter{ $0 == .closeAll }
            .withLatestFrom(allData)
            .map { (args) -> CheckoutFlowData in
            let (name,age,verified) = args
            
            return CheckoutFlowData(name: name, age: age, isVerified: verified)
        }
        
        return Output(
            goToOpen1: goToOpen1,
            goToOpen2: goToOpen2,
            goToOpen3: goToOpen3,
            closeAll: closeAll
        )
    }
    
}

class CheckoutFlowViewController: UIViewController {
    lazy var embeddedNavigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.view.backgroundColor = .white
        nav.navigationBar.isTranslucent = false
        return nav
    }()
    
    let baseVc = BaseViewController()
    
    lazy var navigator : DefaultNavigator = {
        DefaultNavigator(navVc: self.embeddedNavigationController)
    }()
    
    lazy var viewModel = CheckoutFlowViewModel(navigator: self.navigator)
    
    let flowTrigger = PublishSubject<CheckoutFlow>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigationController()
        embeddedNavigationController.setViewControllers([baseVc], animated: false)
    }
    
    private func bindViewModel() {
        
//        baseVc.button.rx.tap.asDriver(onNext:{ [flowTrigger] in
//            flowTrigger.onNext(.goToOpen1)
//        })
        
        let input = CheckoutFlowViewModel.Input(
            flowTrigger: flowTrigger.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input: input)
        
        output.goToOpen1.drive(onNext: { string in
            
        }).disposed(by: rx_disposeBag)
        
        output.closeAll.drive(onNext: { [weak self] data in
//            self?.embeddedNavigationController.setViewControllers([self.baseVc], animated: true)
        })
        
    }
    
    private func setupNavigationController() {
        view.addSubview(embeddedNavigationController.view)
        addChild(embeddedNavigationController)
        embeddedNavigationController.didMove(toParent: self)
    }
}
