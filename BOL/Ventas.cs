using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

using DAL;
using ENTITIES;

namespace BOL
{
    public class Ventas
    {
        DBAccess acceso = new DBAccess();

        public DataTable listarVentas()
        {
            return acceso.getDataFrom("",1);
        }

        //public int registrar(EPersona entidad,out string Mensaje)
        //{
        //    int idClientegenerado = 0;
        //    Mensaje = string.Empty;
        //    try
        //    {

        //        acceso.conectar();

        //        SqlCommand cmd = new SqlCommand("spu_registrar_persona", acceso.getConexion());
        //        cmd.Parameters.AddWithValue("@apellidos", entidad.apellidos);
        //        cmd.Parameters.AddWithValue("@nombres", entidad.nombres);
        //        cmd.Parameters.AddWithValue("@dni",entidad.DNI);
        //        cmd.Parameters.AddWithValue("@telefono", entidad.telefono);
               
        //        cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
        //        cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
        //        cmd.CommandType = CommandType.StoredProcedure;
 

        //        cmd.ExecuteNonQuery();

        //        idClientegenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
        //        Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
   
        //    }
 
        //    catch (Exception ex)
        //    {
        //        idClientegenerado = 0;
        //        Mensaje = ex.Message;
        //    }



        //    return idClientegenerado;
        //}
    }
}
