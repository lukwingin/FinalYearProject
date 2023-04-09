import os
import csv
from flask import Flask, render_template, request, session, redirect, url_for, send_file
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user, login_required, logout_user, current_user
from collections import defaultdict
from sqlalchemy import and_
from datetime import datetime
from exts import init_databases, db, login_manager
from models import User, Course, CourseSession, Enrollment, Attendance
import config


app = Flask(__name__)
app.config.from_object(config)
init_databases(app)
login_manager.session_protection = "strong"
login_manager.login_view = "login"


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(user_id)


@app.route('/')
@login_required
def index():
    if current_user.user_type == "0":
        return redirect(url_for("admin_index"))
    if current_user.user_type == "1":
        return redirect(url_for("instructor_index"))
    if current_user.user_type == "2":
        return redirect(url_for("student_index"))


@app.route("/admin", methods=["GET", "POST"])
@login_required
def admin_index():
    if request.method == "GET":
        return render_template("admin.html")
    name = request.form.get("name")
    username = request.form.get("username")
    password = request.form.get("password")
    user_type = request.form.get("user_type")
    temp_user = User.query.filter(User.username == username).one_or_none()
    if temp_user:
        return {"code": -1, "msg": f"User '{username}' already exists!"}
    new_user = User(name, username, generate_password_hash(password), user_type)
    try:
        db.session.add(new_user)
        db.session.commit()
    except Exception as exp:
        return {"code": -1, "msg": f"Create enrollment failed.{exp}"}
    return {"code": 0, "msg": "Create user successful."}


@app.route("/instructor")
@login_required
def instructor_index():
    students = []
    attendances = defaultdict(list)
    state = {
        "0": "on time",
        "1": "late",
        "2": "absent"
    }

    stu_obj = User.query.filter(User.user_type == "2").all()
    attendance_obj = Attendance.query.all()
    for stu in stu_obj:
        students.append({"uid": stu.id, "username": stu.name, "create_at": stu.create_at})

    courses = []
    course_obj = Course.query.filter(Course.teacher_id == current_user.id).all()
    if course_obj:
        for course in course_obj:
            attendances[course.name] = []
            courses.append({"id": course.id, "name": course.name})

    for att in attendance_obj:
        c_name = Course.query.filter(Course.id == (CourseSession.query.filter(CourseSession.id == att.cs_id)).one_or_none().cid).one_or_none().name
        if c_name not in attendances.keys():
            continue
        attendances[c_name].append({
            "id": att.id,
            "u_name": User.query.filter(User.id == att.stu_id).one_or_none().name,
            "arr_time": att.att_at,
            "state": state[att.att_status]
        })
    return render_template("instructor.html", students=students, attendances=attendances, courses=courses)


@app.route("/student")
@login_required
def student_index():
    courses = []
    course_id_name = {}
    attendance_info = dict()
    state = {"0": "on time", "1": "late", "2": "absent"}

    cid_s = Enrollment.query.filter(Enrollment.stu_id == current_user.id).all()
    for cid in cid_s:
        t_id = Course.query.filter(Course.id == cid.cid).one_or_none()
        t_name = User.query.filter(User.id == t_id.teacher_id).one_or_none()
        courses.append({"c_name": t_id.name, "t_name": t_name.name})
        course_id_name[t_id.id] = t_id.name

    for cid in course_id_name.keys():
        attendance_info[course_id_name[cid]] = []
        cs_ids = CourseSession.query.filter(CourseSession.cid == cid).all()
        if cs_ids: 
            for cs_id in cs_ids:
                att_ids = Attendance.query.filter(Attendance.cs_id == cs_id.id).all()
                for att_id in att_ids:
                    attendance_info[course_id_name[cid]].append({"arr_time": att_id.att_at,
                                                                 "state": state[att_id.att_status]})
    return render_template("student.html", courses=courses, attendance_info=attendance_info)


@app.route("/add_course", methods=["POST"])
@login_required
def add_course():
    c_name = request.form.get("c_name")
    stu_list = request.form.getlist("stu_list[]")

    if None in (c_name, stu_list):
        return {"code": -1, "msg": "Data err."}

    new_course = Course(c_name, current_user.id)
    try:
        db.session.add(new_course)
        db.session.commit()
        c_id = new_course.id
        for stu_id in stu_list:
            new_enrollment = Enrollment(c_id, int(stu_id))
            try:
                db.session.add(new_enrollment)
                db.session.commit()
            except Exception as exp:
                print(exp)
                return {"code": -1, "msg": "Create enrollment failed."}
        usernames = []
        for stu_id in stu_list:
            usernames.append(User.query.filter(User.id == stu_id).one().name)
        return {"code": 0, "data": usernames}
    except Exception as exp:
        print(exp)
        return {"code": -1, "msg": "Create course failed, Course is existed!"}


@app.route("/update", methods=["GET", "POST"])
@login_required
def update():
    if request.method == "GET":
        att_id = int(request.args.get("id"))
        if not att_id:
            return redirect(url_for("instructor_index"))
        att = Attendance.query.filter(Attendance.id == att_id).one()
        data = {
            "arr_id": att.id,
            "arr_state": att.att_status
        }
        return render_template("update.html", data=data)
    new_id = int(request.form.get("arr_id"))
    new_state = request.form.get("arr_state")
    Attendance.query.filter(Attendance.id == new_id).update({"att_status": new_state})
    db.session.commit()
    return redirect(url_for("instructor_index"))


@app.route("/att_info", methods=["POST"])
def att_info():
    try:
        cid = int(request.form.get("cid"))
        c_name = Course.query.filter(Course.id == cid).one().name
        cs_objs = CourseSession.query.filter(CourseSession.cid == cid).all()
        stu_att_info = defaultdict(int)
        for cs_obj in cs_objs:
            att_objs = Attendance.query.filter(Attendance.cs_id == cs_obj.id).all()
            for att_obj in att_objs:
                stu_name = User.query.filter(User.id == att_obj.stu_id).one().name
                stu_att_info[stu_name] += 1
        res = {
            "names": list(stu_att_info.keys()),
            "att_times": list(stu_att_info.values()),
            "c_name": c_name
        }
        return {"code": 0, "res": res, "msg": ""}
    except Exception as exp:
        return {"code": -1, "msg": f"{exp}"}


@app.route("/export", methods=["POST"])
def export():
    course_name = request.form.get("c_name")
    print(course_name)
    if not course_name:
        return {"code": -1, "msg": "no course name"}
    course_name = course_name.strip()
    course_obj = Course.query.filter(Course.name == course_name).one_or_none()
    if not course_obj:
        return {"code": -1, "msg": "Course is not exists!"}
    cs_objs = CourseSession.query.filter(CourseSession.cid == course_obj.id).all()
    if not cs_objs:
        return {"code": -1, "msg": "Course Session is not exists!"}
    state = {"0": "on time", "1": "late", "2": "absent"}
    if os.path.exists("data.csv"):
        try:
            os.remove("data.csv")
        except Exception as exp:
            return {"code": -1, "msg": f"{exp}"}
    field_names = ['SessionID', 'StudentName', 'AttendanceTime', 'AttendanceStatus']
    with open("data.csv", mode="w", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=field_names)
        writer.writeheader()
        for cs_obj in cs_objs:
            att_objs = Attendance.query.filter(Attendance.cs_id == cs_obj.id).all()
            for att_obj in att_objs:
                writer.writerow({
                    "SessionID": cs_obj.id,
                    "StudentName": User.query.filter(User.id == att_obj.stu_id).one().name,
                    "AttendanceTime": att_obj.att_at,
                    "AttendanceStatus": state[att_obj.att_status]
                })
    return send_file("data.csv", as_attachment=True)


@app.route("/create_att_record", methods=["POST"])
def create_attendance():
    try:
        stu_id = int(request.form.get("student_id"))
        cs_id = int(request.form.get("session_id"))
        att_at = datetime.strptime(request.form.get("att_at"), "%Y-%m-%d %H:%M:%S")
    except Exception as exp:
        return {"code": -1, "msg": f"{exp}"}

    if None in (stu_id, cs_id, att_at,):
        return {"code": -1, "msg": "All parameters must be filled in！"}
    stu_object = User.query.filter(User.id == stu_id).one_or_none()
    cs_object = CourseSession.query.filter(CourseSession.id == cs_id).one_or_none()
    if not stu_object:
        return {"code": -1, "msg": f"Student of id={stu_id} is not exists!"}
    if not cs_object:
        return {"code": -1, "msg": f"Session of id={cs_id} is not exists!"}
    stu_att_object = Attendance.query.filter(and_(Attendance.stu_id == stu_id, Attendance.cs_id == cs_id)).one_or_none()
    if stu_att_object:
        return {"code": -1, "msg": f"Attendance of student_id={stu_id} is already exists!"}

    stu_courses = [course.cid for course in Enrollment.query.filter(Enrollment.stu_id == stu_id).all()]
    if cs_object.cid not in stu_courses:
        return {"code": -1, "msg": f"The student did not choose this course!"}

    status = "0"
    if cs_object.begin_at < att_at < cs_object.end_at:
        status = "1"
    if att_at > cs_object.end_at:
        status = "2"
    try:
        new_att = Attendance(cs_id, stu_id, att_at, status)
        db.session.add(new_att)
        db.session.commit()
    except Exception as exp:
        return {"code": -1, "msg": f"{exp}"}
    return {"code": 0, "msg": "Create attendance record successfully!"}


@app.route('/login', methods=["GET", "POST"])
def login():
    if request.method == "GET":
        return render_template("login.html")
    elif request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        user = User.query.filter(User.username == username).first()
        if not user:
            return {"code": -1, "msg": "User name or password error!"}
        if check_password_hash(user.password, password):
            login_user(user)
            session.permanent = True
            return {"code": 0, "msg": ""}
        return {"code": -1, "msg": "User name or password error!"}


@app.route("/logout")
def logout():
    logout_user()
    return redirect("/login")


if __name__ == '__main__':
    app.run()
