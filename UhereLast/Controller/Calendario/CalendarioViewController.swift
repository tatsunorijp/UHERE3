//
//  CalendarioViewController.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 26/10/2018.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit
import JTAppleCalendar
import EventKit
import UserNotifications


struct Objects{
    var sectionName: String!
    var avaliacoes: [Prova]
    var atividades: [Atividade]
}


class CalendarioViewController: UIViewController, UITabBarDelegate, UITableViewDataSource{
    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var lbMesAno: UILabel!
    
    var mes = String()
    var ano = String()
    var avaliacoes: [Prova] = []
    var atividades: [Atividade] = []
    var materias: [Materia] = []
    var materiasToShow: [Materia] = []
    var segmentedControlValue: Int = 0
    var weekDayToShow: Int = 0
    

    
    var activitysToShow = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitysToShow = [Objects(sectionName: "Avaliações", avaliacoes: [], atividades: []),
                            Objects(sectionName: "Atividades", avaliacoes: [], atividades: [])]
        
        getCompromissos()
        configureCalendar()
        checkNotificationsAuthorization()
        
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        materias = []
        getCompromissos()
        calendarView.reloadData()
        Notificacoes.getNotifications()
    }
    
    @IBAction func btHojeActionHandler(_ sender: Any) {
        self.calendarView.scrollToDate(Date(), animateScroll: true)
        
        calendarView.selectDates([ Date() ])
        configureMesAnoLabel()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (segmentedControlValue != 0 ){
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(segmentedControlValue != 0){
            return materiasToShow.count
        }
        
        if(section == 0){
            return activitysToShow[0].avaliacoes.count
        }else{
            return activitysToShow[1].atividades.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activitysCell", for: indexPath) as! ActivitysCell
        
        if (segmentedControlValue != 0){
            let materia = materiasToShow[indexPath.row]
            let hora = Controller.dateFormatter.string(from: getHourFromWeekDay(materia: materia, weekDay: weekDayToShow) as Date)
            
            cell.lbMateriaEsq.text = "Faltas:"
            cell.lbDataEsq.text = "Hora:"
            
            cell.lbTitulo.text = materia.nome
            cell.lbData.text = hora
            cell.lbMateria.text = String(materia.faltas) + "/" + String(materia.limiteFalta)
            cell.colorView.backgroundColor = UIColor.colorWithHexString(materia.cor!)
        }else{
            if(indexPath.section == 0){
                let avaliacao = activitysToShow[0].avaliacoes[indexPath.row]
                
                cell.lbTitulo.text = avaliacao.nome
                cell.lbMateria.text = avaliacao.materia?.nome
                cell.lbData.text = Controller.dateFormatter.string(from: avaliacao.diaHora! as Date)
                cell.colorView.backgroundColor = UIColor.colorWithHexString(avaliacao.materia!.cor!)
            }else{
                let atividade = activitysToShow[1].atividades[indexPath.row]
                
                cell.lbTitulo.text = atividade.nome
                cell.lbData.text = Controller.dateFormatter.string(from: atividade.diaHora! as Date)
                
                if (atividade.relationship == nil){
                    cell.lbMateria.text = "Indefinido"
                    cell.colorView.backgroundColor = Controller.grayColor
                }else{
                    cell.lbMateria.text = atividade.relationship?.nome
                    cell.colorView.backgroundColor = UIColor.colorWithHexString(atividade.relationship!.cor!)
                }
                
                
            }
        }

        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (segmentedControlValue != 0){
            return "Aulas"
        }
        return activitysToShow[section].sectionName
    }
    
    func configureDataCells(date: Date){
        if(segmentedControlValue != 0){
            Controller.timeFormat()
            loadMateriasToShow(date: date)
        }else{
            Controller.dateTimeFormat()
            loadActivitysToShow(date: date)
        }
        tableView.reloadData()
    }
    
    func getCompromissos(){
        let semestres = Semestre.getSemestres() as! [Semestre]
        /*avaliacoes = []
        atividades = []
        if semestres.count > 0 {
            for semestre in semestres{
                for materia in semestre.materias!{
                    materias.append(materia)
                    
                    if(materia.provas!.count > 0){
                        for prova in materia.provas!{
                            avaliacoes.append(prova)
                        }
                    }
                    
                    if(materia.atividades!.count > 0){
                        for atividade in materia.atividades!{
                            atividades.append(atividade)
                        }
                    }
                }
            }
        }
        
        let atividadesTodas = Atividade.getAtividades() as! [Atividade]
        for atividade in atividadesTodas{
            if (atividade.relationship == nil){
                atividades.append(atividade)
            }
        }
    */
        for semestre in semestres {
            for materia in semestre.materias!{
                materias.append(materia)
            }
        }
        avaliacoes = Prova.getProvas() as! [Prova]
        atividades = Atividade.getAtividades() as! [Atividade]

    }
    
    func configureCalendar(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        self.calendarView.scrollToDate(Date(), animateScroll: false)
        
        calendarView.selectDates([ Date() ])
        configureMesAnoLabel()
    }
    
    func configureMesAnoLabel(){
        calendarView.visibleDates{ visibleDates in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "yyyy"
            self.ano = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "MMMM"
            self.mes = self.formatter.string(from: date)
            self.navigationItem.title = self.mes + ", " + self.ano
        }
    }
    
    func cellSelection(view: JTAppleCell?, cellState: CellState){
        guard let diaCell = view as? DiaCell else { return }
        
        if cellState.isSelected{
            diaCell.selectedView.isHidden = false
            diaCell.dataLabel.textColor = .black
            
            if (diaCell.activityView.isHidden == false){
                diaCell.activityView.backgroundColor = .black
            }
            
        }else{
            diaCell.selectedView.isHidden = true
            if (diaCell.activityView.isHidden == false){
                diaCell.activityView.backgroundColor = .white
            }
            
            if cellState.dateBelongsTo == .thisMonth{
                diaCell.dataLabel.textColor = .white
            }else{
                diaCell.dataLabel.textColor = Controller.grayColor
            }
        }
    }
    
    func compareDate(date: Date) -> Bool{
        let calendar = NSCalendar.current
        let dayCalendar = calendar.dateComponents([.day, .month, .year], from: date)

        if avaliacoes.count > 0 {
            for i in 0...avaliacoes.count - 1 {
                let dayActivity = calendar.dateComponents([.day, .month, .year], from: avaliacoes[i].diaHora! as Date)
                if dayCalendar == dayActivity{
                    return true
                }
            }
        }
        
        if atividades.count > 0{
            for i in 0...atividades.count - 1 {
                let dayActivity = calendar.dateComponents([.day, .month, .year], from: atividades[i].diaHora! as Date)
                if dayCalendar == dayActivity{
                    return true
                }
            }
        }
        
        return false
    }
    
    func loadActivitysToShow(date: Date){
        activitysToShow[0].avaliacoes = []
        activitysToShow[1].atividades = []
        let calendar = NSCalendar.current
        let dayCalendar = calendar.dateComponents([.day, .month, .year], from: date)
        
        if avaliacoes.count > 0 {
            for avaliacao in avaliacoes {
                let dayActivity = calendar.dateComponents([.day, .month, .year], from: avaliacao.diaHora! as Date)
                if dayCalendar == dayActivity{
                    activitysToShow[0].avaliacoes.append(avaliacao)
                }
            }
        }
        
        if atividades.count > 0{
            for atividade in atividades {
                let dayActivity = calendar.dateComponents([.day, .month, .year], from: atividade.diaHora! as Date)
                if dayCalendar == dayActivity{
                    activitysToShow[1].atividades.append(atividade)
                }
            }
        }
    }
    
    func loadMateriasToShow(date:Date){
        var dias:[Bool] = []
        materiasToShow = []
        for materia in materias{
            dias = []
            
            let diasHoras = materia.diasHoras
            dias =  Controller.getDiasSemana(diasHoras: diasHoras!)
            
            let calendar = Calendar.current
            let dayCalendar = calendar.dateComponents([.weekday], from: date)
            
            for i in 0...dias.count-1{
                //POR ALGUM MOTIVO, AS WEEKDAY ESTAO EM 1...7, AO INVEZ DE 0...6
                // POR ISSO ESTA SENDO SUBTRAINDO 1 EM WEEKDAY
                if(dias[i] && (dayCalendar.weekday! - 1 == i)){
                    weekDayToShow = i
                    materiasToShow.append(materia)
                }
            }
        }
        
        
    }
    
    func getHourFromWeekDay(materia: Materia, weekDay: Int) -> NSDate{
        switch weekDay {
        case 0:
            return materia.diasHoras!.hDomingo!
        case 1:
            return materia.diasHoras!.hSegunda!
        case 2:
            return materia.diasHoras!.hTerca!
        case 3:
            return materia.diasHoras!.hQuarta!
        case 4:
            return materia.diasHoras!.hQuinta!
        case 5:
            return materia.diasHoras!.hSexta!
        default:
            return materia.diasHoras!.hSabado!
        }
    }
    
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        segmentedControlValue = sender.selectedSegmentIndex
        let date = calendarView.selectedDates
        configureDataCells(date: date[0])
    }
    
    
    func checkNotificationsAuthorization(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            switch (granted){
            case false:
                let openSettingsUrl = URL(string: UIApplication.openSettingsURLString)
                let alerta = UIAlertController(title: "UHere gostaria de enviar notificações ao seu celular", message: "Notificações podem incluir alertas, sons e icones. Isto pode ser auterado em suas configurações. SEM ESTA PERMISSÃO O APP NÃO PODERÁ EXERCER TODAS AS SUAS FUNCIONALIDADES.", preferredStyle: .alert)
                
                alerta.addAction(UIAlertAction(title: "Continuar", style: .default, handler: {(alertAction) in
                    UIApplication.shared.open(openSettingsUrl!, options: [:])
                }))
                
                self.present(alerta, animated: true, completion: nil)
            case true:
                break
            }
        }
    }

}

extension CalendarioViewController: JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "diaCell", for: indexPath) as! DiaCell
        cell.dataLabel.text = cellState.text
        cellSelection(view: cell, cellState: cellState)
        cell.activityView.isHidden = true
        if(compareDate(date: date)){
            cell.activityView.isHidden = false
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        cellSelection(view: cell, cellState: cellState)
        activitysToShow[0].avaliacoes = []
        activitysToShow[1].avaliacoes = []
        configureDataCells(date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        cellSelection(view: cell, cellState: cellState)

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        configureMesAnoLabel()
        materias = []
        getCompromissos()
    }
    
    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        
    }
}

extension CalendarioViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01/01/2018")!
        let endDate = formatter.date(from: "31/12/2025")!
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

