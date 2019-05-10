//
//  Materia+CoreDataProperties.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 29/04/19.
//  Copyright © 2019 tatsu. All rights reserved.
//
//

import Foundation
import CoreData


extension Materia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Materia> {
        return NSFetchRequest<Materia>(entityName: "Materia")
    }

    @NSManaged public var alertaOffSet: Double
    @NSManaged public var cor: String?
    @NSManaged public var faltas: Int32
    @NSManaged public var limiteFalta: Int32
    @NSManaged public var local: String?
    @NSManaged public var media: Double
    @NSManaged public var nome: String?
    @NSManaged public var offSetString: String?
    @NSManaged public var professor: String?
    @NSManaged public var quantidadeProvas: Int32
    @NSManaged public var situacao: String?
    @NSManaged public var diasHoras: DiasHoras?
    @NSManaged public var rawAtividades: NSOrderedSet?
    @NSManaged public var rawProvas: NSOrderedSet?
    @NSManaged public var semestre: Semestre?
    @NSManaged public var rawFaltas: NSOrderedSet?

}

// MARK: Generated accessors for rawAtividades
extension Materia {

    @objc(insertObject:inRawAtividadesAtIndex:)
    @NSManaged public func insertIntoRawAtividades(_ value: Atividade, at idx: Int)

    @objc(removeObjectFromRawAtividadesAtIndex:)
    @NSManaged public func removeFromRawAtividades(at idx: Int)

    @objc(insertRawAtividades:atIndexes:)
    @NSManaged public func insertIntoRawAtividades(_ values: [Atividade], at indexes: NSIndexSet)

    @objc(removeRawAtividadesAtIndexes:)
    @NSManaged public func removeFromRawAtividades(at indexes: NSIndexSet)

    @objc(replaceObjectInRawAtividadesAtIndex:withObject:)
    @NSManaged public func replaceRawAtividades(at idx: Int, with value: Atividade)

    @objc(replaceRawAtividadesAtIndexes:withRawAtividades:)
    @NSManaged public func replaceRawAtividades(at indexes: NSIndexSet, with values: [Atividade])

    @objc(addRawAtividadesObject:)
    @NSManaged public func addToRawAtividades(_ value: Atividade)

    @objc(removeRawAtividadesObject:)
    @NSManaged public func removeFromRawAtividades(_ value: Atividade)

    @objc(addRawAtividades:)
    @NSManaged public func addToRawAtividades(_ values: NSOrderedSet)

    @objc(removeRawAtividades:)
    @NSManaged public func removeFromRawAtividades(_ values: NSOrderedSet)

}

// MARK: Generated accessors for rawProvas
extension Materia {

    @objc(insertObject:inRawProvasAtIndex:)
    @NSManaged public func insertIntoRawProvas(_ value: Prova, at idx: Int)

    @objc(removeObjectFromRawProvasAtIndex:)
    @NSManaged public func removeFromRawProvas(at idx: Int)

    @objc(insertRawProvas:atIndexes:)
    @NSManaged public func insertIntoRawProvas(_ values: [Prova], at indexes: NSIndexSet)

    @objc(removeRawProvasAtIndexes:)
    @NSManaged public func removeFromRawProvas(at indexes: NSIndexSet)

    @objc(replaceObjectInRawProvasAtIndex:withObject:)
    @NSManaged public func replaceRawProvas(at idx: Int, with value: Prova)

    @objc(replaceRawProvasAtIndexes:withRawProvas:)
    @NSManaged public func replaceRawProvas(at indexes: NSIndexSet, with values: [Prova])

    @objc(addRawProvasObject:)
    @NSManaged public func addToRawProvas(_ value: Prova)

    @objc(removeRawProvasObject:)
    @NSManaged public func removeFromRawProvas(_ value: Prova)

    @objc(addRawProvas:)
    @NSManaged public func addToRawProvas(_ values: NSOrderedSet)

    @objc(removeRawProvas:)
    @NSManaged public func removeFromRawProvas(_ values: NSOrderedSet)

}

// MARK: Generated accessors for rawFaltas
extension Materia {

    @objc(insertObject:inRawFaltasAtIndex:)
    @NSManaged public func insertIntoRawFaltas(_ value: Falta, at idx: Int)

    @objc(removeObjectFromRawFaltasAtIndex:)
    @NSManaged public func removeFromRawFaltas(at idx: Int)

    @objc(insertRawFaltas:atIndexes:)
    @NSManaged public func insertIntoRawFaltas(_ values: [Falta], at indexes: NSIndexSet)

    @objc(removeRawFaltasAtIndexes:)
    @NSManaged public func removeFromRawFaltas(at indexes: NSIndexSet)

    @objc(replaceObjectInRawFaltasAtIndex:withObject:)
    @NSManaged public func replaceRawFaltas(at idx: Int, with value: Falta)

    @objc(replaceRawFaltasAtIndexes:withRawFaltas:)
    @NSManaged public func replaceRawFaltas(at indexes: NSIndexSet, with values: [Falta])

    @objc(addRawFaltasObject:)
    @NSManaged public func addToRawFaltas(_ value: Falta)

    @objc(removeRawFaltasObject:)
    @NSManaged public func removeFromRawFaltas(_ value: Falta)

    @objc(addRawFaltas:)
    @NSManaged public func addToRawFaltas(_ values: NSOrderedSet)

    @objc(removeRawFaltas:)
    @NSManaged public func removeFromRawFaltas(_ values: NSOrderedSet)

}
