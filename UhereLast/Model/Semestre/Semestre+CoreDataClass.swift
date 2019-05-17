//
//  Semestre+CoreDataClass.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 17/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit
import RxSwift
import RxCocoa

@objc(Semestre)
public class Semestre: NSManagedObject {
    var materias: [Materia]? {
        return self.rawMaterias?.array as? [Materia]
        
    }
    
    
    convenience init?(nome: String, dataInicio: Date, dataFim: Date) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Semestre.entity(), insertInto: managedContext)
        self.nome = nome
        self.dataInicio = dataInicio as NSDate?
        self.dataFim = dataFim as NSDate?
        
    }
    
    static func save(semestre: Semestre){
        do{
            try semestre.managedObjectContext?.save()
        } catch {
            print("Erro ao cadastrar novo semestre")
        }
    }
    
    static func delete(semestre: Semestre){
        semestre.managedObjectContext?.delete(semestre)
        do{
            try semestre.managedObjectContext?.save()
        } catch {
            print("Erro ao cadastrar novo semestre")
        }
    }
    
    static func getSemestres() -> Array<NSManagedObject>{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Semestre> = Semestre.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        }catch let erro{
            print(erro.localizedDescription)
            print("Erro ao tentar recuperar semestres")
        }
        
        return []
    }
    
    static func getSemestresRx() -> Observable<[Semestre]>{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Semestre> = Semestre.fetchRequest()
        
        do {
            return try Observable.from(optional: managedContext.fetch(fetchRequest))
        }catch let erro{
            print(erro.localizedDescription)
            print("Erro ao tentar recuperar semestres")
        }
        
        return Observable.from([])
    }
    
    
}
