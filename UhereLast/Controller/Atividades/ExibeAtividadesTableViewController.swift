//
//  ExibeAtividadesTableViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 08/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class ExibeAtividadesTableViewController: UITableViewController {

    var atividade = Atividade()
    
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var lbDisciplina: UILabel!
    @IBOutlet weak var lbTipo: UILabel!
    @IBOutlet weak var lbData: UITextField!
    @IBOutlet weak var lbAlerta: UILabel!
    @IBOutlet weak var tfLocal: UITextField!
    @IBOutlet weak var tfAnotacao: UITextView!
    let datePicker = UIDatePicker()
    var offSet: Double = 0.0
    var selecionado: Bool = true
    var materiaSelecionada = Materia()
    var oldMateria = Materia()
    var newId: String = ""
    var oldId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.navigationItem.title = tfTitulo.text
    }
    
    @IBAction func btDone(_ sender: Any) {
        if((tfTitulo.text?.isEmpty)! || (lbData.text?.isEmpty)!){
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
        }else{
            Controller.dateTimeFormat()
            guard let nome = tfTitulo.text,
                let tipo = lbTipo.text,
                let local = tfLocal.text,
                let anotacao = tfAnotacao.text,
                let data = Controller.dateFormatter.date(from: lbData.text!)  else {
                    print("Erro nos let de atividades")
                    return
            }
            
            atividade.nome = nome
            atividade.tipo = tipo
            atividade.local = local
            atividade.anotacao = anotacao
            atividade.diaHora = data as NSDate
            atividade.alertaOffSet = offSet
            atividade.offSetString = lbAlerta.text
            
            if(selecionado){
                atividade.cor = materiaSelecionada.cor
                Atividade.changeWithMateria(oldMateria: oldMateria, newMateria: materiaSelecionada, atividade: atividade)
                print("changeWithMateria")
                newId = Notificacoes.idGenerator(type: "Atividade", materia: atividade.relationship!.nome!, title: atividade.nome!, date: atividade.diaHora! as Date)
            }else{
                    atividade.cor = "AAABAA"
                    Atividade.change(atividade: atividade)
                    Atividade.removeMateriaReference(materia: oldMateria, atividade: atividade)
                    print("changewithOutMateria")
                newId = Notificacoes.idGenerator(type: "Atividade", materia: "Indefinido", title: atividade.nome!, date: atividade.diaHora! as Date)
            }
            
            if(atividade.alertaOffSet >= 0 ){
                Notificacoes.update(title: atividade.nome!, oldId: oldId, newId: newId, body: atividade.anotacao!, date: atividade.diaHora! as Date, offSet: atividade.alertaOffSet)
            }else{
                Notificacoes.delete(id: [oldId])
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selecionarAlerta"){
            let destino = segue.destination as! AlertaTableViewController
            destino.alertaProtocol = self as AlertaProtocol
        }else if (segue.identifier == "selecionarTipo"){
            let destino = segue.destination as! TipoAtividadeTableViewController
            destino.tipoAtividadeProtocol = self
        }else if (segue.identifier == "selecionarDisciplina") {
            let destino = segue.destination as! SelecionarDisciplinaTableViewController
            destino.selecionarDisciplinaProtocol = self
        }
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        lbData.text = Controller.dateFormatter.string(from: datePicker.date)
    }
    
    func loadData(){
        tableView.keyboardDismissMode = .onDrag
        tfTitulo.text = atividade.nome
        
        if(atividade.relationship != nil){
            lbDisciplina.text = atividade.relationship?.nome
            oldId = Notificacoes.idGenerator(type: "Atividade",materia: atividade.relationship!.nome!,title: atividade.nome!, date: atividade.diaHora! as Date)
        }else{
            lbDisciplina.text = "Indefinido"
            oldId = Notificacoes.idGenerator(type: "Atividade", materia: "Indefinido",title: atividade.nome!, date: atividade.diaHora! as Date)
        }
        
        Controller.dateTimeFormat()
        datePicker.datePickerMode = .dateAndTime
        lbData.inputView = datePicker
        datePicker.addTarget(self, action: #selector (self.dateChanged(datePicker:)), for: .valueChanged)
        
        lbData.text = Controller.dateFormatter.string(from: atividade.diaHora! as Date)
        
        lbTipo.text = atividade.tipo
        
        lbAlerta.text = atividade.offSetString
        offSet = atividade.alertaOffSet
        
        tfLocal.text = atividade.local
        tfAnotacao.text = atividade.anotacao
        oldMateria = atividade.relationship!
        materiaSelecionada = atividade.relationship!
        
        //GAMBIARRA OU NAO?
        //SEMPRE VAI TER UMA MATERIA SELECIONADA, EXCETO  QUE, SE A COR FOR A DESCRITA ABAIXO, SIGNIFICA QUE A ATIVIDADE
        //NAO TEM VINCULO COM NENHUMA MATERIA, POR ISSO FAZ SE CONTA QUE NAO HÁ, NEM UMA MATERIA SELECIONADA
        if atividade.cor == "AAABAA"{
            selecionado = false
            lbDisciplina.textColor = UIColor.colorWithHexString("AAABAA")
        }else{
            lbDisciplina.textColor = UIColor.colorWithHexString((atividade.relationship?.cor)!)
        }
        navigationItem.title = atividade.nome

    }
}

extension ExibeAtividadesTableViewController: AlertaProtocol{
    func relativeOffSet(offSet: Double, string: String) {
        lbAlerta.text = string
        self.offSet = offSet
    }
}

extension ExibeAtividadesTableViewController: TipoAtividadeProtocol{
    func tipoAtividade(tipo: String) {
        lbTipo.text = tipo
    }
    
}

extension ExibeAtividadesTableViewController: SelecionarDisciplinaProtocol{
    func disciplina(disciplina: Materia, selecionado: Bool) {
        if(selecionado){
            materiaSelecionada = disciplina
            lbDisciplina.text = disciplina.nome
            lbDisciplina.textColor = UIColor.colorWithHexString(disciplina.cor ?? "#00CDF6")
        }else{
            lbDisciplina.text = "Indefinido"
            lbDisciplina.textColor = UIColor.lightGray
        }
        self.selecionado = selecionado
    }
}
