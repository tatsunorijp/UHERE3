//
//  SelecionaDiasTableViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 03/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

protocol DiasSemanaProtocol{
    func diasSemana(dias: [Bool], horas: [Date])
}
class SelecionaDiasTableViewController: UITableViewController {
    var diasSemanaProtocol: DiasSemanaProtocol?
    let diasSemana = ["Domingo","Segunda","Terça","Quarta","Quinta","Sexta","Sábado"]
    var datePickers: [UIDatePicker] = []
    var textFields: [DateTextField] = []
    var dias: [Bool] = []
    var horas: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for i in 0...6{
            if (dias[i]){
                print(i)
            }
        }
    }
    
    @IBAction func btDone(_ sender: Any) {
        for i in 0...6 {
            horas[i] = textFields[i].date
        }
        
        diasSemanaProtocol?.diasSemana(dias: dias, horas: horas)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diasSemana.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selecionaDiasCell", for: indexPath) as! SelecionaDiasCell
        cell.lbDia.text = diasSemana[indexPath.row]
        textFields.append(cell.tfHora)
        
        if(dias[indexPath.row] == true){
            cell.tfHora.date = horas[indexPath.row]
            cell.accessoryType = .checkmark
            cell.tfHora.isHidden = false
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //contagem das linhas comeca pelo 0
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? SelecionaDiasCell{
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                cell.tfHora.isHidden = true
                dias[indexPath.row] = false
            }else{
                cell.tintColor = Controller.mainColor
                cell.accessoryType = .checkmark
                cell.tfHora.becomeFirstResponder()
                cell.tfHora.isHidden = false
                dias[indexPath.row] = true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repetição Semanal"
    }
}
