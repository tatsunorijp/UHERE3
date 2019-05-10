//
//  Semestre+CoreDataProperties.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 17/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//
//

import Foundation
import CoreData


extension Semestre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Semestre> {
        return NSFetchRequest<Semestre>(entityName: "Semestre")
    }

    @NSManaged public var nome: String?
    @NSManaged public var dataInicio: NSDate?
    @NSManaged public var dataFim: NSDate?
    @NSManaged public var rawMaterias: NSOrderedSet?

}

// MARK: Generated accessors for rawMaterias
extension Semestre {

    @objc(insertObject:inRawMateriasAtIndex:)
    @NSManaged public func insertIntoRawMaterias(_ value: Materia, at idx: Int)

    @objc(removeObjectFromRawMateriasAtIndex:)
    @NSManaged public func removeFromRawMaterias(at idx: Int)

    @objc(insertRawMaterias:atIndexes:)
    @NSManaged public func insertIntoRawMaterias(_ values: [Materia], at indexes: NSIndexSet)

    @objc(removeRawMateriasAtIndexes:)
    @NSManaged public func removeFromRawMaterias(at indexes: NSIndexSet)

    @objc(replaceObjectInRawMateriasAtIndex:withObject:)
    @NSManaged public func replaceRawMaterias(at idx: Int, with value: Materia)

    @objc(replaceRawMateriasAtIndexes:withRawMaterias:)
    @NSManaged public func replaceRawMaterias(at indexes: NSIndexSet, with values: [Materia])

    @objc(addRawMateriasObject:)
    @NSManaged public func addToRawMaterias(_ value: Materia)

    @objc(removeRawMateriasObject:)
    @NSManaged public func removeFromRawMaterias(_ value: Materia)

    @objc(addRawMaterias:)
    @NSManaged public func addToRawMaterias(_ values: NSOrderedSet)

    @objc(removeRawMaterias:)
    @NSManaged public func removeFromRawMaterias(_ values: NSOrderedSet)

}
