//
//  AvaliacoesTableViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 10/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit
import CoreData

class AvaliacoesInicioTableViewController: UITableViewController {
    var semestres: [NSManagedObject] = []
    var materias: [Materia] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Controller.configureTableViewController(view: self)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFunctions()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        semestres.removeAll()
        materias.removeAll()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return materias.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let materia = materias[section]
        return materia.provas?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "avaliacoesCell", for: indexPath) as! AvaliacoesInicioCell

        
        
        let prova = materias[indexPath.section].provas![indexPath.row]
        cell.lbNome.text = prova.nome
        cell.lbNota.text = String(prova.nota)
        cell.colorView.backgroundColor = UIColor.colorWithHexString((prova.materia?.cor)!)
        cell.lbData.text = Controller.dateFormatter.string(from: prova.diaHora! as Date)
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)


        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let materia = materias[section]
        
        return materia.nome
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Deletar"){ (contextualAction, view, actionPerformed:@escaping (Bool) -> ()) in
            
            let alerta = UIAlertController(title: "DELETAR AVALIAÇÃO", message: "A avaliação "+self.materias[indexPath.section].provas![indexPath.row].nome!+" está sendo deletada, você tem certeza deseja prosseguir ?", preferredStyle: .actionSheet)
            
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alertAction) in
                actionPerformed(false)
            }))
            
            alerta.addAction(UIAlertAction(title: "Deletar", style: .default, handler: {(alertAction) in
                let provaADeletar = self.materias[indexPath.section].provas![indexPath.row]
                
                let id = Notificacoes.idGenerator(type: "Avaliacoes",materia: provaADeletar.materia!.nome!, title: provaADeletar.nome!, date: provaADeletar.diaHora! as Date)
                Notificacoes.delete(id: [id])
                Prova.delete(prova: provaADeletar)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "exibeAvaliacao") {
            guard let destination = segue.destination as? ExibeAvaliacaoTableViewController else{
                return
            }
            
            destination.avaliacao = materias[(tableView.indexPathForSelectedRow?.section)!].provas![(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
