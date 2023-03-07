/* ---------- PROCEDIMIENTOS PARA PERSONAS -----------------*/
use VENTAS_LICORERIA
go


create PROC spu_registrar_persona
--PARAMETROS DE ENTRAS
	@apellidos		varchar(30),
	@nombres		varchar(30),
	@dni			char(8),
	@Telefono		char(9),
	@Estado bit,
--PARAMETROS DE SALIDAS
	@Resultado int output,
	@Mensaje varchar(500) output
as begin
	set @Resultado = 0
	declare @idpersona int
	if not exists (select * from Personas where DNI = @dni)
	begin
		insert into Personas(apellidos,nombres,DNI, telefono,estado) values 
							(@apellidos,@nombres,@dni,@Telefono,@Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'Error! el DNI ya existe'
end
go


create proc spu_editar_persona
	@idpersona		int,
	@apellidos		varchar(30),
	@nombres		varchar(30),
	@dni			char(8),
	@telefono		char(9),
	@estado			bit,

	@Resultado bit output,
	@Mensaje varchar(500) output
as begin
	set @Resultado = 1
	declare @IDCLIENTE int
	if not exists (select * from Personas where DNI = @dni and idpersona != @idpersona)
	begin
		update Personas set
			apellidos = @apellidos,
			nombres = @nombres,
			DNI = @dni,
			telefono = @telefono,
			estado = @estado
			where idpersona = @idpersona
		end
		else 
		begin
			set @Resultado = 1
			set @Mensaje = 'El dni ya existe'
		end
end
go


/* ---------- PROCEDIMIENTOS PARA EMPLEADOS -----------------*/

create PROC spu_registrar_empleado
--PARAMETROS DE ENTRAS
	@idpersona		int,
	@nombreusuario	varchar(50),
	@claveacceso	varchar(90),
	@Estado bit,
--PARAMETROS DE SALIDAS
	@Resultado int output,
	@Mensaje varchar(500) output
as begin
	set @Resultado = 0
	set @Mensaje = ''
	if not exists (select * from Empleados where idpersona = @idpersona)
	begin
		insert into Empleados	(idpersona,nombreusuario,claveacceso,estado) values 
								(@idpersona,@nombreusuario,@claveacceso,@Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'Error! nose puede agregar a la persona ya existe'
end
go


create proc spu_editar_empleado
	@idpersona		int,
	@idempleado		int,
	@claveacceso	varchar(90),
	@estado			bit,
	@Respuesta bit output,
	@Mensaje varchar(500) output
as begin
	set @Respuesta = 0
	set @Mensaje = ''
	if not exists (select * from Empleados where idpersona = @idpersona and idempleado != @idempleado)
	begin
		update Empleados set
			idpersona = @idpersona,
			claveacceso = @claveacceso,
			estado = @estado
			where idempleado = @idempleado
		end
		else 
		begin
			set @Respuesta = 1
			set @Mensaje = 'Error! nose puede agregar a la persona ya existe'
		end
end
go


create proc spu_eliminar_empleado
	@idempleado		int,
	@respuesta		bit output,
	@mensaje		varchar(500) output

as begin
	set @respuesta = 0
	set @mensaje =''
	declare @pasoreglas bit = 1

	if exists (select * from Compras c
	inner join Empleados E on E.idempleado = c.idempleado
	WHERE E.idempleado = @idempleado
	)
	begin
		set @pasoreglas = 0
		set @respuesta = 0
		set @mensaje = @mensaje + 'No se puede eliminar porque el empleado se encuentra relacionado a una compra\n'
	end

	if exists (select * from Ventas V
	inner join Empleados E on E.idempleado = V.idempleado
	where E.idempleado = @idempleado
	)
	begin
		set @pasoreglas = 0
		set @respuesta = 0
		set @mensaje = @mensaje + 'No se puede eliminar porque el empleado se encuentra relacionado a una compra\n'

	end

	if(@pasoreglas = 1)
	begin
		delete from Empleados where idempleado = @idempleado
		set @respuesta =1
	end
end


/* ---------- PROCEDIMIENTOS PARA CATEGORIA -----------------*/


create proc spu_registrar_categoria
	@nombrecategoria	varchar(50),
	@Estado				bit,
	@Resultado int output,
	@Mensaje varchar(500) output
	
as begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM Categorias where nombreCategoria = @nombrecategoria)
	begin
		insert into Categorias(nombreCategoria,Estado) values (@nombrecategoria,@Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	ELSE
		set @Mensaje = 'No se puede repetir el nombre de una categoria'
	
end
go


create proc spu_editar_categoria

	@idcategoria		int,
	@nombrecategoria	varchar(50),
	@estado				bit,

	@Resultado bit output,
	@Mensaje varchar(500) output

as begin
	set @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Categorias where nombreCategoria =@nombrecategoria and idCategoria != @idcategoria)
		update Categorias set
		nombreCategoria = @nombrecategoria,
		estado = @estado
		where idCategoria = @idcategoria
	ELSE
	begin
		SET @Resultado = 0
		set @Mensaje = 'No se puede repetir el nombre de una categoria'
	end
end

create proc spu_eliminar_categoria
	@idcategoria		int,
	@estado				bit,
	@Resultado bit output,
	@Mensaje varchar(500) output
as begin
	set @Resultado = 1
	IF NOT EXISTS (select *  from Categorias C
	 inner join Productos P on P.idcategoria = C.idCategoria
	 where C.idCategoria = @idcategoria
	)
	begin
		delete top(1) from Categorias where idCategoria = @idcategoria
	end
	else
	begin
		SET @Resultado = 0
		set @Mensaje = 'No se puede eliminar La categoria se encuentara relacionada a un producto'
	end
end
go

/* ---------- PROCEDIMIENTOS PARA PRODUCTO -----------------*/

create PROC spu_registrar_producto
	@idproducto		int,
	@imagen			varbinary(max),
	@idmarca		int,
	@idcategoria	int,
	@nombreproducto	varchar(50),
	@descripcion	varchar(100),
	@estado			bit,
	@Resultado		int output,
	@Mensaje		varchar(500) output
as begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM Productos WHERE idproducto= @idproducto)
	begin
		insert into Productos	(imagen,idmarca,idcategoria,nombreproducto,descripcion ,Estado) values 
								(@imagen,@idmarca,@idcategoria,@nombreproducto,@descripcion, @estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	ELSE
	 SET @Mensaje = 'Ya existe un producto con el mismo codigo' 
	
end
GO


create procedure spu_editar_producto
	@idproducto		int,
	@imagen			varbinary(max),
	@idmarca		int,
	@idcategoria	int,
	@nombreproducto	varchar(50),
	@descripcion	varchar(100),
	@estado			bit,
	@Resultado		bit output,
	@Mensaje		varchar(500) output
	
as begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Productos WHERE idproducto = @idproducto)
		
		update Productos set
		idproducto = @idproducto,
		imagen = @imagen,
		idmarca = @idmarca,
		idcategoria = @idcategoria,
		nombreproducto = @nombreproducto,
		descripcion = @descripcion,
		Estado = @Estado
		where idproducto = @idproducto
	ELSE
	begin
		SET @Resultado = 0
		SET @Mensaje = 'Ya existe un producto con el mismo codigo' 
	end
end
go



create PROC spu_eliminar_producto
	@idproducto int,
	@Respuesta bit output,
	@Mensaje varchar(500) output
	
as begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1

	IF EXISTS (SELECT * FROM detalleCompras DC
	INNER JOIN Productos P ON P.idproducto = DC.idproducto
	WHERE P.idproducto = @IdProducto
	)
	BEGIN
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado a una COMPRA\n' 
	END

	IF EXISTS (SELECT * FROM DetalleVentas DV
	INNER JOIN Productos P ON P.idproducto= DV.idproducto
	WHERE P.idproducto = @IdProducto
	)
	BEGIN
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado a una VENTA\n' 
	END

	if(@pasoreglas = 1)
	begin
		delete from Productos where idproducto = @IdProducto
		set @Respuesta = 1 
	end

end
go



/* PROCESOS PARA REGISTRAR UNA COMPRA */

CREATE TYPE [dbo].[EDetalle_Compra] AS TABLE(
	[IdProducto]	int NULL,
	[PrecioCompra]	decimal(7,2) NULL,
	[PrecioVenta]	decimal(7,2) NULL,
	[Cantidad]		int NULL,
	[MontoTotal]	decimal(7,2) NULL
)
GO


CREATE PROCEDURE spu_registrar_compra
	@idempleado			int,
	@idproveedor		int,
	@tipocomprobante	varchar(50),
	@numcomprobante		varchar(7),
	@MontoTotal			decimal(7,2),
	@DetalleCompra [EDetalle_Compra] READONLY,
	@Resultado bit output,
	@Mensaje varchar(500) output

as
begin
	
	begin try

		declare @idcompra int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro

		insert into Compras(idempleado,idproveedor,tipocomprobante,numcomprobante, montototal)
		values(@idempleado,@idproveedor,@tipocomprobante,@numcomprobante,@MontoTotal)

		set @idcompra = SCOPE_IDENTITY()

		insert into detalleCompras(idcompra,idproducto,preciocompra,precioVenta,cantidad,montototal)
		select @idcompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal from @DetalleCompra


		update Productos  set stock = stock + cantidad, 
		preciocompra = dc.PrecioCompra,
		precioVenta = dc.PrecioVenta
		from Productos
		inner join @DetalleCompra dc on dc.IdProducto= Productos.idproducto

		commit transaction registro


	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch

end
GO



/* PROCESOS PARA REGISTRAR UNA VENTA */

CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE(
	[IdProducto]	int				NULL,
	[PrecioVenta]	decimal(7,2)	NULL,
	[Cantidad]		int				NULL,
	[SubTotal]		decimal(7,2)	NULL
)
GO


create procedure spu_registrar_venta
	@idsede				int,
	@idempleado			int,
	@tipocomprobante	varchar(50),
	@numerocomprobante	varchar(7),
	@idcliente			int,
	@idmediopago		int,
	@montopago decimal(18,2),
	@montocambio decimal(18,2),
	@montototal decimal(18,2),
	@DetalleVenta [EDetalle_Venta] READONLY,                                      
	@Resultado bit output,
	@Mensaje varchar(500) output
	
as begin
	
	begin try

		declare @idventa int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin  transaction registro

		insert into Ventas(idsede,idempleado,tipocomprovante,numcomprovante,idcliente,idmediopago,montopago,montocambio,montototal)
		values(@idsede,@idempleado,@tipocomprobante,@numerocomprobante,@idcliente,@idmediopago,@montopago,@montocambio,@montototal)

		set @idventa = SCOPE_IDENTITY()

		insert into DetalleVentas(IdVenta,IdProducto,PrecioVenta,Cantidad,SubTotal)
		select @idventa,IdProducto,PrecioVenta,Cantidad,SubTotal from @DetalleVenta

		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch

end
go



--REPORTES DE COMPRAS
create PROC spu_reporte_compra
	 @fechainicio varchar(10),
	 @fechafin varchar(10),
	 @idproveedor int
	 
as begin

  SET DATEFORMAT dmy;
   select 
	convert(char(10),c.fechaRegistro,103)[FechaRegistro],c.tipocomprobante,c.numcomprobante,c.montototal,
	e.nombreusuario [EmpleadoRegistro],
	pr.RUC[RucProveedor],pr.nombreprov,
	p.idproducto[CodigoProducto],p.nombreproducto[NombreProducto],ca.nombreCategoria [Categoria],dc.preciocompra,dc.precioVenta,dc.cantidad,dc.montototal [SubTotal]
	from Compras c
	 inner join Empleados e on e.idempleado= c.idempleado
	 inner join Proveedores pr on pr.idproveedor = c.IdProveedor
	 inner join detalleCompras dc on dc.IdCompra = c.IdCompra
	 inner join Productos p on p.idproducto = dc.idproducto
	 inner join Categorias ca on ca.idCategoria = p.idcategoria
	 where CONVERT(date,c.FechaRegistro) between @fechainicio and @fechafin
	 and pr.IdProveedor = iif(@idproveedor=0,pr.IdProveedor,@idproveedor)
 end
 go

-- REPORTES DE VENTAS
 CREATE PROC spu_reporte_venta
	 @fechainicio varchar(10),
	 @fechafin varchar(10)
 
as begin
 SET DATEFORMAT dmy;  
 select 
 convert(char(10),v.FechaRegistro,103)[FechaRegistro],v.idcliente,v.MontoTotal,
 e.nombreusuario [UsuarioRegistro],
 v.idcliente,
 p.idproducto [CodigoProducto],p.nombreproducto [NombreProducto],ca.nombreCategoria [Categoria],dv.PrecioVenta,dv.Cantidad,dv.SubTotal
 from Ventas v
 inner join Empleados e on e.idempleado = v.idempleado
 inner join DetalleVentas dv on dv.IdVenta = v.IdVenta
 inner join Productos p on p.idproducto = dv.idproducto
 inner join Categorias ca on ca.idCategoria = p.IdCategoria
 where CONVERT(date,v.FechaRegistro) between @fechainicio and @fechafin
end

