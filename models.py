from exts import db
from datetime import datetime


class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_type = db.Column(db.Enum("0", "1", "2"), server_default="2", nullable=False)
    name = db.Column(db.String(20), unique=True, nullable=False)
    username = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(300), nullable=False)
    create_at = db.Column(db.DateTime, default=datetime.now, nullable=False)

    def __init__(self, name: str, username: str, password: str, user_type: str):
        self.name = name
        self.username = username
        self.password = password
        self.user_type = user_type

    @property
    def is_active(self):
        return True

    @property
    def is_authenticated(self):
        return True

    def get_id(self):
        return str(self.id)


class Course(db.Model):
    __tablename__ = "course"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(20), unique=True, nullable=False)
    teacher_id = db.Column(db.Integer, nullable=False)

    def __init__(self, name: str, teacher_id: int):
        self.name = name
        self.teacher_id = teacher_id


class CourseSession(db.Model):
    __tablename__ = "course_session"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    cid = db.Column(db.Integer, nullable=False)
    begin_at = db.Column(db.DateTime, nullable=False)
    end_at = db.Column(db.DateTime, nullable=False)


class Enrollment(db.Model):
    __tablename__ = "enrollment"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    cid = db.Column(db.Integer, nullable=False)
    stu_id = db.Column(db.Integer, nullable=False)

    def __init__(self, cid: int, stu_id: int):
        self.cid = cid
        self.stu_id = stu_id


class Attendance(db.Model):
    __tablename__ = "attendance"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    cs_id = db.Column(db.Integer, nullable=False)
    stu_id = db.Column(db.Integer, nullable=False)
    att_at = db.Column(db.DateTime, nullable=False)
    att_status = db.Column(db.Enum("0", "1", "2"), server_default="0", nullable=False)

    def __init__(self, cs_id: int, stu_id: int, att_at: datetime, att_status: str):
        self.cs_id = cs_id
        self.stu_id = stu_id
        self.att_at = att_at
        self.att_status = att_status
