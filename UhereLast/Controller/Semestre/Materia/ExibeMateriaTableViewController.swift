//
//  ExibeMateriaTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 07/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import ColorPicker

class ExibeMateriaTableViewController: UITableViewController, ColorPickerDelegate {

    var materia = Materia()
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfLocal: UITextField!
    @IBOutlet weak var tfProfessor: UITextField!
    @IBOutlet weak var tfLimiteFaltas: UITextField!
    @IBOutlet weak var lbAvaliacoes: UILabel!
    @IBOutlet weak var colorPicker: ColorPickerListView!
    @IBOutlet weak var lbAlerta: UILabel!
    @IBOutlet weak var lbFaltas: UILabel!
    
    var cor: String?
    var offset: Double = 0.0
    var dias: [Bool] = []
    var horas: [Date] = []
    var diasHoras = DiasHoras()
    var oldIds: [String] = []
    var newIds: [String] = []
    
    override func viewDidLoad() {
        configureColorPicker()
        loadFunctions()
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        self.navigationItem.title = tfNome.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Controller.timeFormat()
    }
    
    
    @IBAction func btDone(_ sender: Any) {
        if (tfNome.text?.isEmpty)! || (tfLimiteFaltas.text?.isEmpty)! || diasSemanaIsEmpty(){
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
        }else{
            materia.nome = tfNome.text
            materia.local = tfLocal.text
            materia.professor = tfProfessor.text
            materia.limiteFalta = Int32(Int(tfLimiteFaltas.text!)!)
            materia.cor = cor
            materia.alertaOffSet = offset
            materia.offSetString = lbAlerta.text
                
            preencherValorPadrao()
            
            changeDates()
            
            if(materia.alertaOffSet >= 0){
                let content = Notificacoes.createContent(title: Controller.Tipos.Aula.tipo(), body: Notificacoes.aulaString, subtitle: materia.nome!)
                Notificacoes.updateForMateria(content: content, dias: dias, horas: horas, offSet: materia.alertaOffSet, oldIds: oldIds, newIds: newIds)
            }else{
                Notificacoes.delete(id: oldIds)
            }
            
            
            DiasHoras.change(diasHoras: diasHoras)
            Materia.change(materia: self.materia)
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    func colorPicker(_ colorPicker: ColorPickerListView, selectedColor: String) {
        cor = selectedColor
        print(selectedColor)
    }
    
    func colorPicker(_ colorPicker: ColorPickerListView, deselectedColor: String) {
    }
    
    func configureColorPicker(){
        colorPicker.colorPickerDelegate = self
        colorPicker.alignment = "center"
        var colors = colorPicker.colors
        colors.append("#00CDF6")
        colorPicker.colors = colors
    }
    
    func loadFunctions(){
        tfNome.text = materia.nome
        tfLocal.text = materia.local
        tfProfessor.text = materia.professor
        tfLimiteFaltas.text = String(materia.limiteFalta)
        
        if let faltas = materia.falta?.count{
            lbFaltas.text = String(faltas)
        }
        if let countAvaliacoes = materia.rawProvas?.count {
            lbAvaliacoes.text = String(countAvaliacoes)
        }
        cor = materia.cor
        lbAlerta.text = materia.offSetString
        offset = materia.alertaOffSet
        navigationItem.title = materia.nome

        loadDates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "provasTableViewController"){
            guard let destination = segue.destination as? AvaliacoesTableViewController else{
                return
            }
            destination.materia = materia
            destination.cor = materia.cor!
        }else if (segue.identifier == "selecionarAlerta"){
            let destino = segue.destination as! AlertaTableViewController
            destino.alertaProtocol = self as AlertaProtocol
        }else if(segue.identifier == "diasSemana"){
            let destino = segue.destination as! SelecionaDiasTableViewController
            destino.diasSemanaProtocol = self as DiasSemanaProtocol
            destino.dias = self.dias
            destino.horas = self.horas
        }else if(segue.identifier == "verFaltas"){
            let destino = segue.destination as! FaltasViewController
            destino.materia = materia
            
    }
        
    }
    
    func loadDates(){
        
        diasHoras = materia.diasHoras!
        dias = Controller.getDiasSemana(diasHoras: diasHoras)
        
        horas.append(diasHoras.hDomingo! as Date)
        horas.append(diasHoras.hSegunda! as Date)
        horas.append(diasHoras.hTerca! as Date)
        horas.append(diasHoras.hQuarta! as Date)
        horas.append(diasHoras.hQuinta! as Date)
        horas.append(diasHoras.hSexta! as Date)
        horas.append(diasHoras.hSabado! as Date)
        
        for i in 0...dias.count - 1{
            if (dias[i]){
                oldIds.append(Notificacoes.idGeneratorForMateria(type: Controller.Tipos.Aula.tipo(), materia: materia.nome!, weekday: String(i)))
            }
        }
    }
    
    func changeDates(){
        diasHoras.domingo = dias[0]
        diasHoras.segunda = dias[1]
        diasHoras.terca = dias[2]
        diasHoras.quarta = dias[3]
        diasHoras.quinta = dias[4]
        diasHoras.sexta = dias[5]
        diasHoras.sabado = dias[6]
        
        diasHoras.hDomingo = horas[0] as NSDate
        diasHoras.hSegunda = horas[1] as NSDate
        diasHoras.hTerca = horas[2] as NSDate
        diasHoras.hQuarta = horas[3] as NSDate
        diasHoras.hQuinta = horas[4] as NSDate
        diasHoras.hSexta = horas[5] as NSDate
        diasHoras.hSabado = horas[6] as NSDate

        for i in 0...dias.count - 1{
            if (dias[i]){
                newIds.append(Notificacoes.idGeneratorForMateria(type: Controller.Tipos.Aula.tipo(), materia: materia.nome!, weekday: String(i)))
            }
        }
    }
    
    func diasSemanaIsEmpty() -> Bool{
        for i in 0...6{
            if (dias[i] == true){
                return false
            }
        }
        return true
    }
    
    func preencherValorPadrao(){
        if (tfLocal.text?.isEmpty)!{
            tfLocal.text = "Local"
        }
        if (tfProfessor.text?.isEmpty)!{
            tfProfessor.text = "Professor"
        }
    }
}

extension ExibeMateriaTableViewController: AlertaProtocol{
    func relativeOffSet(offSet: Double, string: String) {
        lbAlerta.text = string
        self.offset = offSet
    }
}

extension ExibeMateriaTableViewController: DiasSemanaProtocol{
    func diasSemana(dias: [Bool], horas: [Date]) {
        self.dias = dias
        self.horas = horas
    }
}
