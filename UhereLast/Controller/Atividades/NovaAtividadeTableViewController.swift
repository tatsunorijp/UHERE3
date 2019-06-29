//
//  NovaAtividadeTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 12/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit

class NovaAtividadeTableViewController: UITableViewController {

    
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var lbDisciplina: UILabel!
    @IBOutlet weak var lbTipo: UILabel!
    @IBOutlet weak var tfData: UITextField!
    @IBOutlet weak var lbAlerta: UILabel!
    @IBOutlet weak var tfLocal: UITextField!
    @IBOutlet weak var tfAnotacao: UITextView!
    let datePicker = UIDatePicker()
    var materiaSelecionada = Materia()
    //se offSetSelcionado for -1, significa que está desativado o alarme
    var offSetSelecionado: Double = -1
    var selecionado: Bool = false
    var id: String = ""
    override func viewDidLoad() {
        loadFunctions()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Controller.dateTimeFormat()
    }

    @IBAction func novaAtividade(_ sender: Any) {
        
        if((tfTitulo.text?.isEmpty)! || (tfData.text?.isEmpty)!){
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
        }else{
            Controller.dateTimeFormat()
            guard let nome = tfTitulo.text,
                let tipo = lbTipo.text,
                let local = tfLocal.text,
                let anotacao = tfAnotacao.text,
                let data = Controller.dateFormatter.date(from: tfData.text!)  else {
                    print("Erro nos let de atividades")
                    return
            }
            
            if(selecionado){
                if let atividade = Atividade.init(nome: nome, tipo: tipo, data: data, alertaOffSet: offSetSelecionado, local: local, anotacao: anotacao, cor: materiaSelecionada.cor!, offSetString: lbAlerta.text!){
                    Atividade.saveWithMateria(materia: materiaSelecionada, atividade: atividade)
                    id = Notificacoes.idGenerator(type: "Atividade",materia: atividade.relationship!.nome!, title: atividade.nome!, date: atividade.diaHora! as Date)
                    createNotification(atividade: atividade, id: id)
                }else{
                    print("Erro no if com saveWithMateria")
                }
            }else{
                if let atividade = Atividade.init(nome: nome, tipo: tipo, data: data, alertaOffSet: offSetSelecionado, local: local, anotacao: anotacao, cor: "AAABAA", offSetString: lbAlerta.text!){
                    id = Notificacoes.idGenerator(type: "Atividade",materia: "Indefinido", title: atividade.nome!, date: atividade.diaHora! as Date)
                    createNotification(atividade: atividade, id: id)

                    Atividade.save(atividade: atividade)
                }else{
                    print("Erro no if withOutMateria")
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
            
        

        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selecionarDisciplina") {
            let destino = segue.destination as! SelecionarDisciplinaTableViewController
            destino.selecionarDisciplinaProtocol = self
        }else if (segue.identifier == "selecionarAlerta"){
            let destino = segue.destination as! AlertaTableViewController
            destino.alertaProtocol = self as? AlertaProtocol
        }else if (segue.identifier == "selecionarTipo"){
            let destino = segue.destination as! TipoAtividadeTableViewController
            destino.tipoAtividadeProtocol = self
        }
        
    }
    
    func loadFunctions(){
        datePicker.datePickerMode = .dateAndTime
        tfData.inputView = datePicker
        datePicker.addTarget(self, action: #selector (self.dateChanged(datePicker:)), for: .valueChanged)
        Controller.dateTimeFormat()
        materiaSelecionada = Materia.init(nome: "Indefinido", local: "indefinido", professor: "indefinido", limiteFaltas: 0, faltas: 0, cor: "AAABAA", offSet: 0, offSetString:"Desativado")!
        
        //tfData.text = Controller.dateFormatter.string(from: datePicker.date)
        tableView.keyboardDismissMode = .onDrag

    }
    
    /*@objc func addGesture(textField: UITextField){
        let cliqueView = UITapGestureRecognizer(target: self, action: #selector(self.viewclicada(reconhecedorGesto:)))
        view.addGestureRecognizer(cliqueView)
    }*/
    
    @objc func dateChanged(datePicker: UIDatePicker){
        tfData.text = Controller.dateFormatter.string(from: datePicker.date)
    }
    
    @objc func viewclicada(reconhecedorGesto: UITapGestureRecognizer){
        view.endEditing(true)
        view.gestureRecognizers?.removeAll()
    }
    
    func saveAlerta(atividade: Atividade){
        Alerta.save(calendar: Calendario.mainCalendarName, title: atividade.nome!, starDate: atividade.diaHora! as Date, endDate: atividade.diaHora! as Date , isAllDay: false, offSet: atividade.alertaOffSet, weekDaysSelecteded: [], finalDate: atividade.diaHora! as Date)
    }
    
    func createNotification(atividade: Atividade, id: String){
        if (atividade.alertaOffSet >= 0){
            Notificacoes.create(title: atividade.nome!, body: atividade.anotacao!, date: atividade.diaHora! as Date, offSet: atividade.alertaOffSet, id: id)
        }
    }
    

}

extension NovaAtividadeTableViewController: SelecionarDisciplinaProtocol{
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

/*extension NovaAtividadeTableViewController: AlertaProtocol{
    func relativeOffSet(offSet: Double, string: String) {
        lbAlerta.text = string
        offSetSelecionado = offSet
    }
}*/

extension NovaAtividadeTableViewController: TipoAtividadeProtocol{
    func tipoAtividade(tipo: String) {
        lbTipo.text = tipo
    }
    
    
}
