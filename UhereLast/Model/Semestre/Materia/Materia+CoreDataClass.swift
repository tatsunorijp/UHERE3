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
    
    enum Constants {
        static let indefinido = "Indefinido"
        static let reprovadoPorNota = "Reprovado por nota"
        static let aprovado = "Aprovado"
        static let reprovadoPorFalta = "Reprovado por falta"
        static let notaParaAprovacao1 = "Precisa de "
        static let notaParaAprovacao2 = " pontos na última avaliação"

    }
    
    var provas: [Prova]? {
        return self.rawProvas?.array as? [Prova]
    }
    
    var atividades: [Atividade]?{
        return self.rawAtividades?.array as? [Atividade]
    }
    
    var falta: [Falta]? {
        return self.rawFaltas?.array as? [Falta]
    }
    
    var mediaAtual = 0.0
    
    
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
    
    func getMedia() -> String {
        var totalPoints = 0.0
        var totalWeigth = 0.0
        
        for prova in provas ?? [] {
            if prova.concluido {
                totalPoints += (prova.nota * prova.peso)
            }
            totalWeigth += prova.peso
        }
        mediaAtual = totalPoints / totalWeigth
        return String(mediaAtual.rounded())
    }
    
    func getSituation() -> String {
        var provasConcluidas = 0
        var totalWeigth = 0.0
        
        if falta?.count ?? 0 > limiteFalta {
            return Constants.reprovadoPorFalta
        }
        
        if mediaAtual >= 60 {
            return Constants.aprovado
        }
        
        for prova in provas ?? [] {
            if prova.concluido {
                provasConcluidas += 1
            }
            
            totalWeigth += prova.peso
        }
        
        if provasConcluidas == provas?.count {
            if mediaAtual >= 60.0 {
                return Constants.aprovado
            } else {
                return Constants.reprovadoPorNota
            }
        } else if provasConcluidas + 1 == provas?.count {
            var notaParaPassar: Double = 0
            
            for prova in provas ?? [] {
                if !prova.concluido {
                    notaParaPassar = (60 - mediaAtual) * totalWeigth
                }
            }
            
            if notaParaPassar >= 100 {
                return Constants.reprovadoPorNota
            }
            return Constants.notaParaAprovacao1 + String(notaParaPassar.rounded()) + Constants.notaParaAprovacao2
            
            
        }
        return Constants.indefinido
    }
}
