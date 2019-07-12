//
//  SelecionarDisciplinaTableViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 11/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//
import UIKit
import CoreData

protocol SelecionarDisciplinaProtocol{
    func disciplina(disciplina: Materia, selecionado: Bool)
}

class SelecionarDisciplinaTableViewController: UITableViewController {
    var selecionarDisciplinaProtocol: SelecionarDisciplinaProtocol?
    var semestres: [Semestre] = []
    var semestreExcluir = Semestre()
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        excluiSemestreIndefinido(semestre: semestreExcluir)
        semestres = []
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return semestres.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let semestre = semestres[section]
        return semestre.materias?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplinaCell", for: indexPath)
        
        let materia = semestres[indexPath.section].materias![indexPath.row]
        cell.textLabel?.text = materia.nome
        cell.textLabel?.textColor = UIColor.colorWithHexString(materia.cor!)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let semestre = semestres[section]
        return semestre.nome
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let semestre = semestres[indexPath.section]
        if let materia = semestre.materias?[indexPath.row]{
            
            //GAMBIARRA, CASO O USUARIO SELECIONE A MATERIA INDEFINIDA, ENTAO O PARAMETRO SELECIONADO
            //SERA FALSO, ISSO EH PARA SABER SE A ATIVIDADE SERA SALVA COM OU SEM MATERIA
            if(indexPath.section == 0){
                selecionarDisciplinaProtocol?.disciplina(disciplina: materia, selecionado: false)
            }else{
                selecionarDisciplinaProtocol?.disciplina(disciplina: materia, selecionado: true)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func loadData(){
        let semestreAll = Semestre.getSemestres()
        semestreExcluir = semestreIndefinido()
        semestres.append(semestreExcluir)
        
        for i in 0...semestreAll.count - 1{
            let aux = semestreAll[i] as! Semestre
            if ((aux.materias?.count)! > 0){
                semestres.append(aux)
            }
        }
}
    func semestreIndefinido() -> Semestre{
        Controller.dateFormat()
        let date = Controller.dateFormatter.date(from: "01/01/2000")
        let semestreIndefinido = Semestre.init(nome: "indefinido", dataInicio: date!, dataFim: date!)
        let materiaIndefinida = Materia.init(nome: "Indefinido", local: "indefinido", professor: "indefinido", limiteFaltas: 0, faltas: 0, cor: "AAABAA", offSet: 0, offSetString: "Desativado")
        semestreIndefinido?.addToRawMaterias(materiaIndefinida!)
        
        return semestreIndefinido!
    }
    
    func excluiSemestreIndefinido(semestre: Semestre){
        semestre.managedObjectContext?.delete(semestre)
    }
    
}
