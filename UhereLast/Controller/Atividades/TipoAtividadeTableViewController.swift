//
//  TipoAtividadeTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 12/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit

protocol TipoAtividadeProtocol{
    func tipoAtividade(tipo: String)
}
class TipoAtividadeTableViewController: UITableViewController {
    var tipoAtividadeProtocol: TipoAtividadeProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0){
            tipoAtividadeProtocol?.tipoAtividade(tipo: "Indefinido")
        }else if(indexPath.section == 1 && indexPath.row == 0){
            tipoAtividadeProtocol?.tipoAtividade(tipo: "Reunião")
        }else if(indexPath.row == 1){
            tipoAtividadeProtocol?.tipoAtividade(tipo: "Trabalho")
        }
        self.navigationController?.popViewController(animated: true)

    }

}
