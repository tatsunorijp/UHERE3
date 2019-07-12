//
//  UhereLastTests.swift
//  UhereLastTests
//
//  Created by Wellington Tatsunori Asahide on 10/07/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import XCTest
import CoreData

@testable import UhereLast
class AtividadeTests: XCTestCase {
    var atividade: Atividade!
    
    override func setUp() {
        super.setUp()
        atividade = Atividade()
    }

    override func tearDown() {
    }

    func testPerformanceExample() {
        self.measure {
        }
    }
    
    func test_initSaveDeleteAtividade() {
        let newAtividade = Atividade.init(nome: "atividade de test", tipo: "reuniao", data: Date(), alertaOffSet: 5.0, local: "none", anotacao: "none", cor: "FFFFFF", offSetString: "5 double")
        XCTAssertNotNil(newAtividade)

        let quantityAtividadesBeforeSave = Atividade.getAtividades().count
        Atividade.save(atividade: newAtividade!)
        let quantityAtividadesAfterSave = Atividade.getAtividades().count
        XCTAssertEqual(quantityAtividadesBeforeSave, quantityAtividadesAfterSave - 1)
        
        let quantityAtividadesBeforDelete = Atividade.getAtividades().count
        Atividade.delete(atividade: newAtividade!)
        let quantityAtividadesAfterDelete = Atividade.getAtividades().count
        XCTAssertEqual(quantityAtividadesBeforDelete, quantityAtividadesAfterDelete + 1)
    }
    
    func test_getAtividadeWithoutMateria() {
        let atividadesWithOutMateria = Atividade.getAtividadesWithOutMateria()
        var isAtividadeWithMateria: Bool = false
        for atividade in atividadesWithOutMateria {
            isAtividadeWithMateria = isAtividadeWithMateria || (atividade.relationship == nil)
        }
        
        XCTAssertEqual(isAtividadeWithMateria, false)
    }
    
    

}
