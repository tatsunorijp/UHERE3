//
//  SemestreCadastroTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 30/10/2018.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SemestreCadastroTableViewController: UITableViewController {

    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfDataInicio: UITextField!
    @IBOutlet weak var tfDataFim: UITextField!
    @IBOutlet weak var btSave: UIBarButtonItem!
    var datePickerInicio = UIDatePicker()
    var datePickerFim = UIDatePicker()
    var edit: Int?
    var semestre: Semestre?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunction()
    }
    
    func loadFunction(){
        datePickerInicio.datePickerMode = .date
        datePickerFim.datePickerMode = .date
        
        tfDataInicio.inputView = datePickerInicio
        tfDataFim.inputView = datePickerFim
        
        datePickerInicio.addTarget(self, action: #selector (self.dataInicioChanged(datePicker:)), for: .valueChanged)
        datePickerFim.addTarget(self, action: #selector (self.dataFimChanged(datePicker:)), for: .valueChanged)
        tableView.keyboardDismissMode = .onDrag
        
        if edit != nil{
            Controller.dateFormat()
            tfNome.text = semestre?.nome
            tfDataInicio.text = Controller.dateFormatter.string(from: semestre?.dataInicio as! Date)
            tfDataFim.text = Controller.dateFormatter.string(from: semestre?.dataFim as! Date)
            btSave.title = "Done"
            navigationItem.title = "Edit"
            
            Controller.alertaContinuar(titulo: "Alteração de semestre", menssagem: "Atenção, caso seja efetuado a alteração dos dados de um semestre, todas as faltas cadastradas de suas respectivas disciplinas serão deletadas. CUIDADO!", vc: self)
        }
    }
    
    @objc func dataInicioChanged(datePicker: UIDatePicker){
        Controller.dateFormat()
        tfDataInicio.text = Controller.dateFormatter.string(from: datePicker.date)
    }
    @objc func dataFimChanged(datePicker: UIDatePicker){
        Controller.dateFormat()
        tfDataFim.text = Controller.dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func btSave(_ sender: Any) {
        Controller.dateFormat()
        
        if (tfNome.text?.isEmpty)! || (tfDataInicio.text?.isEmpty)! || (tfDataFim.text?.isEmpty)!{
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
            print("campos vazios no novo semestre")
        }else{
            let nome = tfNome.text!
            let dataInicio: Date = Controller.dateFormatter.date(from: tfDataInicio.text!)!
            let dataFim: Date = Controller.dateFormatter.date(from: tfDataFim.text!)!
            
            if (dataFim < dataInicio){
                Controller.alertaContinuar(titulo: "Datas não equivalentes", menssagem: "A data de ínicio deve ser menor que a data de fim do semestre", vc: self)
            }else{
                if (edit != nil){
                    semestre?.nome = nome
                    semestre?.dataInicio = dataInicio as NSDate
                    semestre?.dataFim = dataFim as NSDate
                    
                    let materias = semestre?.materias
                    
                    for materia in materias!{
                        let faltas = materia.falta
                        for falta in faltas!{
                            Falta.delete(falta: falta)
                        }
                    }
                }else if let semestreObj = Semestre.init(nome: nome, dataInicio: dataInicio, dataFim:dataFim){
                    Semestre.save(semestre: semestreObj)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
}
