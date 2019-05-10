//
//  ProvaTableViewController.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 18/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit

class AvaliacoesTableViewController: UITableViewController {
    var materia = Materia()
    var cor: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Controller.configureTableViewController(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return materia.rawProvas?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "avaliacoesCell", for: indexPath) as! AvaliacoesInicioCell
        
        if let prova = materia.provas?[indexPath.row]{
            Controller.dateTimeFormat()
            cell.lbNome.text = prova.nome
            cell.lbNota.text = String(prova.nota)
            cell.lbData.text = Controller.dateFormatter.string(from: prova.diaHora! as Date)
            cell.colorView.backgroundColor = UIColor.colorWithHexString(materia.cor!)
            cell.backgroundColor = UIColor(white: 0.95, alpha: 1)

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return materia.nome
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Deletar"){ (contextualAction, view, actionPerformed:@escaping (Bool) -> ()) in
            
            let alerta = UIAlertController(title: "DELETAR AVALIAÇÃO", message: "A avaliação "+self.materia.provas![indexPath.row].nome!+" está sendo deletada, você tem certeza deseja prosseguir ?", preferredStyle: .actionSheet)
            
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alertAction) in
                actionPerformed(false)
            }))
            
            alerta.addAction(UIAlertAction(title: "Deletar", style: .default, handler: {(alertAction) in
                if let provaADeletar = self.materia.provas?[indexPath.row] {
                    let id = Notificacoes.idGenerator(type: "Avaliacoes", materia: provaADeletar.materia!.nome!, title: provaADeletar.nome!, date: provaADeletar.diaHora! as Date)
                    Notificacoes.delete(id: [id])
                    Prova.delete(prova: provaADeletar)
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                actionPerformed(true)
            }))
            
            self.present(alerta, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
 


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "novaAvaliacao") {
            guard let destination = segue.destination as? NovaAvaliacaoTableViewController else{
                return
            }
            destination.materia = materia
            destination.cor = cor
        }
        
        if (segue.identifier == "exibeAvaliacao") {
            guard let destination = segue.destination as? ExibeAvaliacaoTableViewController else{
                return
            }
            
            destination.avaliacao = materia.provas![(tableView.indexPathForSelectedRow?.row)!]

            
        }
        
    }
 

}
