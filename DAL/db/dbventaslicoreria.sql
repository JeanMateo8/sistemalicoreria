create database VENTAS_LICORERIA
go

use  VENTAS_LICORERIA
go

--CREACIÓN DE LA TABLA PERSONAS
create table Personas
(
	idpersona		int identity(1,1)	primary key,
	apellidos		varchar(30)			not null,
	nombres			varchar(30)			not null,	
	DNI				char(8)		        not null,
	telefono		char(9)				not null,
	fechaRegistro	datetime			null default getdate(),
	estado			bit					null default 1,
	CONSTRAINT ck_DNI CHECK( DNI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT uk_DNI UNIQUE (DNI)
)
go


--CREACIÓN DE LA TABLA EMPLEADOS
create table Empleados
(
	idempleado		int identity(1,1)	primary key,
	idpersona		int					not null, --FK
	nombreusuario	varchar(50)			not null,
	claveacceso		varchar(90)			not null,
	fechaRegistro	datetime			null default getdate(),
	estado			bit					null default 1,
	constraint fk_idpersona_empleados foreign key (idpersona) references Personas (idpersona),
	CONSTRAINT uk_nombreUsuario UNIQUE (nombreusuario),
	CONSTRAINT uk_idpersona UNIQUE (idpersona)
)
go

--CREACIÓN DE TABLA PROVEEDORES
CREATE TABLE Proveedores
(
	idproveedor		INT IDENTITY(1,1) PRIMARY KEY,
	nombreprov		VARCHAR(50)		NOT NULL,
	direccion		VARCHAR(50)		NOT NULL,
	RUC				CHAR(11)		NOT NULL,
	telefono		CHAR(9)			NOT NULL,
	fechaRegistro	datetime		null default getdate(),
	estado			bit				null default 1,
	CONSTRAINT uk_Ruc UNIQUE (RUC),
	CONSTRAINT ck1_telefono CHECK (telefono like '[9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT ck_RUC CHECK (RUC LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)
GO

--CREACIÓN DE LA TABLA CATEGORIAS
CREATE TABLE Categorias
(
	idCategoria			INT IDENTITY(1,1) PRIMARY KEY,
	nombreCategoria		VARCHAR(50)			NOT NULL,
	fechaRegistro		datetime			null default getdate(),
	estado				bit					null default 1,
	CONSTRAINT uk_nombrecategoria UNIQUE (nombreCategoria)
)
GO

--CREACIÓN DE LA TABLA MARCAS
CREATE TABLE Marcas
(
	idMarca			INT IDENTITY(1,1) PRIMARY KEY,
	nombreMarca		VARCHAR(50)		NOT NULL,
	fechaRegistro	datetime		null default getdate(),
	estado			bit				null default 1,
	CONSTRAINT uk_nombreMarca UNIQUE (nombreMarca)
)
GO


-- CREACIÓN DE LA TABLA PRODUCTOS
CREATE TABLE Productos
(
	idproducto			INT IDENTITY(1,1) PRIMARY KEY,
	imagen				varbinary(max) NULL,
	idmarca				INT			 NOT NULL,
	idcategoria			INT			 NOT NULL,
	nombreproducto		VARCHAR(50)	 NOT NULL,
	descripcion			VARCHAR(100) NOT NULL,
	preciocompra		decimal(7,2) NOT NULL,
	precioVenta			DECIMAL(7,2) NOT NULL,
	stock				smallint	 NOT NULL,
	caducidad			DATE		 NOT NULL,
	fechaRegistro		datetime			null default getdate(),
	estado			bit					not null default 1,
	CONSTRAINT R1_idmarca FOREIGN KEY (idmarca) REFERENCES marcas(idmarca),
	CONSTRAINT R2_idcategoria FOREIGN KEY (idcategoria) REFERENCES categorias(idcategoria),
	CONSTRAINT R4_preciocompra CHECK (preciocompra > 0),
	CONSTRAINT R6_precioventa CHECK (precioventa > 0),
	CONSTRAINT Re_stock CHECK (stock > 0)
)
GO

--CREACIÓN DE TABLA COMPRAS
CREATE TABLE Compras 
(
	idcompra		INT IDENTITY(1,1) PRIMARY KEY,
	idempleado		int		not null,
	idproveedor		INT		NOT NULL,
	tipocomprobante	varchar (50) not null,
	numcomprobante	varchar(7)	not null,
	montototal		decimal(7,2) not null,
	fechaRegistro	datetime	null default getdate(),
	CONSTRAINT R6_idproveedor FOREIGN KEY (idproveedor) REFERENCES Proveedores(idproveedor)
)
GO



--CREACIÓN DE TABLA DETALLECOMPRA
CREATE TABLE detalleCompras
(
	iddetallecompra		INT IDENTITY(1,1) PRIMARY KEY,
	idcompra			INT			 NOT NULL,
	idproducto			INT			 NOT NULL,
	preciocompra		decimal(7,2) NOT NULL,
	precioVenta			DECIMAL(7,2) NOT NULL,
	cantidad			int			 NOT NULL,
	montototal			DECIMAL(7,2) NOT NULL,
	fechaRegistro		datetime	 null default getdate(),
	CONSTRAINT r6_idcompra FOREIGN KEY (idcompra)	REFERENCES compras(idcompra),
	CONSTRAINT R7_idproducto FOREIGN KEY (idproducto) REFERENCES productos(idproducto),
	CONSTRAINT R8_cantidad CHECK (cantidad > 0),
	CONSTRAINT R9_preciocompra CHECK (precioCompra > 0)
)
GO

--CREACIÓN DE LA TABLA MEDIOSPAGOS
create table MediosPagos
(
	idmediopago		int identity(1,1) primary key,
	mediopago		varchar(30)		not null,
	CONSTRAINT uk_mediopago UNIQUE (mediopago)
)
go


--CREACIÓN DE LA TABLA SEDES
create table Sedes
(
	idsede		int identity(1,1) primary key,
	ciudad		varchar(30)		not null,
	direccion	varchar(30)		not null,
	telefono	char(9)			not null,
	CONSTRAINT ck_telefono CHECK (telefono like '[9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)
go


--CREACIÓN DE LA TABLA VENTAS
CREATE table Ventas 
(
	idventa			int identity(1,1) primary key,
	idsede			int			not null, --FK
	idempleado		int			not null,  --FK
	tipocomprovante	varchar(30)	not null,
	numcomprovante	varchar(7)	not null,
	idcliente		int			not null, --FK
	idmediopago		int			not null, --FK
	montopago		decimal(7,2)not null,
	montocambio		decimal(7,2)not null,
	montototal		decimal(7,2)not null,
	fechaRegistro	datetime	null default getdate(),
	constraint fk_idmediopago_ventas foreign key (idmediopago) references MediosPagos (idmediopago),
	constraint fk_idsede_ventas foreign key (idsede) references Sedes (idsede),
	constraint fk_idcliente_ventas foreign key (idcliente) references Personas (idpersona),
	constraint fk_idempleado_ventas foreign key (idempleado) references Empleados (idempleado),
	constraint ck_tipocomprovante check (tipocomprovante in ('Boleta', 'Factura')),
	CONSTRAINT ck_numcomprovante CHECK (numcomprovante like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT uk_numcomprovante UNIQUE (numcomprovante)
)
go


--CREACIÓN DE LA TABLA DETALLEVENTA
create table DetalleVentas
(
	iddetalleventa		int identity(1,1) primary key,
	idventa				int				not null,
	idproducto			int				not null,
	precioventa			decimal(7,2)	not null,
	cantidad			int				not null,
	subtotal			decimal(7,2)	null,
	fechaRegistro		datetime		null default getdate(),
	constraint fk_idventa_ventas foreign key(idventa) references ventas(idventa),
	constraint fk_idproductos_detalleven foreign key (idproducto) references Productos (idproducto),
	CONSTRAINT R5_precioventa CHECK (precioventa > 0),
	CONSTRAINT ck_cantidad CHECK (cantidad > 0)
)
go
