//
//  NovaMateriaTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 30/10/2018.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import ColorPicker

class NovaMateriaTableViewController: UITableViewController, ColorPickerDelegate {
    @IBOutlet weak var colorPicker: ColorPickerListView!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfLocal: UITextField!
    @IBOutlet weak var tfProfessor: UITextField!
    @IBOutlet weak var tfLimiteFaltas: UITextField!
    @IBOutlet weak var lbAlerta: UILabel!
    var offset: Double = -1.0
    var semestre: Semestre?
    var cor: String?
    var horas: [Date] = []
    var dias: [Bool] = []
    var ids: [String] = []
    
    override func viewDidLoad() {
        loadFunctions()
        
        super.viewDidLoad()
    }
    
    @IBAction func btSave(_ sender: Any) {
        
        if (tfNome.text?.isEmpty)! || (tfLimiteFaltas.text?.isEmpty)! || diasSemanaIsEmpty(){
            Controller.alertaContinuar(titulo: Controller.tituloCampo, menssagem: Controller.menssagemCampo, vc: self)
            print("campos obrigatorios vazios em nova materia")
        }else{
            
            preencherValorPadrao()
            if let materia = Materia.init(nome: tfNome.text!, local: tfLocal.text!, professor: tfProfessor.text!, limiteFaltas: Int(tfLimiteFaltas.text!)!, faltas: 0, cor: cor ?? "#00CDF6", offSet: offset, offSetString: lbAlerta.text!){
                
                if let diasHoras = DiasHoras.init(dias: dias, horas: horas){
                    
                    if(materia.alertaOffSet >= 0){
                        createNotications(materia: materia, dias: dias, horas: horas)
                    }
                    
                    DiasHoras.save(diasHoras: diasHoras, materia: materia)
                    Materia.save(materia: materia, semestre: semestre!)
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    print("erro ao salvar com dias e horas")
                }
                
                
            }
        }
        
    }
    func colorPicker(_ colorPicker: ColorPickerListView, selectedColor: String) {
        cor = selectedColor
        //print(selectedColor)
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
    
    func createNotications(materia: Materia, dias: [Bool], horas: [Date]){
        let content = Notificacoes.createContent(title: Controller.Tipos.Aula.tipo(), body: Notificacoes.aulaString, subtitle: materia.nome!)
        
        for i in 0...dias.count - 1{
            if (dias[i]){
                ids.append(Notificacoes.idGeneratorForMateria(type: Controller.Tipos.Aula.tipo(), materia: materia.nome!, weekday: String(i)))
            }
        }
        
        Notificacoes.createNotificationForMateria(content: content, dias: dias, horas: horas, offSet: materia.alertaOffSet, id: ids)
    }
    
    func preencherValorPadrao(){
        if (tfLocal.text?.isEmpty)!{
            tfLocal.text = "Local"
        }
        if (tfProfessor.text?.isEmpty)!{
            tfProfessor.text = "Professor"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selecionarAlerta"){
            let destino = segue.destination as! AlertaTableViewController
            destino.alertaProtocol = self as AlertaProtocol
        }else if(segue.identifier == "diasSemana"){
            let destino = segue.destination as! SelecionaDiasTableViewController
            destino.diasSemanaProtocol = self as DiasSemanaProtocol
            destino.dias = self.dias
            destino.horas = self.horas
        }
    }
    
    func loadFunctions(){
        configureColorPicker()
        tableView.keyboardDismissMode = .onDrag
        
        Controller.timeFormat()
        for _ in 0...6{
            dias.append(false)
            horas.append(Controller.dateFormatter.date(from: "9:00 am")!)
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

}

extension NovaMateriaTableViewController: AlertaProtocol{
    func relativeOffSet(offSet: Double, string: String) {
        lbAlerta.text = string
        self.offset = offSet
    }
}

extension NovaMateriaTableViewController: DiasSemanaProtocol{
    func diasSemana(dias: [Bool], horas: [Date]) {
        self.dias = dias
        self.horas = horas
    }
}
