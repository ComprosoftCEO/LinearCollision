Module Module1
    Public RetArray(255) As Byte

    Sub Main()

        Define()

        'Run a major for loop to do this
        Dim Spot As Byte = 0
        For b7 = 0 To 1
            For b6 = 0 To 1
                For b5 = 0 To 1
                    For b4 = 0 To 1
                        For b3 = 0 To 1
                            For b2 = 0 To 1
                                For b1 = 0 To 1
                                    For b0 = 0 To 1
                                        RetArray(Spot) = GenerateByte(b7, b6, b5, b4, b3, b2, b1, b0)
                                        Console.WriteLine(Spot & "|" & b7 & b6 & b5 & b4 & b3 & b2 & b1 & b0 & "|" & RetArray(Spot))
                                        If Spot < 255 Then
                                            Spot += 1
                                        End If
                                    Next
                                Next
                            Next
                        Next
                    Next
                Next
            Next
        Next
    End Sub

    Function GenerateByte(ByVal b7 As Byte, ByVal b6 As Byte, ByVal b5 As Byte, ByVal b4 As Byte, ByVal b3 As Byte, ByVal b2 As Byte, ByVal b1 As Byte, ByVal b0 As Byte) As Byte

        'B3 - B0 define the lines
        'B7 - B4 define the corners
        Dim v1, v2, v3, v4, v5, v6, v7, v8 As Byte


        'Do the corners first. The value is inverse of the corners.
        v1 = ((Not b7) And 1)
        v3 = ((Not b6) And 1)
        v6 = ((Not b5) And 1)
        v8 = ((Not b4) And 1)

        'Now do the lines
        'No walls turn on lines
        If b3 = 0 Then
            v1 = 1
            v2 = 1
            v3 = 1
        End If

        If b2 = 0 Then
            v6 = 1
            v7 = 1
            v8 = 1
        End If

        If b1 = 0 Then
            v1 = 1
            v4 = 1
            v6 = 1
        End If

        If b0 = 0 Then
            v3 = 1
            v5 = 1
            v8 = 1
        End If



        ' Console.WriteLine(b7 & b3 & b6)
        ' Console.WriteLine(b1 & " " & b0)
        ' Console.WriteLine(b5 & b2 & b4)

        '        Console.WriteLine(v1 & v2 & v3)
        '       Console.WriteLine(v4 & " " & v5)
        '      Console.WriteLine(v6 & v7 & v8)

        Return Constants.GraphicBytes(v1, v2, v3, v4, v5, v6, v7, v8)
    End Function


End Module
