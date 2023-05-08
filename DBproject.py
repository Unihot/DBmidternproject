#!/usr/bin/env python3
# coding=utf-8
# -*- coding: UTF-8 -*-
from fastapi import FastAPI, Form
from fastapi.responses import HTMLResponse
import MySQLdb

app = FastAPI()


@app.get('/', response_class=HTMLResponse)
def index():
    form = """
    <form method="post" action="/selected" >
        輸入學號查詢已選課列表：<input name="my_head">
        <input type="submit" value="查詢">
    </form>
    """
    form += """
    <form method="post" action="/select" >
        輸入學號查詢可選課列表：<input name="my_head">
        <input type="submit" value="查詢">
    </form>
    """
    return form


@app.post('/selected', response_class=HTMLResponse)
def action(my_head: str = Form(default='')):
    # 建立資料庫連線
    conn = MySQLdb.connect(host="127.0.0.1",
                           user="hj",
                           passwd="test1234",
                           db="coursesystem")
    # 欲查詢的 query 指令
    query = "SELECT * FROM section where Section_id in(select Section_id from selectdetail where Student_id = '{}');".format(my_head)

    # 執行查詢
    cursor = conn.cursor()
    cursor.execute(query)

    results = """
    <p><a href="/">Back to Query Interface</a></p>
    """
    
    record = cursor.fetchall()
    # 計算已選總學分
    update = "update student set Total_credits = (select sum(credits) from course where Course_id in (select Course_id from section where Section_id in (select Section_id from selectdetail where Student_id = '{}')))where Student_id = '{}';".format(my_head ,my_head)
    cursor.execute(update)
    conn.commit()

    for result in record:
        col1 = result[0]
        col2 = result[1]
        col3 = result[2]
        col4 = result[3]
        col5 = result[4]
        col6 = result[5]
        col7 = result[6]
        col8 = result[7]
        results += "|--{}--|".format(col1)
        results += "|--{}--|".format(col2)
        results += "|--{}--|".format(col3)
        results += "|--{}--|".format(col4)
        results += "|--{}--|".format(col5)
        results += "|--{}--|".format(col6)
        results += "|--{}--|".format(col7)
        results += "|--{}--|<br>".format(col8)

    results += """<form method="post" action="/quit" >
                <input type="text" name="secid">
                <input type="text" name="stuid" value="{}">
                <input type="submit" value="退選">
            </form>
            """.format(my_head)
    
    return results

@app.post('/select', response_class=HTMLResponse)
def action(my_head: str = Form(default='')):
    conn = MySQLdb.connect(host="127.0.0.1",
                           user="hj",
                           passwd="test1234",
                           db="coursesystem")
    
    check = 1
    update = "update section set Cur_studentnum = (select count(Student_id) from selectdetail where selectdetail.Section_id = section.Section_id) order by Section_id;"
    cursor = conn.cursor()
    cursor.execute(update)
    conn.commit()

    query = "select Student_id from student"
    cursor.execute(query)
    rec = cursor.fetchall()
    for record in rec:
        id = record[0]
        if id==my_head:
            check = 0

    query = "select section.Section_id ,section.Section_name ,instructor.Department_name ,section.Year ,section.Semester ,course.Type ,section.Max_quota ,section.Cur_studentnum ,time.Day from section inner join instructor on section.Instructor_id = instructor.Instructor_id inner join time on section.Section_id = time.Section_id inner join course on section.Course_id = course.Course_id;"
    cursor.execute(query)

    results = """
    <p><a href="/">Back to Query Interface</a></p>
    """
    if check==0:
        record = cursor.fetchall()
        for result in record:
            col1 = result[0]
            col2 = result[1]
            col3 = result[2]
            col4 = result[3]
            col5 = result[4]
            col6 = result[5]
            col7 = result[6]
            col8 = result[7]
            col9 = result[8]
            results += "|--{}--||--{}--||--{}--||--{}--||--{}--||--{}--||--{}--||--{}--||--{}--|<br>".format(col1,col2,col3,col4,col5,col6,col7,col8,col9)

        results += """<form method="post" action="/add" >
                    <input type="text" name="secid">
                    <input type="text" name="stuid" value="{}">
                    <input type="submit" value="加選">
                </form>
                """.format(my_head)
    else:
        results += "不存在此學號"
        
    return results
    

@app.post('/quit', response_class=HTMLResponse)
def action(secid : str = Form(default ='') ,stuid : str = Form(default = '') ):
    conn = MySQLdb.connect(host="127.0.0.1",
                           user="hj",
                           passwd="test1234",
                           db="coursesystem")
    
    # select Type from course where Course_id = (select Course_id from section where Section_id = "1261")
    query = "select Credits , Type from course where Course_id = (select Course_id from section where Section_id = '{}')".format(secid)
    cursor = conn.cursor()
    cursor.execute(query)
    output = cursor.fetchall()

    for outcome in output:
        credits = int(outcome[0])
        type = outcome[1]
    

    query = "select Total_credits from student where Student_id = '{}'".format(stuid)
    cursor.execute(query)
    total = cursor.fetchall()
    for totalcre in total:
        totalcredit = int(totalcre[0])

    results = """
    <p><a href="/">Back to Query Interface</a></p>
    """

    if type == "Elective" and (totalcredit - credits) >= 9 :
        delete = "delete from selectdetail where Student_id = '{}' and Section_id = '{}'".format(stuid ,secid)
        cursor.execute(delete)
        conn.commit()
        update = "update student set Total_credits = (select sum(credits) from course where Course_id in (select Course_id from section where Section_id in (select Section_id from selectdetail where Student_id = '{}')))where Student_id = '{}';".format(stuid ,stuid)
        cursor.execute(update)
        conn.commit()
        results += "{}".format("quit succesfully")
    else:
        if type == "Required":
            results += "無法退選必修課"
        elif (totalcredit - credits) <= 9:
            results += "無法退選，退選後學分小於9學分"

    return results

@app.post('/add', response_class=HTMLResponse)
def action(secid : str = Form(default ='') ,stuid : str = Form(default = '') ):
    conn = MySQLdb.connect(host="127.0.0.1",
                           user="hj",
                           passwd="test1234",
                           db="coursesystem")
    
    check = 0
    typecheck = 0

    query = "select Course_id from section where Section_id = '{}';".format(secid)
    cursor = conn.cursor()
    cursor.execute(query)

    rec = cursor.fetchall()
    for record in rec:
        selectcourseid = record[0]
    
    query = "select Cur_studentnum from section where Section_id = '{}';".format(secid)
    cursor.execute(query)
    
    rec = cursor.fetchall()
    for record in rec:
        curstudentnum = int(record[0])
    
    query = "select Max_quota from section where Section_id = '{}';".format(secid)
    cursor.execute(query)
    
    rec = cursor.fetchall()
    for record in rec:
        maxquota = int(record[0])
    
    query = "select Total_credits from student where Student_id = '{}';".format(stuid)
    cursor.execute(query)

    rec = cursor.fetchall()
    for record in rec:
        totalcredits = int(record[0])
    
    query = "select Credits from course where Course_id = (select Course_id from section where Section_id = '{}');".format(secid)
    cursor.execute(query)

    rec = cursor.fetchall()
    for record in rec:
        credits = int(record[0])
    
    query = "select Time_type from time where Section_id = '{}';".format(secid)
    cursor.execute(query)

    rec = cursor.fetchall()
    for record in rec:
        selecttype = int(record[0])
    
    query = "select Course_id from section where Section_id in (select Section_id from selectdetail where Student_id = '{}');".format(stuid)
    cursor.execute(query)

    rec = cursor.fetchall()
    for record in rec:
        courseid = record[0]
        if courseid==selectcourseid:
            check = 1
    
    query = "select Time_type from time where Section_id in (select Section_id from selectdetail where Student_id = '{}');".format(stuid)
    cursor.execute(query)

    rec = cursor.fetchall()
    for record in rec:
        type = record[0]
        if selecttype==type:
            typecheck = 1


# select Time_type from time where Section_id = "1260";
    results = """
    <p><a href="/">Back to Query Interface</a></p>
    """
    if curstudentnum<=maxquota and (totalcredits+credits)<=30:
        if check==0 and typecheck==0:
            add = "insert into selectdetail(Student_id ,Section_id) value ('{}' ,'{}');".format(stuid ,secid)
            cursor.execute(add)
            conn.commit()
            update = "update student set Total_credits = (select sum(credits) from course where Course_id in (select Course_id from section where Section_id in (select Section_id from selectdetail where Student_id = '{}')))where Student_id = '{}';".format(stuid ,stuid)
            cursor.execute(update)
            conn.commit()
            results += "add succesfully"
        else:
            if curstudentnum>=maxquota:
                results += "人數已滿"
            elif check==1:
                results +="已有同名課程"
            elif (totalcredits+credits)>=30:
                results += "學分超過30"
            elif typecheck==1:
                results +="該時段有衝堂"
    else:
        if curstudentnum>=maxquota:
            results += "人數已滿"
        elif check==1:
            results +="已有同名課程"
        elif (totalcredits+credits)>=30:
            results += "學分超過30"
        elif typecheck==1:
            results +="該時段有衝堂"
    
    return results