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
    var textFields: [UITextField] = []
    var dias: [Bool] = []
    var horas: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFunctions()
        for i in 0...6{
            if (dias[i]){
                print(i)
            }
        }
    }
    
    
    @IBAction func btDone(_ sender: Any) {
        diasSemanaProtocol?.diasSemana(dias: dias, horas: horas)
        self.navigationController?.popViewController(animated: true)

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return diasSemana.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selecionaDiasCell", for: indexPath) as! SelecionaDiasCell
        cell.lbDia.text = diasSemana[indexPath.row]
        datePickers.append(UIDatePicker())
        datePickers[indexPath.row].datePickerMode = .time
        
        cell.tfHora.inputView = datePickers[indexPath.row]
        textFields.append(cell.tfHora)
        
        if(dias[indexPath.row] == true){
            cell.tfHora.text = Controller.dateFormatter.string(from: horas[indexPath.row])
            cell.accessoryType = .checkmark
            cell.tfHora.isHidden = false
            cell.tintColor = Controller.mainColor
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
                print(indexPath.row)
                dias[indexPath.row] = false
            }else{
                cell.tintColor = Controller.mainColor
                cell.accessoryType = .checkmark
                cell.tfHora.becomeFirstResponder()
                cell.tfHora.isHidden = false
                print(indexPath.row)
                dias[indexPath.row] = true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repetição Semanal"
    }
    
    func loadFunctions(){
        datePickers[0].addTarget(self, action: #selector (self.dateChangedDomingo(datePicker:)), for: .valueChanged)
        datePickers[1].addTarget(self, action: #selector (self.dateChangedSegunda(datePicker:)), for: .valueChanged)
        datePickers[2].addTarget(self, action: #selector (self.dateChangedTerca(datePicker:)), for: .valueChanged)
        datePickers[3].addTarget(self, action: #selector (self.dateChangedQuarta(datePicker:)), for: .valueChanged)
        datePickers[4].addTarget(self, action: #selector (self.dateChangedQuinta(datePicker:)), for: .valueChanged)
        datePickers[5].addTarget(self, action: #selector (self.dateChangedSexta(datePicker:)), for: .valueChanged)
        datePickers[6].addTarget(self, action: #selector (self.dateChangedSabado(datePicker:)), for: .valueChanged)
        
    }
    

    @objc func dateChangedDomingo(datePicker: UIDatePicker){
        Controller.timeFormat()
        textFields[0].text = Controller.dateFormatter.string(from: datePicker.date)
        horas[0] = datePicker.date
    }
    @objc func dateChangedSegunda(datePicker: UIDatePicker){
        Controller.timeFormat()
        textFields[1].text = Controller.dateFormatter.string(from: datePicker.date)
        horas[1] = datePicker.date
    }
    @objc func dateChangedTerca(datePicker: UIDatePicker){
        Controller.timeFormat()
        textFields[2].text = Controller.dateFormatter.string(from: datePicker.date)
        horas[2] = datePicker.date
    }
    @objc func dateChangedQuarta(datePicker: UIDatePicker){
        Controller.timeFormat()
        textFields[3].text = Controller.dateFormatter.string(from: datePicker.date)
        horas[3] = datePicker.date
    }
    @objc func dateChangedQuinta(datePicker: UIDatePicker){
        Controller.timeFormat()
        textFields[4].text = Controller.dateFormatter.string(from: datePicker.date)
        horas[4] = datePicker.date

    }
    @objc func dateChangedSexta(datePicker: UIDatePicker){
        Controller.timeFormat()
        textFields[5].text = Controller.dateFormatter.string(from: datePicker.date)
        horas[5] = datePicker.date
    }
    @objc func dateChangedSabado(datePicker: UIDatePicker){
        Controller.timeFormat()
        textFields[6].text = Controller.dateFormatter.string(from: datePicker.date)
        horas[6] = datePicker.date
    }


}
