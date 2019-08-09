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
    
    static func completeSave(atividade: Atividade, materia: Materia?) {
        if let materia = materia {
            materia.addToRawAtividades(atividade)
        } else {
            print("materia eh nil")
        }
        
        let id = generateAtividadeId(materiaName: materia?.nome ?? "indefinido", title: atividade.nome!, date: atividade.diaHora! as Date)
        atividade.notificationId = id
        createNotification(atividade: atividade)
        
        do{
            try atividade.managedObjectContext?.save()
            print("Atividade salva com sucesso")
        } catch {
            print("Erro ao cadastrar nova atividade")
        }
    }
    
    static func completeDelete(atividade: Atividade){
        Notificacoes.delete(id: [atividade.notificationId!])
        atividade.managedObjectContext?.delete(atividade)
        do{
            try atividade.managedObjectContext?.save()
        } catch {
            print("Erro ao deletar atividade")
        }
    }
    
    static func completeChange(oldMateria: Materia?, newMateria: Materia?, atividade: Atividade){
        removeMateriaReference(materia: oldMateria!, atividade: atividade)
        
        if let newMateria = newMateria {
            newMateria.addToRawAtividades(atividade)
        }
        
        let newNotificationId = generateAtividadeId(materiaName: newMateria?.nome ?? "indefinido", title: atividade.nome!, date: atividade.diaHora! as Date)
        
        Notificacoes.delete(id: [atividade.notificationId!])
        createNotification(atividade: atividade)
        
        atividade.notificationId = newNotificationId
        do{
            try atividade.managedObjectContext?.save()
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
    
    static func generateAtividadeId(materiaName: String, title: String, date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateTimeFormat // "dd/MM/yyyy - h:mm a"
        
        return "atividade" + materiaName + title + dateFormatter.string(from: date)
    }
    
    static func createNotification(atividade: Atividade){
        if (atividade.alertaOffSet >= 0){
            Notificacoes.create(title: atividade.nome!, body: atividade.tipo!, date: atividade.diaHora! as Date, offSet: atividade.alertaOffSet, id: atividade.notificationId!)
        }
    }
    
}
