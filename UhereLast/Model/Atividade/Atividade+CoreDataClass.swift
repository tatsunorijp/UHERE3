//
//  Atividade+CoreDataClass.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 25/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Atividade)
public class Atividade: NSManagedObject {
    
    convenience init?(nome: String, tipo: String, data: Date, alertaOffSet: Double, local: String, anotacao: String, cor: String, offSetString: String){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Atividade.entity(), insertInto: managedContext)
        self.nome = nome
        self.tipo = tipo
        self.diaHora = data as NSDate
        self.alertaOffSet = alertaOffSet
        self.local = local
        self.anotacao = anotacao
        self.cor = cor
        self.offSetString = offSetString
        
    }
    
    static func save(atividade: Atividade){
        do{
            try atividade.managedObjectContext?.save()
            print("Atividade SEM MATERIA salva com sucesso")
        } catch {
            print("Erro ao cadastrar nova atividade")
        }
    }
    
    static func saveWithMateria(materia: Materia, atividade: Atividade){
        materia.addToRawAtividades(atividade)
        do{
            try atividade.managedObjectContext?.save()
            print("Atividade com materia salva com sucesso")
        } catch {
            print("Erro ao cadastrar nova atividade")
        }
    }
    
    static func change(atividade: Atividade){
        do{
            try atividade.managedObjectContext?.save()
            print("Atividade SEM MATERIA alterada com sucesso")
        } catch {
            print("Erro ao alterar atividade")
        }
    }
    
    static func removeMateriaReference(materia: Materia, atividade: Atividade){
        materia.removeFromRawAtividades(atividade)
        do{
            try atividade.managedObjectContext?.save()
            print("Sucesso ao remover dependencia")
        } catch {
            print("Erro ao remover dependencia com atividade")
        }
    }
    
    static func changeWithMateria(oldMateria: Materia, newMateria: Materia, atividade: Atividade){
        
        oldMateria.removeFromRawAtividades(atividade)
        newMateria.addToRawAtividades(atividade)
        do{
            try atividade.managedObjectContext?.save()
            print("Atividade com materia alterada com sucesso")
        } catch {
            print("Erro ao alterar atividade")
        }
    }
    
    static func delete(atividade: Atividade){
        atividade.managedObjectContext?.delete(atividade)
        do{
            try atividade.managedObjectContext?.save()
        } catch {
            print("Erro ao deletar atividade")
        }
    }
    
    static func getAtividades() -> Array<NSManagedObject> {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Atividade> = Atividade.fetchRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        }catch let erro{
            print(erro.localizedDescription)
            print("Erro ao tentar recuperar atividades")
        }
        
        return []
    }
    
    static func getAtividadesWithOutMateria() -> [Atividade] {
        let atividades = getAtividades() as! [Atividade]
        var atividadesWithOutMateria: [Atividade] = []
        
        for atividade in atividades {
            if atividade.relationship == nil {
                atividadesWithOutMateria.append(atividade)
            }
        }
        
        return atividadesWithOutMateria
    }
    
}
