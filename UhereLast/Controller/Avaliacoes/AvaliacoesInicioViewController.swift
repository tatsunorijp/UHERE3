//
//  AvaliacoesInicioViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 10/04/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit
import CoreData

class AvaliacoesInicioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var semestres: [NSManagedObject] = []
    //var avaliacoes: [Prova] = []
    var materias: [Materia] = []
    var segmentedControlValue: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    struct structProvas{
        var sectionName: String!
        var provas: [Prova]! = []
    }
    
    var provasToShow: [structProvas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Controller.configureTableView(tableView: tableView)
        navigationController?.navigationBar.prefersLargeTitles = true

        //Controller.configureTableView(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFunctions()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        semestres.removeAll()
        //avaliacoes.removeAll()
        materias.removeAll()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(segmentedControlValue != 0){
            return provasToShow.count
        }
        
        return materias.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(segmentedControlValue != 0){
            return provasToShow[section].provas.count
        }
        
        let materia = materias[section]
        return materia.provas?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "avaliacoesCell", for: indexPath) as! AvaliacoesInicioCell
        var prova = Prova()
        
        
        
        if (segmentedControlValue != 0){
            prova = provasToShow[indexPath.section].provas[indexPath.row]
        }else{
            prova = materias[indexPath.section].provas![indexPath.row]
        }
        
        cell.lbNome.text = prova.nome
        cell.lbNota.text = String(prova.nota)
        cell.colorView.backgroundColor = UIColor.colorWithHexString((prova.materia?.cor)!)
        cell.lbData.text = Controller.dateFormatter.string(from: prova.diaHora! as Date)
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(segmentedControlValue != 0){
            return provasToShow[section].sectionName
        }
        
        let materia = materias[section]
        return materia.nome
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Deletar"){ (contextualAction, view, actionPerformed:@escaping (Bool) -> ()) in
            
            let alerta = UIAlertController(title: "DELETAR AVALIAÇÃO", message: "A avaliação "+self.materias[indexPath.section].provas![indexPath.row].nome!+" está sendo deletada, você tem certeza deseja prosseguir ?", preferredStyle: .actionSheet)
            
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alertAction) in
                actionPerformed(false)
            }))
            
            alerta.addAction(UIAlertAction(title: "Deletar", style: .default, handler: {(alertAction) in
                var provaADeletar = Prova()
                
                if(self.segmentedControlValue != 0){
                    provaADeletar = self.provasToShow[indexPath.section].provas[indexPath.row]
                }else{
                    provaADeletar = self.materias[indexPath.section].provas![indexPath.row]
                }
                
                let id = Notificacoes.idGenerator(type: "Avaliacoes",materia: provaADeletar.materia!.nome!, title: provaADeletar.nome!, date: provaADeletar.diaHora! as Date)
                
                Notificacoes.delete(id: [id])
                Prova.delete(prova: provaADeletar)
                if(self.segmentedControlValue != 0){
                    self.provasToShow[indexPath.section].provas.remove(at: indexPath.row)
                }
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                //APÓS DELETAR, A TABELA É ATUALIZADA, DESTA FORMA O VETOR DE MATERIA É ATUALIADO, MAS O DE PROVASTOSHOW NAO, POIS ELE NAO EH CHAMADADO NO APPEAR OU DIDLOAD
                actionPerformed(true)
            }))
            
            self.present(alerta, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    func loadFunctions(){
        
        semestres = Semestre.getSemestres()
        Controller.dateTimeFormat()
        if semestres.count > 0 {
            for i in 0...semestres.count-1{
                let semestre = semestres[i] as! Semestre
                if (semestre.materias?.count)! > 0{
                    for j in 0...(semestre.materias?.count)! - 1{
                        if (semestre.materias![j].provas?.count != 0){
                            materias.append(semestre.materias![j])
                        }
                    }
                }
            }
        }
    }
    
    func loadDataToShow(){
        var localProvas: [Prova] = []
        
        if(materias.count > 0){
            for i in 0...materias.count-1{
                let provasCount = materias[i].provas?.count
                
                if(provasCount! > 0){
                    for j in 0...provasCount! - 1{
                        let prova = materias[i].provas![j]
                        
                        switch segmentedControlValue{
                        case 1:
                            if(biggerThenToday(date: prova.diaHora! as Date)){
                                localProvas.append(prova)
                            }
                        case 2:
                            if(!biggerThenToday(date: prova.diaHora! as Date)){
                                localProvas.append(prova)
                            }
                        default:
                            break
                        }
                    }
                    if(localProvas.count > 0){
                        provasToShow.append(structProvas.init(sectionName: materias[i].nome, provas: localProvas))
                        localProvas = []
                    }
                }
                
            }
        }

    }
    
    func biggerThenToday(date: Date) -> Bool{
        let calendar = NSCalendar.current
        let toDayComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        let dayActivityComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        let toDay = Controller.dateFormatter.calendar.date(from: toDayComponents)!
        let dayActivity = Controller.dateFormatter.calendar.date(from: dayActivityComponents)!
        
        if dayActivity >= toDay{
            return true
        }
        
        return false
    }
    
    
    @IBAction func btSegmentedControlAction(_ sender: UISegmentedControl) {
        segmentedControlValue = sender.selectedSegmentIndex
        
        if(segmentedControlValue != 0){
            provasToShow = []
            loadDataToShow()
            tableView.reloadData()
        }else{
            tableView.reloadData()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "exibeAvaliacao") {
            guard let destination = segue.destination as? ExibeAvaliacaoTableViewController else{
                return
            }
            
            destination.avaliacao = materias[(tableView.indexPathForSelectedRow?.section)!].provas![(tableView.indexPathForSelectedRow?.row)!]
        }
    }

}
