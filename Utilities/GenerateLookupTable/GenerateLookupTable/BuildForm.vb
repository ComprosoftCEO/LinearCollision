Imports System.IO

Public Class BuildForm

    'Generate the code
    Private Sub GenerateButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GenerateButton.Click

        Dim output As String = " GraphicBytes("

        output += GetNumber(CheckBox1).ToString()
        output += ","
        output += GetNumber(CheckBox2).ToString()
        output += ","
        output += GetNumber(CheckBox3).ToString()
        output += ","
        output += GetNumber(CheckBox4).ToString()
        output += ","
        output += GetNumber(CheckBox5).ToString()
        output += ","
        output += GetNumber(CheckBox6).ToString()
        output += ","
        output += GetNumber(CheckBox7).ToString()
        output += ","
        output += GetNumber(CheckBox8).ToString()
        output += ") = "
        output += HexNumericUpDown.Value().ToString()

        TextBox1.Text = output
        My.Computer.Clipboard.SetText(output)
        HexNumericUpDown.Value = HexNumericUpDown.Value + 1

    End Sub

    Function GetNumber(ByVal input As Object) As Integer

        If input.checked = False Then
            Return 0
        Else
            Return 1
        End If

    End Function

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Module1.Main()

        If SaveFileDialog1.ShowDialog = Windows.Forms.DialogResult.OK Then
            Dim Writer As New StreamWriter(SaveFileDialog1.FileName, False)

            For i = 0 To 255
                If (i Mod 16) = 0 Then
                    Writer.Write("  .db ")
                End If
                Writer.Write("$" & Module1.RetArray(i).ToString("X2"))
                If (i Mod 16) <> 15 Then
                    Writer.Write(",")
                End If
                If (i Mod 16) = 15 Then
                    Writer.Write(Environment.NewLine)
                End If

            Next
            Writer.Close()
        End If
    End Sub
End Class