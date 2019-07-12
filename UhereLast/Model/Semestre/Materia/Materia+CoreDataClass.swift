//
//  Materia+CoreDataClass.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 17/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Materia)
public class Materia: NSManagedObject {
    
    var provas: [Prova]? {
        return self.rawProvas?.array as? [Prova]
        
    }
    
    var atividades: [Atividade]?{
        return self.rawAtividades?.array as? [Atividade]
    }
    
    var falta: [Falta]? {
        return self.rawFaltas?.array as? [Falta]
    }
    
    
    convenience init?(nome: String, local: String, professor: String, limiteFaltas: Int, faltas: Int, cor: String, offSet: Double, offSetString: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Materia.entity(), insertInto: managedContext)
        self.nome = nome
        self.local = local
        self.professor = professor
        self.limiteFalta = Int32(limiteFaltas)
        self.faltas = Int32(faltas)
        self.cor = cor
        self.alertaOffSet = offSet
        self.offSetString = offSetString
    }
    
    static func save(materia: Materia, semestre: Semestre){
        semestre.addToRawMaterias(materia)
        do{
            try materia.managedObjectContext?.save()
            print("Materia salva com sucesso")
        } catch {
            print("Erro ao cadastrar nova materia")
        }
    }
    
    static func change(materia: Materia){
        do{
            try materia.managedObjectContext?.save()
            print("Dados da materia alterados com sucesso")
        } catch {
            print("Erro ao alterar dados de materia")
        }
    }
    
    static func delete(materia: Materia){
        materia.managedObjectContext?.delete(materia)
        do{
            try materia.managedObjectContext?.save()
        } catch {
            print("Erro ao deletar materia")
        }
    }
    
    static func getMaterias() -> Array<NSManagedObject>{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Materia> = Materia.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        }catch let erro{
            print(erro.localizedDescription)
            print("Erro ao tentar recuperar materias")
        }
        
        return []
    }
    
    static func getMateriasWithAtividades() -> [Materia] {
        let materias = getMaterias() as! [Materia]
        var materiasWithAtividade: [Materia] = []
        
        for materia in materias {
            if materia.atividades?.count ?? 0 > 0 {
                materiasWithAtividade.append(materia)
            }
        }
        return materiasWithAtividade
    }
}
