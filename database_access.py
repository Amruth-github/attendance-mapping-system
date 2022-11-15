import mysql.connector
import decimal
db = mysql.connector.connect(
    host = 'localhost',
    user = 'root',
    password = '',
    database = 'attendance'
)
def process(res):
    res = list(map(lambda x: list(x), res))
    for i in range(len(res)):
        for j in range(len(res[i])):
            if type(res[i][j]) == decimal.Decimal:
                res[i][j] = float(res[i][j])
    return res
def get_total_students():
    cursor.execute('select count(*) from student')
    return cursor.fetchall()[0][0]

def get_total_teachers():
    cursor.execute('select count(*) from teacher')
    return cursor.fetchall()[0][0]

def get_all_class():
    cursor.execute(f'select Class from student group by Class')
    return cursor.fetchall()

def get_number_of_students_in_class(Class):
    cursor.execute(f'select TotalStudentsInClass("{Class}")')
    return cursor.fetchall()[0][0]

cursor = db.cursor()

def get_teacher_details(username):
    cursor.execute(f'select Name, TRN from teacher where TRN = "{username}"')
    return cursor.fetchall()

def get_student_details(username: str):
    cursor.execute(f'select * from student where SRN = "{username}"')
    return cursor.fetchall()

def get_avg_students():
    cursor.execute('select avg(Age) from student')
    return process(cursor.fetchall())[0][0]

def get_avg_teachers():
    cursor.execute('select avg(Age) from teacher')
    return process(cursor.fetchall())[0][0]

def authenticate_login(username: str, password: str, state: str):
    match state:
        case "Student": 
            cursor.execute(f'select * from login_student where User_name = "{username}" and passwd = "{password}"')
        case "Teacher":
            cursor.execute(f'select * from login_teacher where User_name = "{username}" and passwd = "{password}"')
        case "Admin":
            cursor.execute(f'select * from admin where User_name = "{username}" and passwd = "{password}"')
    res = cursor.fetchall()
    if len(res) != 0:
        return True
    return False

def course_of_student(username, doa):
    cursor.execute(f'select class from student where SRN = "{username}"')
    class_ = cursor.fetchall()[0][0]
    cursor.execute(f'select Period_one, Period_two, Period_three, Period_four, Period_five from timetable where dow = DAYNAME("{doa}") and class = "{class_}"')
    return cursor.fetchall()

def update_password(username, newPassword, state):
    cursor.execute(f'CALL UpdatePassword("{username}", "{newPassword}", "{state}")')

def get_teacher_classes(username: str, course: str):
    cursor.execute(f'select class from teaches where TRN = "{username}" and course_code = "{course}"')
    return cursor.fetchall()

def get_students_of_class(c):
    cursor.execute(f'select SRN, Name from student where Class = "{c}"')
    return cursor.fetchall()

def get_teacher_courses(username):
    cursor.execute(f'select course_code from teaches where TRN = "{username}"')
    return cursor.fetchall()

def get_class_on_day(username, date, course):
    cursor.execute(f"""select class from timetable t where dow = DAYNAME("{date}") and (Period_one = "{course}" or Period_two = "{course}" or Period_three = "{course}" or Period_four = "{course}" or Period_five = "{course}") and exists (
        select * from teaches e where course_code = "{course}" and TRN = "{username}" and t.class = e.class
    )""")
    return cursor.fetchall()

def update_attendance(rows, course, doa):
    for students in rows:
        query = f'insert into attended values ("{students["SRN"]}", "{doa}", "{course}", "P");'
        cursor.execute(query)
    db.commit()

def get_attendance_details(username, doa):
    cursor.execute(f'select course_code, status from attended where doa = "{doa}" and SRN = "{username}"')
    return cursor.fetchall()

def get_attendance_status(username, course, doa):
    cursor.execute(f'select status from attended where SRN = "{username}" and course_code = "{course}" and doa = "{doa}"')
    return cursor.fetchall()

def get_tables():
    cursor.execute('show tables')
    return cursor.fetchall()

def columns(table):
    cursor.execute(f"""
    SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '{table}'
ORDER BY ORDINAL_POSITION

    """)
    return cursor.fetchall()

def insert(table, vals):
    query = f'insert into {table} values('
    for i in range(len(vals) - 1):
        query += f'"{vals[i]}", '
    if len(vals):
        query += f'"{vals[len(vals) - 1]}")'
    cursor.execute(query)
    db.commit()

def read(table):
    cursor.execute(f'select * from {table}')
    return cursor.fetchall()

def update(table, vals, selected_row):
    cols = list(selected_row[0].keys())[1:]
    query = f'update {table} SET '
    for i in range(len(vals) - 1):
        query += f'{vals[i][0]} = "{vals[i][1]}", '
    if len(vals):
        query += f'{vals[len(vals) - 1][0]} = "{vals[len(vals) - 1][1]}" '
    query += 'where '
    d = dict(vals)
    for i in range(len(cols)):
        if cols[i] not in d.keys():
            query += f'{cols[i]} = "{selected_row[0][cols[i]]}" and '
    if len(cols):
        query += f'{cols[len(cols) - 1]} = "{selected_row[0][cols[-1]]}"'
    cursor.execute(query)
    db.commit()

def delete(table, selected_rows):
    for rows in selected_rows:
        query = f"delete from {table} where "
        conditions = list(rows.keys())[1:]
        for i in range(len(conditions) - 1):
            if rows[conditions[i]] == None:
                query += f'{conditions[i]} = NULL and '
            else:
                query += f'{conditions[i]} = "{rows[conditions[i]]}" and '
        if len(conditions):
            if rows[conditions[len(conditions) - 1]] == None:
                query += f'{conditions[len(conditions) - 1]} = NULL'
            else:
                query += f'{conditions[len(conditions) - 1]} = "{rows[conditions[len(conditions) - 1]]}"'
        print(query)
        cursor.execute(query)
        db.commit()

def get_teachers_of_students(Class):
    cursor.execute(f'select Name, course_code from teacher join teaches where teacher.TRN = teaches.TRN and teaches.Class = "{Class}"') #Join Query 1
    return cursor.fetchall()

