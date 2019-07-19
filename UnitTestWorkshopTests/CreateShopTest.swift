//
//  CreateShopTest.swift
//  TokopediAloneTests
//
//  Created by Bondan Eko Prasetyo on 15/07/19.
//  Copyright © 2019 Jefferson Setiawan. All rights reserved.
//

import Quick
import XCTest
import RxCocoa

@testable import UnitTestWorkshop

private class CreateShopTest: CreateShopViewModelBaseTest {
    override func spec() {
        var useCase = CreateShopUsecase()
        beforeEach {
            // Reset Before each
            useCase = CreateShopUsecase()
            self.setupBinding(viewModel: CreateShopViewModel(useCase: useCase))
        }
        
        describe("Opening shop") {
            context("Typing shop name") {
                it("valid shopname, will generate domain name suggestion") {
                    self.inputShopNameSubject.onNext("test")
                    self.domainNameValue.assertValue("test-4")
                }
                
                it("invalid shopname, still show a valid domain name"){
                   
                }
                
                it("shows error when shop name has less than 3 characters") {
                   
                }
                
                it("shows error when shop name start or end with spacing") {
                   
                }
                
                it("shows error when contain emoji") {
                    
                }
            }
            
            context("Typing domain name") {
                it("domain name valid"){
                    
                }
                
                it("domain name not valid") {
                    
                }
                
                it("show error when domain name has less than 3 characters") {
                    
                }
            }
            
            context("Select city") {
                it("shows selected city") {
                    
                }
                
                it("shows error when city is not selected") {
                    
                }
                
                it("does not show error when city is already selected") {
                    
                }
            }
            
            context("Select postal code") {
                it("show error city is required, when click postal code without select the city first") {
                    
                }
                
                it("select city and select postal code") {
                    
                }
                
                it("should reset postal code after select a new city"){
                    
                }
            }
        }
    }
}

