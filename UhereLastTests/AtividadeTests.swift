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
    
    func test_initSaveDeleteAtividade() {
        let initialQuantity = Atividade.getAtividades().count
        let newAtividade = Atividade.init(nome: "atividade de test", tipo: "reuniao", data: Date(), alertaOffSet: 5.0, local: "none", anotacao: "none", cor: "FFFFFF", offSetString: "5 double")
        XCTAssertNotNil(newAtividade)

        Atividade.completeSave(atividade: newAtividade!, materia: nil)
        let quantityAfterSave = Atividade.getAtividades().count
        XCTAssertEqual(initialQuantity, quantityAfterSave - 1)
        
        Atividade.completeDelete(atividade: newAtividade!)
        let quantityAfterDelete = Atividade.getAtividades().count
        XCTAssertEqual(initialQuantity, quantityAfterDelete)
    }
    
    func test_getAtividadeWithoutMateria() {
        let atividadesWithOutMateria = Atividade.getAtividadesWithOutMateria()
        for atividade in atividadesWithOutMateria {
            XCTAssertEqual(true, atividade.relationship == nil)
        }
    }
    
    func test_shouldCreateCorrectId() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateTimeFormat
        let date = dateFormatter.date(from: "24/01/1997 - 8:00 am")
        let id = Atividade.generateAtividadeId(materiaName: "indefinido", title: "reuniao com a diretoria", date: date!)
        
        XCTAssertEqual(id, "atividadeindefinidoreuniao com a diretoria24/01/1997 - 8:00 AM")
    }
}
