//
//  SemestreCadastroTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 30/10/2018.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SemestreCadastroTableViewController: TableViewController {

    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfDataInicio: DateTextField!
    @IBOutlet weak var tfDataFim: DateTextField!
    @IBOutlet weak var btSave: UIBarButtonItem!

    var edit: Int?
    var semestre: Semestre?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunction()
    }
    
    func loadFunction(){
        tfDataInicio.setConfig(format: Constants.dateFormat, mode: .date)
        tfDataFim.setConfig(format:  Constants.dateFormat, mode: .date)

        tableView.keyboardDismissMode = .onDrag
        
        if edit != nil{
            Controller.dateFormat()
            tfNome.text = semestre?.nome
            if let dateStart = semestre?.dataInicio,
                let dateEnd = semestre?.dataFim {
                tfDataInicio.date = dateStart as Date
                tfDataFim.date = dateEnd as Date
            }
            
            btSave.title = "Done"
            navigationItem.title = "Edit"
            
            Controller.alertaContinuar(titulo: "Alteração de semestre", menssagem: "Atenção, caso seja efetuado a alteração dos dados de um semestre, todas as faltas cadastradas de suas respectivas disciplinas serão deletadas. CUIDADO!", vc: self)
        }
    }
    
    @IBAction func btSave(_ sender: Any) {
        Controller.dateFormat()
        
        if (tfNome.text?.isEmpty)! || (tfDataInicio.text?.isEmpty)! || (tfDataFim.text?.isEmpty)!{
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
            print("campos vazios no novo semestre")
        }else{
            let nome = tfNome.text!
            let dataInicio: Date = tfDataInicio.date
            let dataFim: Date = tfDataFim.date
            
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
