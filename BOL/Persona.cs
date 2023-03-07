using DAL;
using ENTITIES;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BOL
{
    public class Persona
    {
        DBAccess acceso = new DBAccess();

        public DataTable listarActivos()
        {
            return acceso.getDataFrom("spu_listar_personas", 1);
        }

        public int registrar(EPersona entidad)
        {
            int registrarAfectados = 0;

            acceso.conectar();

            SqlCommand cmd = new SqlCommand("spu_registrar_personas", acceso.getConexion());
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@apellidos",entidad.apellidos);
            cmd.Parameters.AddWithValue("@nombres",entidad.nombres);
            cmd.Parameters.AddWithValue("@dni",entidad.DNI);
            cmd.Parameters.AddWithValue("@telefono",entidad.telefono);

            registrarAfectados = cmd.ExecuteNonQuery();

            acceso.desconectar();
            return registrarAfectados;
        }

        public int modificar(short v, EPersona entidad)
        {
            int modificados = 0;

            acceso.conectar();

            SqlCommand cmd = new SqlCommand("spu_modificar_personas",acceso.getConexion());
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@idpersona", entidad.idpersona);
            cmd.Parameters.AddWithValue("@apellidos", entidad.apellidos);
            cmd.Parameters.AddWithValue("@nombres", entidad.nombres);
            cmd.Parameters.AddWithValue("@dni", entidad.DNI);
            cmd.Parameters.AddWithValue("@telefono", entidad.telefono);


            modificados= cmd.ExecuteNonQuery();

            acceso.desconectar();
            return modificados;
        }

        public DataTable editarpersona(int id, string apellidos, string nombres, string dni, string telefono)
        {
            DataTable dt = new DataTable();
            acceso.conectar();
            SqlCommand sqlCommand = new SqlCommand("spu_modificar_personas", acceso.getConexion());
            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.AddWithValue("@idpersona", id);
            sqlCommand.Parameters.AddWithValue("@apellidos",apellidos);
            sqlCommand.Parameters.AddWithValue("@nombres",nombres);
            sqlCommand.Parameters.AddWithValue("@dni",dni);
            sqlCommand.Parameters.AddWithValue("@telefono",telefono);

            dt.Load(sqlCommand.ExecuteReader());

            acceso.desconectar();

            return dt;
        }


    }
}
