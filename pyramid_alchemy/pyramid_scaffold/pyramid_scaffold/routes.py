def includeme(config):
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('patient', '/patient')
    config.add_route('patients', '/patients')
    config.add_route('addPatient', '/addPatient')
    config.add_route('editPatient', '/editPatient')

    config.add_route('examinations', '/examinations')
    config.add_route('addEmptyInvest', '/addEmptyInvest')
    config.add_route('updateInvest', '/updateInvest')
    config.add_route('deleteExamination', '/deleteExamination')
    config.add_route('printExamination', '/printExamination')

    config.add_route('template', '/template')
    config.add_route('templates', '/templates')
    config.add_route('addTemplate', '/addTemplate')
    config.add_route('editTemplate', '/editTemplate')
    config.add_route('deleteTemplate', '/deleteTemplate')
    
    config.add_route('processExaminationTemplate', '/processExaminationTemplate')
    
    config.add_route('physicians', '/physicians')
    
    config.add_route('allPhysicians', '/allPhysicians')
    config.add_route('addDoctor', '/addDoctor')
    config.add_route('deleteDoctor', '/deleteDoctor')

    config.add_route('getSettings', '/getSettings')
    config.add_route('updateSetting', '/updateSetting')

    config.add_route('departments', '/departments')
    config.add_route('updateDepartmentsAndRooms', '/updateDepartmentsAndRooms')
    
    config.add_route('inPatient', '/inPatient')
    config.add_route('inPatients', '/inPatients')
    config.add_route('addInPatient', '/addInPatient')
    config.add_route('editInPatient', '/editInPatient')
    config.add_route('printOrders', '/printOrders')

    config.add_route('deletePatient', '/deletePatient')


