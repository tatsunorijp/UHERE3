//
//  AtividadesViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 10/04/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit
import CoreData

class AtividadesViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: TableView!
    var semestres: [NSManagedObject] = []
    var materias: [Materia] = []
    var id: String = ""
    var segmentedControlValue: Int = 0

    struct atividadesStruct{
        var sectionName: String!
        var atividades: [Atividade]!
    }
    
    var atividadesToShow: [atividadesStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFunctions()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //GAMBIARRA PARA REMOVER O VINCULO ENTRE MATERIAINDEFINIDA E ATIVIDADEINDEFINIDA CRIADAS NA APARICAO DA TELA
        let atividadesWithOutMateria = Atividade.getAtividadesWithOutMateria()
        for atividade in atividadesWithOutMateria {
            atividade.relationship = nil
        }
    }
    
    func loadFunctions(){
        Controller.dateTimeFormat()
        
        let materiaIndefinida = Materia.init(nome: "Indefinido", local: "", professor: "", limiteFaltas: 0, faltas: 0, cor: "#00CDF6", offSet: 0.0, offSetString: "Desativado")

        materias = Materia.getMateriasWithAtividades()

        let atividadesWithOutMateria = Atividade.getAtividadesWithOutMateria()
        //GAMBIARRA PARA ADD VINCULO NA ATIVIDADE SEM MATERIA
        for atividade in atividadesWithOutMateria {
            materiaIndefinida?.addToRawAtividades(atividade)
        }

        if !(materiaIndefinida?.atividades!.isEmpty)! {
            materias.append(materiaIndefinida!)
        }
    }
    
    func loadDataToShow(){
        var localAtividades: [Atividade] = []
        if segmentedControlValue == 1{
            for materia in materias{
                for atividade in materia.atividades!{
                    if(!atividade.concluido){
                        localAtividades.append(atividade)
                    }
                }
                if(localAtividades.count > 0){
                    atividadesToShow.append(atividadesStruct.init(sectionName: materia.nome, atividades: localAtividades))
                    localAtividades = []
                }
            }
        }else {
            for materia in materias{
                for atividade in materia.atividades!{
                    if(atividade.concluido){
                        localAtividades.append(atividade)
                    }
                }
                if(localAtividades.count > 0){
                    atividadesToShow.append(atividadesStruct.init(sectionName: materia.nome, atividades: localAtividades))
                    localAtividades = []
                }
            }
        }
    

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(segmentedControlValue != 0){
            return atividadesToShow.count
        }
        return materias.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(segmentedControlValue != 0){
            return atividadesToShow[section].atividades.count
        }
        
        let materia = materias[section]
        return materia.atividades?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "atividadeCell", for: indexPath) as! AtividadeCell
        var atividade = Atividade()
        
        switch segmentedControlValue {
        case 1:
            atividade = atividadesToShow[indexPath.section].atividades[indexPath.row]
        case 2:
            atividade = atividadesToShow[indexPath.section].atividades[indexPath.row]
        default:
            atividade = materias[indexPath.section].atividades![indexPath.row]
        }

        cell.lbNome.text = atividade.nome
        cell.lbData.text = Controller.dateFormatter.string(from: atividade.diaHora! as Date)
        cell.lbTipo.text = atividade.tipo
         
        if(atividade.cor == "AAABAA"){
            cell.viewColor.backgroundColor = UIColor.colorWithHexString(atividade.cor!)
        }else{
            cell.viewColor.backgroundColor = UIColor.colorWithHexString(atividade.relationship!.cor!)
         
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(segmentedControlValue != 0){
            return atividadesToShow[section].sectionName
        }
        
        let materia = materias[section]
        return materia.nome
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Deletar"){ (contextualAction, view, actionPerformed:@escaping (Bool) -> ()) in
            
            var atividade = Atividade()
            if(self.segmentedControlValue != 0){
                atividade = self.atividadesToShow[indexPath.section].atividades[indexPath.row]
            }else{
                atividade =  self.materias[indexPath.section].atividades![indexPath.row]
            }
            
            let alerta = UIAlertController(title: "DELETAR ATIVIDADE", message: "A atividade "+atividade.nome!+" está sendo deletada, você tem certeza deseja prosseguir ?", preferredStyle: .actionSheet)
            
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alertAction) in
                actionPerformed(false)
            }))
            
            alerta.addAction(UIAlertAction(title: "Deletar", style: .default, handler: {(alertAction) in
                
                if (atividade.relationship != nil){
                    self.id = Notificacoes.idGenerator(type: "Atividade",materia: atividade.relationship!.nome!, title: atividade.nome!, date: atividade.diaHora! as Date)
                }else{
                    self.id = Notificacoes.idGenerator(type: "Atividade",materia: "Indefinido", title: atividade.nome!, date: atividade.diaHora! as Date)
                }
                
                
                Notificacoes.delete(id: [self.id])
                Atividade.delete(atividade: atividade)
                if(self.segmentedControlValue != 0){
                    self.atividadesToShow[indexPath.section].atividades.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                //APÓS DELETAR, A TABELA É ATUALIZADA, DESTA FORMA O VETOR DE SEMESTRE E MATERIA É ATUALIADO, MAS O DE ATIVIDADESTOSHOW NAO, POIS ELE NAO EH CHAMADADO NO APPEAR OU DIDLOAD
                actionPerformed(true)
            }))
            
            self.present(alerta, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    @IBAction func btSegmentedControlAction(_ sender: UISegmentedControl) {
        segmentedControlValue = sender.selectedSegmentIndex
        
        if(segmentedControlValue != 0){
            atividadesToShow = []
            loadDataToShow()
            tableView.reloadData()
        }else{
            tableView.reloadData()
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "exibeAtividades"){
            guard let destination = segue.destination as? ExibeAtividadesTableViewController,
                let selectedRow = self.tableView.indexPathForSelectedRow?.row,
                let selectedSection = self.tableView.indexPathForSelectedRow?.section else {
                    return
            }
            
            if(segmentedControlValue != 0){
                destination.atividade = atividadesToShow[selectedSection].atividades[selectedRow]
            }else{
                destination.atividade = materias[selectedSection].atividades![selectedRow]
            }
        }
    }
}
