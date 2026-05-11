create database rutinas_ejercicios;

use rutinas_ejercicios;

create table usuarios(
idUsu varchar(20) not null,
nombreUsu varchar(30) not null,
correoUsu varchar(30) not null,
contrasenha varchar(100) not null,
sexo char not null,
altura_cm int not null,
peso int not null,
objetivo_entreno varchar(30) not null,
constraint idUsu_PK primary key (idUsu),
constraint sexo_CK check (sexo in ('M', 'F'))
);

create table modalidad_entreno(
idUsu varchar(20) not null,
modalidad varchar(20) not null,
constraint idUsu_PK primary key (idUsu),
constraint usuario_modalidad_FK foreign key (idUsu) references usuarios(idUsu)
);

create table entrenos(
idEntreno varchar(20) not null,
fecha_entreno datetime not null,
idUsu varchar(20) not null,
nombre_entreno varchar(30),
notas text,
constraint idEntreno_PK primary key (idEntreno),
constraint entrenos_usuarios_FK foreign key (idUsu) references usuarios(idUsu)
);

create table medida_corporal(
id_med varchar(20) not null,
idUsu varchar(20) not null,
fecha date not null,
peso_kg double,
cintura_cm double,
cadera_cm double,
pecho_cm double,
brazo_cm double,
muslo_cm double,
es_meta bool,
constraint id_med_PK primary key (id_med),
constraint medida_usuario_FK foreign key (idUsu) references usuarios(idUsu)
);

create table ejercicios(
idEjercicio varchar(20) not null,
nombreEj varchar(30) not null,
tipo varchar(20) not null,
constraint idEjercicio_PK primary key (idEjercicio)
);

create table entreno_ejercicio(
idEntEj varchar(20) not null,
idEntreno varchar(20) not null,
idEjercicio varchar(20) not null,
series int not null,
repeticiones int not null,
peso_kg double not null,
orden int not null,
constraint idEntEj_PK primary key (idEntEj),
constraint entreno_ejercicio_FK foreign key (idEntreno) references entrenos(idEntreno),
constraint ejercicio_entreno_FK foreign key (idEjercicio) references ejercicios(idEjercicio)
);

create table musculos(
idMusculo varchar(20) not null,
nombreMusc varchar(30) not null,
grupo_muscular varchar(20) not null,
constraint idMusculo_PK primary key (idMusculo)
);

create table ejercicio_musculo(
idEjercicio varchar(20) not null,
idMusculo varchar(20) not null,
rol int not null,
constraint PK_IdEjMus primary key (idEjercicio, idMusculo),
constraint ejerMusc_FK foreign key (idEjercicio) references ejercicios(idEjercicio),
constraint MuscEjer_FK foreign key (idMusculo) references musculos(idMusculo)
);