from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer

from pydantic import BaseModel, EmailStr
from jose import jwt, JWTError
from passlib.context import CryptContext

import pymysql
import pymysql.cursors

from datetime import datetime, timedelta, timezone
from typing import Any
import os
from dotenv import load_dotenv

from exercise_service import (
    get_exercises_by_body_part,
    get_all_body_parts,
    search_exercises_by_name,
    get_exercises_by_equipment
)

load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY", "clave_de_desarrollo_cambiar_en_produccion")
ALGORITHM = "HS256"
TOKEN_EXPIRA_EN_MINUTOS = 60

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_db_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='',  
        database='rutinas_ejercicios',
        cursorclass=pymysql.cursors.DictCursor
    )

class UserDataRegister(BaseModel):
    idUsu: str
    nombreUsu: str
    correoUsu: EmailStr
    contrasenha: str
    sexo: str
    altura_cm: int
    peso: int
    objetivo_entreno: str

class UserDataLogin(BaseModel):
    nombreUsu: str
    contrasenha: str

class UsuarioActual(BaseModel):
    idUsu: str
    nombreUsu: str
    correoUsu: str

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def crear_token_acceso(datos: dict) -> str:
    payload = datos.copy()
    expiracion = datetime.now(timezone.utc) + timedelta(minutes=TOKEN_EXPIRA_EN_MINUTOS)
    payload.update({"exp": expiracion})
    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token

def get_usuario_actual(token: str = Depends(oauth2_scheme)) -> UsuarioActual:

    error_credenciales = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Credenciales invalidas o token expirado",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        id_usu: str = payload.get("sub")
        if id_usu is None:
            raise error_credenciales
    except JWTError:
        raise error_credenciales

    
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT idUsu, nombreUsu, correoUsu FROM usuarios WHERE idUsu = %s",
                (id_usu,)
            )
            fila = cursor.fetchone()
    finally:
        connection.close()

    if fila is None:
        raise error_credenciales

    return UsuarioActual(**fila)

app = FastAPI(title="LiftMove API", version="1.0.0") 
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"message": "API funcionando correctamente"}


@app.get("/me", response_model=UsuarioActual)
def quien_soy(usuario: UsuarioActual = Depends(get_usuario_actual)):

    return usuario

@app.post("/register")
def register(data: UserDataRegister) -> Any:
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM usuarios WHERE idUsu = %s", (data.idUsu,))
            if cursor.fetchone():
                raise HTTPException(status_code=400, detail="El id del usuario ya existe")

            cursor.execute("SELECT * FROM usuarios WHERE nombreUsu = %s", (data.nombreUsu,))
            if cursor.fetchone():
                raise HTTPException(status_code=400, detail="El nombre de usuario ya existe")

            cursor.execute("SELECT * FROM usuarios WHERE correoUsu = %s", (data.correoUsu,))
            if cursor.fetchone():
                raise HTTPException(status_code=400, detail="El correo ya está registrado")

            if data.sexo not in ["M", "F"]:
                raise HTTPException(status_code=400, detail="El sexo debe ser 'M' o 'F'")

            
            hashed_password = get_password_hash(data.contrasenha)

            sql = """
                INSERT INTO usuarios
                (idUsu, nombreUsu, correoUsu, contrasenha, sexo, altura_cm, peso, objetivo_entreno)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(sql, (
                data.idUsu,
                data.nombreUsu,
                data.correoUsu,
                hashed_password,
                data.sexo,
                data.altura_cm,
                data.peso,
                data.objetivo_entreno
            ))
            connection.commit()

            return {"success": True, "message": "Usuario creado exitosamente"}
    finally:
        connection.close()

@app.post("/login")
def login(data: UserDataLogin) -> Any:
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT * FROM usuarios WHERE nombreUsu = %s",
                (data.nombreUsu,)
            )
            user = cursor.fetchone()

            
            if not user or not verify_password(data.contrasenha, user['contrasenha']):
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Credenciales incorrectas"
                )

            
            token = crear_token_acceso({
                "sub": user["idUsu"],
                "nombreUsu": user["nombreUsu"],
            })

            return {
                "success": True,
                "message": "Autenticacion exitosa",
                "access_token": token,
                "token_type": "bearer",
                "nombreUsu": user["nombreUsu"],
            }
    finally:
        connection.close()

@app.get("/exercises/bodyparts")
def body_parts():
    return get_all_body_parts()

@app.get("/exercises/bodypart/{body_part}")
def exercises_by_body_part(body_part: str):
    return get_exercises_by_body_part(body_part)

@app.get("/exercises/search/{name}")
def search_exercises(name: str):
    return search_exercises_by_name(name)

@app.get("/exercises/equipment/{equipment}")
def exercises_by_equipment(equipment: str):
    return get_exercises_by_equipment(equipment)