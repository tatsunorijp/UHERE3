//
//  FaltasViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 27/04/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

struct structDia {
    var dia: Date?
    var hora: Date?
    var presenca: Bool?
}

class FaltasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var materia: Materia?
    var diasSemana: [Bool] = []
    var horasSemana: [Date] = []
    var dias: [structDia] = []
    var faltas: [Falta] = []
    let calendar = Calendar.current

    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FaltasCell
        
        cell.accessoryType = .none
        Controller.dateFormat()
        cell.lbDate.text = Controller.dateFormatter.string(from: dias[indexPath.row].dia!)
        Controller.timeFormat()
        cell.lbHora.text = Controller.dateFormatter.string(from: dias[indexPath.row].hora!)
        if(!dias[indexPath.row].presenca!){
            cell.accessoryType = .checkmark
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? FaltasCell{
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                
                //let dia = Controller.dateFormatter.date(from: cell.lbDate.text!)
                let dia = dias[indexPath.row].dia
                for (index, falta) in faltas.enumerated(){
                    if ((falta.dia! as Date) == dia) {
                        dias[indexPath.row].presenca = true
                        Falta.delete(falta: falta)
                        faltas.remove(at: index)
                    }
                }
            }else{
                cell.accessoryType = .checkmark
                Controller.dateTimeFormat()
                //let dia = Controller.dateFormatter.date(from: cell.lbDate.text! + " - " + cell.lbHora.text!)
                let dia = dias[indexPath.row].dia
                let novaFalta = Falta.init(falta: dia!)! as Falta
                print(novaFalta)
                faltas.append(novaFalta)
                dias[indexPath.row].presenca = false
                Falta.save(falta: novaFalta, materia: materia!)
            }
        }
    }
    
    func loadData(){
        Controller.dateFormat()
        diasSemana = Controller.getDiasSemana(diasHoras: materia!.diasHoras!)
        horasSemana = Controller.getHorasSemana(diasHoras: materia!.diasHoras!)
        let semestre: Semestre = materia!.semestre! as Semestre
        var dataInicio = semestre.dataInicio! as Date
        let dataFim = semestre.dataFim! as Date
        faltas = (materia?.falta)!
        while (dataInicio <= dataFim){
            let dia = dataInicio


            let diaComponent = calendar.dateComponents([.weekday], from: dia)
            
            //PARECE QUE WEEKDAY VAI DE 1 A 7, E NAO DE 0 A 6 POR ISSO O -1
            if(diasSemana[diaComponent.weekday! - 1]){
                var diaLocal = structDia(dia: dia, hora: horasSemana[diaComponent.weekday! - 1], presenca: true)

                for falta in faltas{
                    if ((falta.dia! as Date) == dia){
                        diaLocal.presenca = false
                    }
                }
                dias.append(diaLocal)
            }
            dataInicio = calendar.date(byAdding: .day, value: 1, to: dataInicio)!
        }
        
        
    }

}
