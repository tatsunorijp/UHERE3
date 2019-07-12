//
//  ExibeAvaliacaoTableViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 06/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class ExibeAvaliacaoTableViewController: UITableViewController {

    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfNota: UITextField!
    @IBOutlet weak var tfPeso: UITextField!
    @IBOutlet weak var tfData: DateTextField!
    @IBOutlet weak var lbAlerta: UILabel!
    @IBOutlet weak var lbMateria: UILabel!
    
    @IBOutlet weak var btSwichConcluido: UISwitch!
    
    var offset: Double = 0.0
    let datePicker = UIDatePicker()
    var avaliacao = Prova()
    var oldId: String = ""
    var concluido: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
         self.navigationItem.title = tfNome.text
    }
    
    
    @IBAction func btDone(_ sender: Any) {
        Controller.dateTimeFormat()
        
        //verifica os campos obrigatorios
        if (tfNome.text?.isEmpty)! || (tfPeso.text?.isEmpty)! || (tfData.text?.isEmpty)! {
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
        }else{
            let nome = tfNome.text!
            let peso = Double(tfPeso.text!)!
            let nota = Double(tfNota.text!) ?? 0
            let data: Date = tfData.date
            avaliacao.nome = nome
            avaliacao.peso = peso
            avaliacao.nota = nota
            avaliacao.diaHora = data as NSDate
            avaliacao.alertaOffSet = offset
            avaliacao.offSetString = lbAlerta.text
            avaliacao.concluido = concluido
            
            if(avaliacao.alertaOffSet >= 0){
                let newId = Notificacoes.idGenerator(type: "Avaliacoes", materia: avaliacao.materia!.nome!, title: avaliacao.nome!, date: avaliacao.diaHora! as Date)
                let frase = "Prova de " + avaliacao.materia!.nome!
                
                Notificacoes.update(title: avaliacao.nome!, oldId: oldId, newId: newId, body: frase, date: avaliacao.diaHora! as Date, offSet: avaliacao.alertaOffSet)
            }else{
                Notificacoes.delete(id: [oldId])
            }
            Prova.change(prova: avaliacao)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selecionarAlerta"){
            let destino = segue.destination as! AlertaTableViewController
            destino.alertaProtocol = self as AlertaProtocol
        }
    }
    
    @objc func dataChanged(datePicker: UIDatePicker){
        Controller.dateTimeFormat()
        tfData.text = Controller.dateFormatter.string(from: datePicker.date)
    }
    
    func loadData(){
        tableView.keyboardDismissMode = .onDrag
        tfData.setConfig(format: Constants.dateTimeFormat, mode: .dateAndTime)
        
        tfNome.text = avaliacao.nome
        tfNota.text = String(avaliacao.nota)
        tfPeso.text = String(avaliacao.peso)
        tfData.text = Controller.dateFormatter.string(from: avaliacao.diaHora! as Date)
        lbMateria.text = avaliacao.materia?.nome
        lbAlerta.text = avaliacao.offSetString
        offset = avaliacao.alertaOffSet
        lbMateria.textColor =  UIColor.colorWithHexString((avaliacao.materia?.cor)!)
        btSwichConcluido.isOn = avaliacao.concluido
        concluido = avaliacao.concluido
        oldId = Notificacoes.idGenerator(type: "Avaliacoes", materia: avaliacao.materia!.nome!, title: avaliacao.nome!, date: avaliacao.diaHora! as Date)
        
        navigationItem.title = avaliacao.nome

    }
    
    @IBAction func btSwichActionHandler(_ sender: UISwitch) {
        concluido = sender.isOn
    }
    
}

extension ExibeAvaliacaoTableViewController: AlertaProtocol{
    func relativeOffSet(offSet: Double, string: String) {
        lbAlerta.text = string
        self.offset = offSet
    }
    
    
}
