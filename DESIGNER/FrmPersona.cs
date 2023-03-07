using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using BOL;
using DESIGNER;
using DESIGNER.Herramientas;
using ENTITIES;


namespace DESIGNER
{
    public partial class FrmPersona : Form
    {
        Persona persona = new Persona();
        EPersona entidadpersona = new EPersona();
        DataTable dt = new DataTable();
        DataView dv = new DataView();

        public FrmPersona()
        {
            InitializeComponent();
        }

        private void cargaDatos()
        {
            dt = persona.listarActivos();
            dgvpersonas.DataSource = dt;
            dgvpersonas.Refresh();
            dv = dt.DefaultView; //conexion entre datatable y dataview

        }

        public void limpiarcajas()
        {
            txtid.Clear();
            txtapellidos.Clear();
            txtnombres.Clear();
            txtdni.Clear();
            txttelefono.Clear();
            txtvalorbuscado.Clear();
        }


        private void FrmVenta_Load(object sender, EventArgs e)
        {
            //dgvpersonas.DataSource = persona.listarActivos();
            //dgvpersonas.Refresh();

            cargaDatos();

            //configurando
            dgvpersonas.Columns[0].Width = 30;
            dgvpersonas.Columns[1].Width = 100;
            dgvpersonas.Columns[2].Width = 100;
            dgvpersonas.Columns[3].Width = 100;
            dgvpersonas.Columns[4].Width = 100;
            dgvpersonas.Columns[5].Width = 200;

        }

        private void btnmodificar_Click(object sender, EventArgs e)
        {
            persona.editarpersona(Convert.ToInt16(txtid.Text), txtapellidos.Text, txtnombres.Text, txtdni.Text, txttelefono.Text);

            if(Dialogo.Preguntar("¿Estás seguro de hacer cambios?") == DialogResult.Yes);
            dgvpersonas.Refresh();
            dgvpersonas.DataSource = persona.listarActivos();

            limpiarcajas();
            
        }

        private void btnguardar_Click(object sender, EventArgs e)
        {
            if(txtapellidos.Text.Trim() == String.Empty ||
                txtnombres.Text.Trim() == String.Empty ||
                txtdni.Text.Trim().Length != 8 ||
                txttelefono.Text.Trim().Length != 9)
            {
                Dialogo.Informar("Complete campos");
            }

            else
            {
                if (Dialogo.Preguntar("¿Registramos a la persona?") == DialogResult.Yes)

                    //enviar los valores de las cajas de texto a la entidad
                    entidadpersona.apellidos = txtapellidos.Text.Trim();
                    entidadpersona.nombres = txtnombres.Text.Trim();
                    entidadpersona.DNI = txtdni.Text.Trim();
                    entidadpersona.telefono = txttelefono.Text.Trim();

                //la entidad es enviada al metodo como parametro
                if(persona.registrar(entidadpersona) > 0)
                {
                    dgvpersonas.DataSource = persona.listarActivos();

                    limpiarcajas();
                }

                else
                {
                    Dialogo.Error("Error, no se pudo registrar");
                }

            }
            
        }

    

        private void dgvpersonas_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            txtapellidos.Text = dgvpersonas.CurrentRow.Cells[1].Value.ToString();
            txtnombres.Text = dgvpersonas.CurrentRow.Cells[2].Value.ToString();
            txtdni.Text = dgvpersonas.CurrentRow.Cells[3].Value.ToString();
            txttelefono.Text = dgvpersonas.CurrentRow.Cells[4].Value.ToString();
            txtid.Text = dgvpersonas.CurrentRow.Cells[0].Value.ToString();
        }


        private void txtvalorbuscado_TextChanged(object sender, EventArgs e)
        {
            if(txtvalorbuscado.Text.Trim() != String.Empty)
            {
                dv.RowFilter = "dni like '%" + txtvalorbuscado.Text.Trim() + "%'";
            }
            if(rtnombres.Checked == true )
            {
                dv.RowFilter = "apellidos like '%" + txtvalorbuscado.Text.Trim() + "%'";
            }
            else
            {
                dgvpersonas.ClearSelection();
            }
        }

        private void btnactualizar_Click(object sender, EventArgs e)
        {
            cargaDatos();
            limpiarcajas();

        }
    }
}
