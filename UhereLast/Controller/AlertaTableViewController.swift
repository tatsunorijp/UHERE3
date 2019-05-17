//
//  AlertaAtividadeTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 12/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import RxSwift

protocol AlertaProtocol{
    func relativeOffSet(offSet: Double, string: String)
}

struct Valor{
    let offSet: Double
    let string: String
}

class AlertaTableViewController: UITableViewController {
    var alertaProtocol: AlertaProtocol?
    
    let valueSubject = PublishSubject<Valor>()
    
    var valueObservable: Observable<Valor> {
        return valueSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var valor = Valor(offSet: 1, string: "")
        if (indexPath.row == 0 && indexPath.section == 0) {
            alertaProtocol?.relativeOffSet(offSet: -1, string: "Desativado")
            valor = Valor(offSet: -1, string: "Desativado")
        }else if (indexPath.row == 0 && indexPath.section == 1){
            alertaProtocol?.relativeOffSet(offSet: 0, string: "Na hora do evento")
            valor = Valor(offSet: 0, string: "Na hora do evento")
        }else if (indexPath.row == 1){
            alertaProtocol?.relativeOffSet(offSet: 5, string: "5 minutos antes")
            valor = Valor(offSet: 5, string: "5 minutos antes")
        }else if (indexPath.row == 2){
            alertaProtocol?.relativeOffSet(offSet: 15, string: "15 minutos antes")
            valor = Valor(offSet: 15, string: "15 minutos antes")
        }else if (indexPath.row == 3){
            alertaProtocol?.relativeOffSet(offSet: 30, string: "30 minutos antes")
        }else if (indexPath.row == 4){
            alertaProtocol?.relativeOffSet(offSet: 60, string: "1 hora antes")
        }else if (indexPath.row == 5){
            alertaProtocol?.relativeOffSet(offSet: 120, string: "2 horas antes")
        }else if (indexPath.row == 6){
            alertaProtocol?.relativeOffSet(offSet: 60*24, string: "1 dia antes")
        }else if (indexPath.row == 7){
            alertaProtocol?.relativeOffSet(offSet: 60*24*2, string: "2 dias antes")
        }else if (indexPath.row == 8){
            alertaProtocol?.relativeOffSet(offSet: 60*24*7, string: "1 semana antes")
        }
        print(valor.string)
        valueSubject.onNext(valor)
        self.navigationController?.popViewController(animated: true)
    }

}
