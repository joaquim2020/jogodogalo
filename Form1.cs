using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace jogodogalo
{
    public partial class Form1 : Form
    {
        private string currentPlayer = "X";
        private bool gameWon = false;

        public Form1()
        {
            InitializeComponent();
        }

        private void button_Click(object sender, EventArgs e)
        {
            Button button = (Button)sender;
            statusBar1.Text = "";
            statusBar1.Text = $"  {button.Text} clicked";

            if (button.Text == "" && !gameWon)
            {
                button.Text = currentPlayer;
                if (CheckWinner())
                {
                    statusBar1.Text = $"Player {currentPlayer} wins!";
                    gameWon = true;
                }
                else if (IsBoardFull())
                {
                    statusBar1.Text = "It's a draw!";
                }
                else
                {
                    currentPlayer = (currentPlayer == "X") ? "O" : "X";
                    statusBar1.Text = $"Player {currentPlayer}'s turn";
                }
            }
        }

        private bool CheckWinner()
        {
            // Win conditions: rows, columns, diagonals
            return (CheckLine(button1, button2, button3) || CheckLine(button4, button5, button6) ||
                    CheckLine(button7, button8, button9) || CheckLine(button1, button4, button7) ||
                    CheckLine(button2, button5, button8) || CheckLine(button3, button6, button9) ||
                    CheckLine(button1, button5, button9) || CheckLine(button3, button5, button7));
        }

        private bool CheckLine(Button b1, Button b2, Button b3)
        {
            return (b1.Text == b2.Text && b2.Text == b3.Text && b1.Text != "");
        }

        private bool IsBoardFull()
        {
            foreach (Control c in Controls)
            {
                if (c is Button && c.Text == "")
                {
                    return false;
                }
            }
            return true;
        }

        private void buttonReset_Click(object sender, EventArgs e)
        {
            foreach (Control c in Controls)
            {
                if (c is Button)
                {
                    c.Text = "";
                }
                button10.Text= "RESET";
            }
            currentPlayer = "X";

            statusBar1.Text = "Player X's turn";
            gameWon = false;
        }

       
    }
}