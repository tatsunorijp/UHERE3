//
//  ControllerFunctions.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 30/10/2018.
//  Copyright © 2018 tatsu. All rights reserved.
//

import Foundation
import UIKit

class Controller{
    static let mainColor = UIColor.black//UIColor(red: 0/255.0, green: 205/255.0, blue: 246/255.0, alpha: 1.0)
    static let darkColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
    static let whiteColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let grayColor = UIColor.lightGray
    static let dateFormatter = DateFormatter()
    static var booleano: Bool = false
    static let tipos = ["Indefinido", "Trabalho", "Reunião", "Aula"]
    
    enum Tipos: String{
        case Indefinido
        case Trabalho
        case Reunião
        case Aula
        
        func tipo() -> String{
            return self.rawValue
        }
        
    }
    
    static let tituloCampo = "Campos de texto"
    static let menssagemCampo = "Campos com o símbolo * devem ser obrigatoriamente completados!"
    static func dateFormat(){
        dateFormatter.dateFormat = "dd/MM/yyyy"
    }
    static func dateTimeFormat(){
        dateFormatter.dateFormat = "dd/MM/yyyy - h:mm a"
    }
    static func timeFormat(){
        dateFormatter.dateFormat = "h:mm a"
    }
    
    static func alertaContinuar(titulo: String, menssagem: String, vc: UIViewController){
        let alert = UIAlertController(title: titulo, message: menssagem, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .default))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func configureTableViewController(view: UITableViewController){
        view.tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        view.tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.tableView.keyboardDismissMode = .onDrag
    }
    
    static func configureTableView(tableView: UITableView){
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    static func getDiasSemana(diasHoras: DiasHoras) -> [Bool]{
        var dias:[Bool] = []
        
        for _ in 0...6{
            dias.append(false)
        }
    
        if((diasHoras.domingo)){
            dias[0] = true
        }
        if((diasHoras.segunda)){
            dias[1] = true
        }
        if((diasHoras.terca)){
            dias[2] = true
        }
        if((diasHoras.quarta)){
            dias[3] = true
        }
        if((diasHoras.quinta)){
            dias[4] = true
        }
        if((diasHoras.sexta)){
            dias[5] = true
        }
        if((diasHoras.sabado)){
            dias[6] = true
        }
        
        return dias
    }
    
    static func getHorasSemana(diasHoras: DiasHoras) -> [Date]{
        var horas:[Date] = []
        
        
        horas.append(diasHoras.hDomingo! as Date)
        horas.append(diasHoras.hSegunda! as Date)
        horas.append(diasHoras.hTerca! as Date)
        horas.append(diasHoras.hQuarta! as Date)
        horas.append(diasHoras.hQuinta! as Date)
        horas.append(diasHoras.hSexta! as Date)
        horas.append(diasHoras.hSabado! as Date)
        
        return horas

    }
    

    
}
