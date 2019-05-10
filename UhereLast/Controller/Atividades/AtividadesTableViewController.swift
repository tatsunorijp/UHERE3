//
//  AtividadesTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 29/10/2018.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import CoreData

class AtividadesTableViewController: UITableViewController{
    var semestres: [NSManagedObject] = []
    var materias: [Materia] = []
    var id: String = ""
    //var atividadesIndefinidas: [Atividade] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        Controller.configureTableViewController(view: self)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        materias = []
        loadFunctions()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let atividades = Atividade.getAtividades()
        
        //GAMBIARRA PARA REMOVER O VINCULO ENTRE MATERIAINDEFINIDA E ATIVIDADEINDEFINIDA CRIADAS NA APARICAO DA TELA
        if(atividades.count > 0 ){
        for i in 0...atividades.count-1{
                let atividade = atividades[i] as! Atividade
                if atividade.relationship?.nome == "Indefinido"{
                    atividades[i].setValue(nil, forKeyPath: "relationship")
                }
            }
        }
    }
    
    func loadFunctions(){
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        Controller.dateTimeFormat()
        
        let materiaIndefinida = Materia.init(nome: "Indefinido", local: "", professor: "", limiteFaltas: 0, faltas: 0, cor: "#00CDF6", offSet: 0.0, offSetString: "Desativado")
        let atividades = Atividade.getAtividades()
        
        //CRIA O VINCULO ENTRE MATERIA E ATIVIDADE INDEFINIDA
        if(atividades.count > 0){
            for i in 0...atividades.count-1{
                if atividades[i].value(forKey: "relationship") == nil{
                    materiaIndefinida?.addToRawAtividades(atividades[i] as! Atividade)
                }
            }
            
        }

        if((materiaIndefinida?.atividades?.count)! > 0){
            materias.append(materiaIndefinida!)
        }

        //PEGAR TODAS AS MATERIAS QUE CONTEM ATIVIDADES
        semestres = Semestre.getSemestres()
        if semestres.count != 0 {
            for i in 0...semestres.count-1{
                let semestre = semestres[i] as! Semestre
                if semestre.materias?.count != 0{
                    
                    for j in 0...(semestre.materias?.count)! - 1{
                        if (semestre.materias![j].atividades?.count != 0){
                            materias.append(semestre.materias![j])
                        }
                    }
                }
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return materias.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let materia = materias[section]
        return materia.atividades?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "atividadeCell", for: indexPath) as! AtividadeCell

        let atividade = materias[indexPath.section].atividades![indexPath.row]
        
        cell.lbNome.text = atividade.nome
        cell.lbData.text = Controller.dateFormatter.string(from: atividade.diaHora! as Date)
        cell.lbTipo.text = atividade.tipo
        
        if(atividade.cor == "AAABAA"){
            cell.viewColor.backgroundColor = UIColor.colorWithHexString(atividade.cor!)
        }else{
            cell.viewColor.backgroundColor = UIColor.colorWithHexString(atividade.relationship!.cor!)

        }
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let materia = materias[section]
        
        return materia.nome
    }
 
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Deletar"){ (contextualAction, view, actionPerformed:@escaping (Bool) -> ()) in

            let atividade =  self.materias[indexPath.section].atividades![indexPath.row]
            
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
        if (segue.identifier == "exibeAtividades"){
            guard let destination = segue.destination as? ExibeAtividadesTableViewController,
                let selectedRow = self.tableView.indexPathForSelectedRow?.row,
                let selectedSection = self.tableView.indexPathForSelectedRow?.section else {
                    return
            }
            destination.atividade = materias[selectedSection].atividades![selectedRow]
        }
    }
    

}
