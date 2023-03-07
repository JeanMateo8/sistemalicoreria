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
    public class Empleado
    {
        DBAccess acceso = new DBAccess();

        public DataTable listarActivos()
        {
            return acceso.getDataFrom("spu_listar_empleado", 1);
        }

        public int registrar(EEmpleado entidad)
        {
            int registrarAfectados = 0;

            acceso.conectar();

            SqlCommand cmd = new SqlCommand("spu_registrar_empleado", acceso.getConexion());
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@idpersona", entidad.idpersona);
            cmd.Parameters.AddWithValue("@nombreacceso", entidad.nombreusuario);
            cmd.Parameters.AddWithValue("@clave", entidad.claveacceso);
            

            registrarAfectados = cmd.ExecuteNonQuery();

            acceso.desconectar();
            return registrarAfectados;
        }

        public DataTable agregar(string id, string usuario, string clave)
        {
            DataTable dt = new DataTable();
            acceso.conectar();
            SqlCommand sqlCommand = new SqlCommand("spu_registrar_empleado", acceso.getConexion());
            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.AddWithValue("@idpersona", id);
            sqlCommand.Parameters.AddWithValue("@nombreusuario",usuario);
            sqlCommand.Parameters.AddWithValue("@claveacceso", clave);
            

            dt.Load(sqlCommand.ExecuteReader());

            acceso.desconectar();

            return dt;
        }

        public DataTable editarEmpleado(int id, string clave)
        {
            DataTable dt = new DataTable();
            acceso.conectar();
            SqlCommand sqlCommand = new SqlCommand("spu_modificar_Empleado", acceso.getConexion());
            sqlCommand.CommandType = CommandType.StoredProcedure;

           
            sqlCommand.Parameters.AddWithValue("@idempleado", id);
            sqlCommand.Parameters.AddWithValue("@claveacceso", clave);
            

            dt.Load(sqlCommand.ExecuteReader());

            acceso.desconectar();

            return dt;
        }

    }
}
