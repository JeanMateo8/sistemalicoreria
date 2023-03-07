using BOL;
using DESIGNER.Herramientas;
using ENTITIES;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DESIGNER
{
    public partial class FrmEmpleado : Form
    {
        Empleado empleado = new Empleado();
        Persona persona= new Persona();
        EEmpleado entidadempleado = new EEmpleado();
        DataTable dt = new DataTable();
        DataView dv = new DataView();
        public FrmEmpleado()
        {
            InitializeComponent();
        }

        public void limpiarcajas()
        {
            txtidpersona.Clear();
            txtusuario.Clear();
            txtclave.Clear();
        }

        private void FrmEmpleado_Load(object sender, EventArgs e)
        {
            dgvempleados.DataSource= persona.listarActivos();
            btnmodificar.Visible = false;
            //configurando
            dgvempleados.Columns[0].Width = 30;
            dgvempleados.Columns[1].Width = 100;
            dgvempleados.Columns[2].Width = 100;
            dgvempleados.Columns[3].Width = 100;
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if(Dialogo.Preguntar("¿Desea Guardar Empleado") == DialogResult.Yes)
            {
                string id = txtidpersona.Text;
                string usuario = txtusuario.Text;
                string clave = txtclave.Text;

                empleado.agregar(id, usuario, clave);
                limpiarcajas();

                MessageBox.Show("Guardado correctamente");

                dgvempleados.DataSource = empleado.listarActivos();
            }
        }

        private void dgvempleados_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            txtidpersona.Text = dgvempleados.CurrentRow.Cells[0].Value.ToString();

        }

        private void button2_Click(object sender, EventArgs e)
        {
            dgvempleados.DataSource = persona.listarActivos();
            txtidpersona.Enabled = true;
            txtusuario.Enabled = true;
            btnmodificar.Visible = false;
            radioButton1.Checked= false;
        }

        private void btnmodificar_Click(object sender, EventArgs e)
        {
            
            empleado.editarEmpleado(Convert.ToInt16(txtidusuario.Text), txtclave.Text);

            if (Dialogo.Preguntar("¿Estás seguro de hacer cambios?") == DialogResult.Yes)
            
            dgvempleados.Refresh();
            dgvempleados.DataSource = persona.listarActivos();

            limpiarcajas();
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if(radioButton1.Checked == true) 
            {
                btnmodificar.Visible = true;
                txtidpersona.Enabled = false;
                txtusuario.Enabled = false;
                dgvempleados.DataSource = empleado.listarActivos();
                txtidusuario.Text = dgvempleados.CurrentRow.Cells[1].Value.ToString();

                
                txtusuario.Text = dgvempleados.CurrentRow.Cells[2].Value.ToString();
                txtclave.Text = dgvempleados.CurrentRow.Cells[3].Value.ToString();

            }

        }
    }
}
