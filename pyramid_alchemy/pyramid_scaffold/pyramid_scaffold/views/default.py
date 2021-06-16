from pyramid.response import Response
from pyramid.view import view_config

from dateutil.relativedelta import relativedelta

from sqlalchemy.ext.declarative import DeclarativeMeta
from sqlalchemy_pagination import paginate
from sqlalchemy.exc import DBAPIError, NoResultFound
from sqlalchemy import engine_from_config, or_, and_

import jsonschema
import json
from datetime import datetime
from time import gmtime, strftime
from decimal import Decimal
from datetime import datetime
import arrow

from .. import models


@view_config(route_name='home', renderer='../templates/index.jinja2')
def homepage(request):
    return ""


@view_config(route_name='patients', renderer='json')
def get_patients(request):
    pageNum = 1
    if 'page' in request.params:
        pageNum = int(request.params['page'])
    dbRequest = request.dbsession.query(models.Patients)

    if 'family' in request.params and len(request.params['family']) > 0:
        dbRequest = dbRequest.filter(
            models.Patients.family.ilike(request.params['family'] + '%'))
    if 'tags' in request.params and len(request.params['tags']):
        dbRequest = dbRequest.filter(
            models.Patients.tags == request.params['tags'])
    print(dbRequest)

    page = paginate(dbRequest, pageNum, 20)

    return dict(items=[(row.to_dict()) for row in page.items], totalItems=page.total, totalPages=page.pages, per_page=25)


@view_config(route_name='patient', renderer='json')
def get_patient(request):
    if 'id' not in request.params:
        return "{ error : 'no id'}"

    dbRequest = request.dbsession.query(models.Patients).filter(
        models.Patients.id == int(request.params['id']))

    print(str(dbRequest))

    return dbRequest.one().to_dict()


@view_config(route_name='examinations', renderer='json')
def get_examinations(request):
    pageNum = 1
    if 'page' in request.params:
        pageNum = int(request.params['page'])

    dbRequest = request.dbsession.query(
        models.Examinations).join(models.Patients)

    if 'patientId' in request.params:
        dbRequest = dbRequest.filter(
            models.Examinations.patientId == int(request.params['patientId']))

    print(str(dbRequest))

    page = paginate(dbRequest, pageNum, 10)

    return dict(items=[(row.to_dict(max_nesting=2)) for row in page.items], totalItems=page.total, totalPages=page.pages, per_page=10)


@view_config(route_name='templates', renderer='json')
def get_templates(request):
    pageNum = 1
    if 'page' in request.params:
        pageNum = int(request.params['page'])

    dbRequest = request.dbsession.query(models.Templates)

    print(str(dbRequest))

    page = paginate(dbRequest, pageNum, 20)

    return dict(items=[(row.to_dict()) for row in page.items], totalItems=page.total, totalPages=page.pages, per_page=25)


@view_config(route_name='template', renderer='json')
def get_template(request):
    if 'id' not in request.params:
        return "{ error : 'no id'}"

    dbRequest = request.dbsession.query(models.Templates).filter(
        models.Templates.id == int(request.params['id']))

    print(str(dbRequest))

    return dbRequest.one().to_dict()


@view_config(route_name='deleteTemplate', renderer='json')
def delete_template(request):
    if 'id' not in request.params:
        return "{ error : 'no id'}"
    else:
        request.dbsession.query(models.Templates).filter(
            models.Templates.id == int(request.params['id'])).delete()
        return "{ succeed : 'ok'}"

@view_config(route_name='deletePatient', renderer='json')
def delete_patient(request):
    if 'id' not in request.params:
        return "{ error : 'no id'}"
    else:
        request.dbsession.query(models.Patients).filter(
            models.Patients.id == int(request.params['id'])).delete()
        return "{ succeed : 'ok'}"


@view_config(route_name='deleteExamination', renderer='json')
def delete_examination(request):
    if 'id' not in request.params:
        return "{ error : 'no id'}"
    else:
        request.dbsession.query(models.Examinations).filter(
            models.Examinations.id == int(request.params['id'])).delete()
        return "{ succeed : 'ok'}"


@view_config(route_name='physicians', renderer='json')
def get_physicians(request):
    pageNum = 1
    if 'page' in request.params:
        pageNum = int(request.params['page'])

    dbRequest = request.dbsession.query(models.Physicians)

    print(str(dbRequest))

    page = paginate(dbRequest, pageNum, 20)

    return dict(items=[(row.to_dict()) for row in page.items], totalItems=page.total, totalPages=page.pages, per_page=25)


@view_config(route_name='allPhysicians', renderer='json')
def get_all_physicians(request):

    dbRequest = request.dbsession.query(models.Physicians)

    print(str(dbRequest))

    return dict(physicians=[(row.to_dict()) for row in dbRequest.all()])


@view_config(route_name='addPatient', renderer='json')
def add_patient(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    patientSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "name": {"type": "string"},
            "family": {"type": "string"},
        },
        "required": ["name", "family"]
    }

    patientValidator = jsonschema.Draft4Validator(
        patientSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        patientValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in patientValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    newPatient = models.Patients.new_from_json(jsons)
    request.dbsession.add(newPatient)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='editPatient', renderer='json')
def edit_patient(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    patientSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "name": {"type": "string"},
            "family": {"type": "string"},
        },
        "required": ["name", "family"]
    }

    patientValidator = jsonschema.Draft4Validator(
        patientSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        patientValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in patientValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    dbRequest = request.dbsession.query(models.Patients).filter(
        models.Patients.id == json.loads(jsons)['id'])
    dbRequest.one().update_from_json(jsons)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='addTemplate', renderer='json')
def add_template(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    templateSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "name": {"type": "string"},
            "content": {"type": "string"},
        },
        "required": ["name", "content"]
    }

    templateValidator = jsonschema.Draft4Validator(
        templateSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        templateValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in templateValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    newTemplate = models.Templates.new_from_json(jsons)
    request.dbsession.add(newTemplate)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='editTemplate', renderer='json')
def edit_template(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    templateSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "name": {"type": "string"},
            "content": {"type": "string"},
        },
        "required": ["name", "content"]
    }

    templateValidator = jsonschema.Draft4Validator(
        templateSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        templateValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in templateValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    dbRequest = request.dbsession.query(models.Templates).filter(
        models.Templates.id == json.loads(jsons)['id'])
    dbRequest.one().update_from_json(jsons)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='addDoctor', renderer='json')
def add_doctor(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    doctorSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "family": {"type": "string"},
            "name": {"type": "string"},
        },
        "required": ["name", "family"]
    }

    doctorValidator = jsonschema.Draft4Validator(
        doctorSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        doctorValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in doctorValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    newDoctor = models.Physicians.new_from_json(jsons)
    request.dbsession.add(newDoctor)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='deleteDoctor', renderer='json')
def delete_doctor(request):

    if 'id' in request.params:
        request.dbsession.query(models.Physicians).filter_by(
            id=request.params['id']).delete()
        request.dbsession.flush()
        return '{result : "ok"}'
    else:
        return '{result : "error"}'


@view_config(route_name='getSettings', renderer='json')
def get_settings(request):

    dbRequest = request.dbsession.query(models.Configs).filter(
        or_(models.Configs.name == 'clinicName', models.Configs.name == 'clinicAddress'))

    print(str(dbRequest))
    result = settingsDTO()

    for row in dbRequest.all():
        if row.name == 'clinicName':
            result.clinicName = row
        elif row.name == 'clinicAddress':
            result.clinicAddress = row

    return result.to_dict()


@view_config(route_name='updateSetting', renderer='json')
def update_setting(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    templateSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "id": {"type": "integer"},
            "name": {"type": "string"},
            "value": {"type": "string"},
        },
        "required": ["id", "name", "value"]
    }

    templateValidator = jsonschema.Draft4Validator(
        templateSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        templateValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in templateValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    dbRequest = request.dbsession.query(models.Configs).filter(
        models.Configs.id == json.loads(jsons)['id'])
    dbRequest.one().update_from_json(jsons)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='updateInvest', renderer='json')
def update_invest(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    investSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "id": {"type": "integer"},
            "name": {"type": "string"},
        },
        "required": ["id", "name"]
    }

    investValidator = jsonschema.Draft4Validator(
        investSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        investValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in investValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    dbRequest = request.dbsession.query(models.Examinations).filter(
        models.Examinations.id == json.loads(jsons)['id'])
    dbRequest.one().update_from_json(jsons)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='updateDepartmentsAndRooms', renderer='json')
def update_departments_and_rooms(request):
    if not request.body.decode('utf-8'):
        return ""

    jsons = request.body.decode('utf-8')
    departments = json.loads(jsons)
    for department in departments:
        print(department['id'])
        departmentId = department['id']
        dbRequestDepartments = request.dbsession.query(models.Departments).filter(
            models.Departments.id == department['id'])
        try:
            resDepartment = dbRequestDepartments.one()
            resDepartment.update_from_dict(
                input_data=department, error_on_extra_keys=False, drop_extra_keys=True)
        except NoResultFound:
            department['id'] = None
            newDepartment = models.Departments.new_from_dict(
                input_data=department, error_on_extra_keys=False, drop_extra_keys=True)
            request.dbsession.add(newDepartment)
        if 'children' in department:
            print(department['children'])
            for room in department['children']:
                room['departmentId'] = departmentId
                print(room)
                dbRequestRooms = request.dbsession.query(models.Rooms).filter(
                    models.Rooms.id == room['id'])
                try:
                    resRooms = dbRequestRooms.one()
                    resRooms.update_from_dict(
                        input_data=room, error_on_extra_keys=False, drop_extra_keys=True)
                except NoResultFound:
                    room['id'] = None
                    newRoom = models.Rooms.new_from_dict(
                        input_data=room, error_on_extra_keys=False, drop_extra_keys=True)
                    request.dbsession.add(newRoom)

    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='departments', renderer='json')
def get_departments(request):
    dbRequest = request.dbsession.query(models.Departments)

    print(str(dbRequest))

    return {'departments': [(row.to_dict(max_nesting=2)) for row in dbRequest.all()]}


@view_config(route_name='addEmptyInvest', renderer='json')
def add_empty_invest(request):
    if 'patientId' not in request.params:
        return '{result : "error"}'

    newExamination = models.Examinations(
        patientId=request.params['patientId'], name='консультация', examinationDate=datetime.today().strftime('%Y-%m-%d'))
    request.dbsession.add(newExamination)
    request.dbsession.flush()
    return '{result : "ok"}'


@view_config(route_name='processExaminationTemplate', renderer='string')
def process_examination_template(request):
    if 'items_number' not in request.params:
        return '{result : "error"}'

    print(request.params['patient_id'])
    data = []
    items_number = request.params['items_number'] if 'items_number' in request.params else 0
    patient_id = request.params['patient_id'] if 'patient_id' in request.params else 0
    physician = request.params['physician'] if 'physician' in request.params else ''
    name = request.params['name'] if 'name' in request.params else 'noname'
    examdate = request.params['examdate'] if 'examdate' in request.params else '19900101'

    k = eval(items_number)

    for i in range(k):
        value = request.params['item'+str(i+1)] if 'item' + \
            str(i+1) in request.params else 'NOVALUE'
        if value != 'NOVALUE':
            data.append(value)

    depth = [0]
    strings = [[]]
    results = ''
    last = ' '

    for s in data:
        s = s.strip()
        if s == '':
            strings[-1].append('\n')
        elif s[0] == 'p':
            strings[-1].append('\n'*len(s))
        elif s[0] == '[':
            depth.append(0)
            strings.append([])
        elif s[0] == '>' or s[0] == '=':
            strings[-1].append(s[1:])
        elif s[0] == '+' or s[0] == '-':
            if last == '+' or last == '\\':
                strings[-1][-1] = strings[-1][-1]+','
            strings[-1].append(s[1:])
            depth[-1] = 1
        elif s[0] == ']':
            if depth.pop() == 0:
                nul = strings.pop()
            else:
                depth[-1] = 1
            #else: strings[-1].append('.\n')
        elif s[0] == '\\':
            if len(s) > 1:
                strings[-1].append(s[1:])
        else:
            strings[-1].append(s)
            depth[-1] = 1
        if s != '':
            last = s[0]
        else:
            last = ' '

    results = ''
    last = ''
    for ss in strings:
        for s in ss:
            if s != '\n':
                results = results+s+' '
            else:
                results = results+'\n'

    formatted_results = results.replace('\r', '').replace(' \n', '\n').replace(
        '\n ', '\n').replace('\n', '.\n').replace('\n.', '\n')
    formatted_results = formatted_results.replace(',.', '.').replace(
        '..', '.').replace(' ,', ',').replace(':,', ':')
    formatted_results = formatted_results.replace(':.', ':').replace('"', '""')
    formatted_results = string_filter(formatted_results)

    dbRequest = request.dbsession.query(models.Patients).filter(
        models.Patients.id == patient_id)
    patient = dbRequest.one()

    fio = (patient.family + ' ' + patient.name + ' ' + patient.thirdName)
    yo = relativedelta(datetime.strptime(
        examdate, "%Y-%m-%d").date(), patient.birthdate).years

    months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа',
              'сентября', 'октября', 'ноября', 'декабря']

    data = examdate[6:8] + ' ' + \
        months[int(examdate[4:6])-1] + ' ' + examdate[0:4] + ' г.\n'
    if yo > 1:
        let = ', ' + str(yo) + ' ' + ['лет', 'год', 'года', 'года',
                                      'года', 'лет', 'лет', 'лет', 'лет', 'лет'][yo % 10]+'\n\n'
    else:
        mo = ((int(examdate)-int(patient[3]))/100+12) % 100 % 12
        if mo > 0:
            mes = str(mo % 100) + ' месяц' + ['ев', '', 'а', 'а', 'а',
                                              'ев', 'ев', 'ев', 'ев', 'ев', 'ев', 'ев'][mo % 100]
            let = ', ' + yo*'1 год и ' + mes + '\n\n'
        else:
            days = (int(examdate)-int(patient[3]))
            if days in [1, 21, 31]:
                let = ', ' + str(days) + ' день\n\n'
            elif days in [2, 3, 4, 22, 23, 24]:
                let = ', ' + str(days) + ' дня\n\n'
            else:
                let = ', ' + str(days) + ' дней\n\n'

    # cur.execute('SELECT id FROM examinations WHERE patient_id=%s AND deleted=5' % patient_id)
    # data = cur.fetchone()

    newExamination = models.Examinations(
        patientId=patient_id, name=name, examinationDate=examdate, contents=data+fio+let+formatted_results, physicianId=physician)
    request.dbsession.add(newExamination)
    request.dbsession.flush()

    # cur.execute('UPDATE examinations SET deleted=0 WHERE deleted=5')
    # con.commit()
    # con.close()

    return 'Исследование добавлено'


@view_config(route_name='printExamination', renderer='string')
def print_examination(request):
    if 'examinationId' not in request.params:
        return '{result : "error"}'

    body = '''{\\rtf1\\utf-8\\deff1\\deflang3081
{\\fonttbl{\\f0\\froman\\fprq2\\fcharset0 Liberation Serif{\\*\\falt Times New Roman};}{\\f1\\fswiss\\fprq2\\fcharset0 Arial;}{\\f2\\fswiss\\fprq2\\fcharset0 Arial;}{\\f2\\fswiss\\fprq2\\fcharset0 Liberation Sans{\\*\\falt Arial};}{\\f4\\fswiss\\fprq2\\fcharset0 DejaVu Sans;}}
{\\colortbl;\\red0\\green0\\blue0;\\red128\\green128\\blue128;}
{\\stylesheet{\\s1\\sb60\\sa60\\rtlch\\af1\\afs22\\lang255\\ltrch\\dbch\\af1\\langfe3081\\hich\\f1\\fs22\\lang3081\\loch\\f1\\fs22\\lang3081\\snext1 Normal;}
{\\s2\\sb240\\sa120\\keepn\\rtlch\\af3\\afs28\\lang255\\ltrch\\dbch\\af4\\langfe3081\\hich\\f3\\fs28\\lang3081\\loch\\f3\\fs28\\lang3081\\sbasedon1\\snext3 Heading;}}
{\\header{\\pard\\qc\\plain\\b\\f0\\fs32%(hospital)s\\par}
{\\pard\\qc\\plain\\f1\\fs20%(adres)s\\par}}
{\\footer\\pard\\qr\\plain\\f0\\u1089\\'3f\\u1090\\'3f\\u1088\\'3f\\u1072\\'3f\\u1085\\'3f\\u1080\\'3f\\u1094\\'3f\\u1072\\'3f \\chpgn\\par}
%(text)s}
'''
    paragraph = '{\\pard\\ql\\plain\\fs21 %s\\par}\n'

    exam_id = request.params['examinationId'] if 'examinationId' in request.params else 0

    if exam_id != 0:
        dbRequest = request.dbsession.query(models.Examinations).filter(
            models.Examinations.id == exam_id)
        exam = dbRequest.one()
    else:
        return 'error'
    paragraphs = []

    dbRequest = request.dbsession.query(models.Configs).filter(
        models.Configs.name == 'clinicName')
    titles = dbRequest.one()

    if titles != None:
        title = titles.value
    else:
        title = ""

    dbRequest = request.dbsession.query(models.Configs).filter(
        models.Configs.name == 'clinicAddress')
    subtitles = dbRequest.one()

    if subtitles != None:
        subtitle = subtitles.value
    else:
        subtitle = ""

    resp = Response()
    params = resp.content_type_params
    resp.content_type = 'text/rtf; charset=utf-8'
    resp.content_type_params = params
    resp.content_disposition = 'attachment; filename=report.rtf'

    header = {}
    if exam != None and exam.contents != '':
        for line in exam.contents.split('\n'):
            paragraphs.append(paragraph % rtf(line))
        header['hospital'] = rtf(title)
        header['adres'] = rtf(subtitle)
        header['text'] = ''.join(paragraphs)
        resp.text = body % header

    return resp


@view_config(route_name='printOrders', renderer='string')
def print_orders(request):
    body = '''{\\rtf1\\utf-8\\deff1\\deflang3081
{\\fonttbl{\\f0\\froman\\fprq2\\fcharset0 Liberation Serif{\\*\\falt Times New Roman};}{\\f1\\fswiss\\fprq2\\fcharset0 Arial;}{\\f2\\fswiss\\fprq2\\fcharset0 Arial;}{\\f2\\fswiss\\fprq2\\fcharset0 Liberation Sans{\\*\\falt Arial};}{\\f4\\fswiss\\fprq2\\fcharset0 DejaVu Sans;}}
{\\colortbl;\\red0\\green0\\blue0;\\red128\\green128\\blue128;}
{\\stylesheet{\\s1\\sb60\\sa60\\rtlch\\af1\\afs22\\lang255\\ltrch\\dbch\\af1\\langfe3081\\hich\\f1\\fs22\\lang3081\\loch\\f1\\fs22\\lang3081\\snext1 Normal;}
{\\s2\\sb240\\sa120\\keepn\\rtlch\\af3\\afs28\\lang255\\ltrch\\dbch\\af4\\langfe3081\\hich\\f3\\fs28\\lang3081\\loch\\f3\\fs28\\lang3081\\sbasedon1\\snext3 Heading;}}
{\\header{\\pard\\qc\\plain\\b\\f0\\fs32%(hospital)s\\par}
{\\pard\\qc\\plain\\f1\\fs20%(adres)s\\par}}
{\\footer\\pard\\qr\\plain\\f0\\u1089\\'3f\\u1090\\'3f\\u1088\\'3f\\u1072\\'3f\\u1085\\'3f\\u1080\\'3f\\u1094\\'3f\\u1072\\'3f \\chpgn\\par}
%(text)s}
'''
    paragraph = '{\\pard\\ql\\plain\\fs21\\keep %s\\par}\n'

    room = request.params['room'] if 'room' in request.params else None

    dbRequest = request.dbsession.query(models.InPatients)
    if room != None:
        dbRequest = dbRequest.filter(and_(models.InPatients.roomId == int(room)), or_(models.InPatients.discharged == None, models.InPatients.discharged == False))
    else:
        dbRequest = dbRequest.filter(or_(models.InPatients.discharged == None, models.InPatients.discharged == False))
    print(dbRequest)
    data = dbRequest.all()

    resp = Response()
    params = resp.content_type_params
    resp.content_type = 'text/rtf; charset=utf-8'
    resp.content_type_params = params
    resp.content_disposition = 'attachment; filename=report.rtf'

    paragraphs = []
    for row in data:
        fio = row.patient.family + ' ' + row.patient.name + ' ' + row.patient.thirdName
        location = row.department.name + ', ' + row.room.name
        if row.orders == None:
            orders = 'Назначения'
        else:
            orders = row.orders.replace('\n', '\\line ')
        paragraphs.append(paragraph % rtf(
            '{\\b '+fio+'}, \n{\\i'+location+' }\\line\n'+orders))
    header = {}
    header['hospital'] = rtf('Назначения')
    header['adres'] = rtf('Распечатано в: %s' % strftime(
        "%a, %d %b %Y %H:%M:%S +0000", gmtime()))
    header['text'] = '\\par '.join(paragraphs)
    resp.text = body % header

    return resp

@view_config(route_name='inPatient', renderer='json')
def get_is_in_hospital(request):
    if 'id' not in request.params:
        return "{ error : 'no id'}"

    dbRequest = request.dbsession.query(models.InPatients).filter(
        and_(models.InPatients.patientId == int(request.params['id']), or_(models.InPatients.discharged == None, models.InPatients.discharged == False)))

    print(str(dbRequest))

    result = None;
    try:
        result = dbRequest.first()
        if result == None:
            result = {}
        else:
            result = result.to_dict(max_nesting=2)
        
    except NoResultFound:
        result = {}

    return result

@view_config(route_name='inPatients', renderer='json')
def get_in_patients(request):
    pageNum = 1
    if 'page' in request.params and len(request.params['page']) > 0:
        pageNum = int(request.params['page'])

    if 'roomId' in request.params and len(request.params['roomId']) > 0:
        dbRequest = request.dbsession.query(models.InPatients).filter(and_(or_(models.InPatients.discharged == None, models.InPatients.discharged == False), models.InPatients.roomId == int(request.params['roomId'])))
    else:
        dbRequest = request.dbsession.query(models.InPatients).filter(or_(models.InPatients.discharged == None, models.InPatients.discharged == False))

    print(str(dbRequest))

    page = paginate(dbRequest, pageNum, 20)

    return dict(items=[(row.to_dict(max_nesting=2)) for row in page.items], totalItems=page.total, totalPages=page.pages, per_page=25)

@view_config(route_name='editInPatient', renderer='json')
def edit_in_patient(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""

    inPatientSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "patientId": {"type": "integer"},
            "roomId": {"type": "integer"},
            "departmentId": {"type": "integer"},
        },
        "required": ["patientId", "roomId", "departmentId"]
    }

    inPatientValidator = jsonschema.Draft4Validator(
        inPatientSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        inPatientValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in inPatientValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    print(json.loads(jsons)['id'])
    dbRequest = request.dbsession.query(models.InPatients).filter(
        models.InPatients.id == json.loads(jsons)['id'])
    dbRequest.one().update_from_json(input_data=jsons, error_on_extra_keys=False, drop_extra_keys=True)
    request.dbsession.flush()
    return '{result : "ok"}'

@view_config(route_name='addInPatient', renderer='json')
def add_in_patient(request):
    if not request.body.decode('utf-8'):
        print("t")
        return ""
    

    inPatientSchema = {
        "$schema": "http://json-schema.org/schema#",
        "type": "object",
        "properties": {
            "patientId": {"type": "integer"},
            "roomId": {"type": "integer"},
            "departmentId": {"type": "integer"},
        },
        "required": ["patientId", "roomId", "departmentId"]
    }

    inPatientValidator = jsonschema.Draft4Validator(
        inPatientSchema,
        format_checker=jsonschema.FormatChecker())

    jsons = request.body.decode('utf-8')
    try:
        inPatientValidator.validate(json.loads(jsons))
    except jsonschema.exceptions.ValidationError as e:
        errors = [e.message for e in inPatientValidator.iter_errors(jsons)]
        return {'status': 'error',
                'errors': errors,
                }
    print(str(request.body))
    newInPatient = models.InPatients.new_from_json(jsons)
    request.dbsession.add(newInPatient)
    request.dbsession.flush()
    return '{result : "ok"}'


def string_filter(s=''):
    return s.replace('"', '""').replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;').replace('\r', '')


def rtf(s=''):
    if type(s) == type(u''):
        u = s
    else:
        u = unicode(s, 'utf-8')
    rtfs = ''
    for c in u:
        if ord(c) > 128:
            rtfs = rtfs+"\\u%d\\'3f" % ord(c)
        else:
            rtfs = rtfs+c
    return str(rtfs)


class settingsDTO:
    clinicName = None
    clinicAddress = None

    def to_dict(self):
        return {'clinicNameSetting': self.clinicName.to_dict(), 'clinicAddressSetting': self.clinicAddress.to_dict()}
