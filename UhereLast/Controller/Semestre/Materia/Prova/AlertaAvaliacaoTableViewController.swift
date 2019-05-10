//
//  AlertaAvaliacaoTableViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 31/01/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit
protocol AlertaAvaliacaoProtocol{
    func relativeOffSet(offSet: Double, string: String)
}

class AlertaAvaliacaoTableViewController: UITableViewController {

    var alertaAvaliacaoProtocol: AlertaAvaliacaoProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0 && indexPath.section == 0) {
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: -1, string: "Desativado")
        }else if (indexPath.row == 0 && indexPath.section == 1){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 0, string: "Na hora do evento")
        }else if (indexPath.row == 1){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 5, string: "5 minutos antes")
        }else if (indexPath.row == 2){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 15, string: "15 minutos antes")
        }else if (indexPath.row == 3){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 30, string: "30 minutos antes")
        }else if (indexPath.row == 4){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 60, string: "1 hora antes")
        }else if (indexPath.row == 5){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 120, string: "2 horas antes")
        }else if (indexPath.row == 6){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 60*24, string: "1 dia antes")
        }else if (indexPath.row == 7){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 60*24*2, string: "2 dias antes")
        }else if (indexPath.row == 8){
            alertaAvaliacaoProtocol?.relativeOffSet(offSet: 60*24*7, string: "1 semana antes")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
