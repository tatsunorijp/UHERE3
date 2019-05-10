//
//  Prova+CoreDataClass.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 18/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Prova)
public class Prova: NSManagedObject {
    
    convenience init?(nome: String, peso: Double, nota: Double, diaHora: Date, offSet: Double, offSetString: String){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Prova.entity(), insertInto: managedContext)
        self.nome = nome
        self.peso = peso
        self.nota = nota
        self.diaHora = diaHora as NSDate
        self.alertaOffSet = offSet
        self.offSetString = offSetString

    }
    
    static func save(prova: Prova, materia: Materia){
        materia.addToRawProvas(prova)
        do{
            try prova.managedObjectContext?.save()
            print("Prova salva com sucesso")
        } catch {
            print("Erro ao cadastrar nova prova")
        }
    }
    
    static func change(prova: Prova){
        do{
            try prova.managedObjectContext?.save()
            print("Prova alterada com sucesso")
        } catch {
            print("Erro ao alterar prova")
        }
    }
    
    static func delete(prova: Prova){
        
        prova.managedObjectContext?.delete(prova)
        do{
            try prova.managedObjectContext?.save()
            print("prova deletada")
        } catch {
            print("Erro ao deletar prova")
        }
    }
    
    static func getProvas() -> Array<NSManagedObject>{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Prova> = Prova.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        }catch let erro{
            print(erro.localizedDescription)
            print("Erro ao tentar recuperar provas")
        }
        
        return []
    }
}
