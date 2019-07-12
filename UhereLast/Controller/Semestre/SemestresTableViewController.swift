//
//  SemestresTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 29/10/2018.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import CoreData

class SemestresTableViewController: TableViewController {
    var semestres: [NSManagedObject] = []
    var indexToEdit: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        semestres = Semestre.getSemestres()
        tableView.reloadData()
        indexToEdit = nil
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semestres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "semestreCell", for: indexPath) as! SemestreCell
        let semestre = semestres[indexPath.row] as! Semestre
        // Configure the cell...
        Controller.dateFormat()
        
        cell.lbTitulo.text = semestre.nome//(semestres[indexPath.row].value(forKey: "nome") as! String)
        cell.lbDataInicio.text = Controller.dateFormatter.string(from: semestre.dataInicio! as Date)
        cell.lbDataFim.text = Controller.dateFormatter.string(from: semestre.dataFim! as Date)
        cell.lbTotalMaterias.text = semestre.materias?.count.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit", handler: { (contextualization, view, actionPerformed:
            (Bool) -> () ) in
            self.indexToEdit = indexPath.row
            self.performSegue(withIdentifier: "edit", sender: nil)
            
            actionPerformed(true)
        })
        
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Deletar"){ (contextualAction, view, actionPerformed:@escaping (Bool) -> ()) in
            
            let semestre = self.semestres[indexPath.row] as! Semestre
            
            let alerta = UIAlertController(title: "DELETAR SEMESTRE", message: "O semestre "+semestre.nome!+" está sendo deletada, você tem certeza deseja prosseguir ?", preferredStyle: .actionSheet)
            
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alertAction) in
                actionPerformed(false)
            }))
            
            alerta.addAction(UIAlertAction(title: "Deletar", style: .default, handler: {(alertAction) in
                self.deleteMaterias(indexPath: indexPath.row)
                Semestre.delete(semestre: self.semestres[indexPath.row] as! Semestre)
                self.semestres.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                actionPerformed(true)
            }))
            
            self.present(alerta, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "materiasTableViewController"){
            guard let destination = segue.destination as? MateriasTableViewController,
                let selectedRow = self.tableView.indexPathForSelectedRow?.row else {
                    return
            }
            destination.semestre = semestres[selectedRow] as? Semestre
        }else if (segue.identifier == "edit"){
            guard let destination = segue.destination as? SemestreCadastroTableViewController else {
                return
            }
            if (indexToEdit != nil){
                destination.semestre = semestres[indexToEdit!] as? Semestre
                destination.edit = indexToEdit
            }
        }
    }
    
    func deleteMaterias(indexPath: Int){
        var dias: [Bool] = []
        var ids: [String] = []
        //dias = Controller.getDiasSemana(diasHoras: diasHoras)
        let semestre = semestres[indexPath] as! Semestre
        let materias = semestre.materias
        
        for materia in materias!{
            dias = Controller.getDiasSemana(diasHoras: materia.diasHoras!)
            for i in 0...dias.count - 1{
                if(dias[i]){
                    ids.append(Notificacoes.idGeneratorForMateria(type: Controller.Tipos.Aula.tipo(), materia: materia.nome!, weekday: String(i)))
                }
            }
            
            let provas = materia.provas
            for provaADeletar in provas!{
                let id = Notificacoes.idGenerator(type: "Avaliacoes", materia: provaADeletar.materia!.nome!, title: provaADeletar.nome!, date: provaADeletar.diaHora! as Date)
                ids.append(id)
            }
            
            let atividades = materia.atividades
            for atividade in atividades!{
                let id: String!
                if (atividade.relationship != nil){
                    id = Notificacoes.idGenerator(type: "Atividade",materia: atividade.relationship!.nome!, title: atividade.nome!, date: atividade.diaHora! as Date)
                }else{
                    id = Notificacoes.idGenerator(type: "Atividade",materia: "Indefinido", title: atividade.nome!, date: atividade.diaHora! as Date)
                }
                
                ids.append(id)
            }
            
            
            Notificacoes.delete(id: ids)
            ids = []
        }
    }

}
