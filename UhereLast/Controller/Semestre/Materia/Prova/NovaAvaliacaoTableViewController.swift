//
//  NovaProvaTableViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 18/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit

class NovaAvaliacaoTableViewController: UITableViewController {
    
    @IBOutlet weak var lbAlerta: UILabel!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfNota: UITextField!
    @IBOutlet weak var tfPeso: UITextField!
    @IBOutlet weak var tfData: UITextField!
    @IBOutlet weak var lbMateria: UILabel!
    let datePicker = UIDatePicker()
    var offset: Double = 0.0
    
    var materia = Materia()
    var cor: String = ""
    
    override func viewDidLoad() {
        loadFunctions()
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag

        
    }
    
    @IBAction func btNovaAvaliacao(_ sender: Any) {
        Controller.dateTimeFormat()
        
        //verifica os campos obrigatorios
        if (tfNome.text?.isEmpty)! || (tfPeso.text?.isEmpty)! || (tfData.text?.isEmpty)! {
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
            print("Dados obrigatorios vazios em nova avaliacao")
        }else{
            let nome = tfNome.text!
            let peso = Double(tfPeso.text!)!
            let nota = Double(tfNota.text!) ?? 0
            let data: Date = Controller.dateFormatter.date(from: tfData.text!)!
            
            if let avaliacao = Prova.init(nome: nome, peso: peso, nota: nota, diaHora: data, offSet: offset, offSetString: lbAlerta.text!){
                
                if(avaliacao.alertaOffSet >= 0){
                    let id = Notificacoes.idGenerator(type: "Avaliacoes", materia: materia.nome!, title: avaliacao.nome!, date: avaliacao.diaHora! as Date)
                    let frase = "Prova de " + materia.nome!
                    Notificacoes.create(title: avaliacao.nome!, body: frase, date: avaliacao.diaHora! as Date, offSet: avaliacao.alertaOffSet, id: id)
                }
                
                Prova.save(prova: avaliacao, materia: materia)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }

    func loadFunctions(){
        lbMateria.text = materia.nome
        lbMateria.textColor = UIColor.colorWithHexString(cor)
        
        datePicker.datePickerMode = .dateAndTime
        tfData.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.dataInicioChanged(datePicker:)), for: .valueChanged)
        
        Controller.dateTimeFormat()
    }
    
    @objc func viewClicked(reconhecedorGesto: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dataInicioChanged(datePicker: UIDatePicker){
        Controller.dateTimeFormat()
        tfData.text = Controller.dateFormatter.string(from: datePicker.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selecionarAlerta") {
            let destino = segue.destination as! AlertaTableViewController
            destino.alertaProtocol = self as AlertaProtocol
        }
    }

}

extension NovaAvaliacaoTableViewController: AlertaProtocol{
    func relativeOffSet(offSet: Double, string: String) {
        lbAlerta.text = string
        self.offset = offSet
    }
    
}
