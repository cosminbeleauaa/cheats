Public Class Form1

    Public Declare Sub mouse_event Lib "user32" (ByVal dwFlags As Long, ByVal dx As Long, ByVal dy As Long, ByVal dwData As Long, ByVal dwExtraInfo As Long)

    Const MOUSEEVENTF_LEFTDOWN = &H2
    Const MOUSEEVENTF_LEFTUP = &H4

    '=====================================================================================================================================
    '|       ADDRESS       |       DEFAULT VALUE AS HEXADECIMAL BYTE ARRAY        |        CHANGED VALUE AS HEXADECIMAL BYTE ARRAY       |
    '|#####################|######################################################|######################################################|
    '| samp.dll + 99250    | E9                                                   | C3                                                   |
    '| samp.dll + 286923   | 0F 85 8E F4 07 00 60 C7                              | B8 45 00 00 00 C2 1C 00                              |
    '| samp.dll + 298116   | 55 68 0D EF 04 F5 9C C7                              | B8 45 00 00 00 C2 1C 00                              |
    '| samp.dll + 2B9EE4   | 83 3D 30 A1 62 04 05 60 9C 8D 64 24                  | FF 05 00 41 57 56 A1 00 41 57 56 C3                  | -> NOT WORKING
    '=====================================================================================================================================
    '|       ADDRESS       |           DEFAULT VALUE AS DECIMAL 4 BYTE            |            CHANGED VALUE AS DECIMAL 4 BYTE           |
    '|#####################|######################################################|######################################################|
    '| samp.dll + 99250    | 507680745                                            | 507680707                                            |
    '| samp.dll + 286923   | 4102980879                                           | 17848                                                |
    '| samp.dll + 2B9EE4   | 4010633301                                           | 17848                                                |
    '| samp.dll + 298116   | 2704293251                                           | 1090520575                                           | -> NOT WORKING
    '=====================================================================================================================================

    Dim BaseAddress As Integer
    Dim proc As String = "gta_sa"

    'PENTRU DEBUG MODE:

    Dim disabled As String
    Dim firstcond
    Dim secondcond
    Dim renderped = "0"
    Dim slotweapon = "0"
    Dim checkingcar = "0"
    Dim shotstatus = "0"
    Dim pped = "0"
    Dim wId = "0"
    Dim deagleclip = "0"
    Dim m4clip = "0"
    Dim xaxis = "0"
    Dim yaxis = "0.0015"
    Dim fastconnect = "3000"
    Dim wallhack = "OFF"
    Dim semi = "0"
    Dim rotation = "0"
    Dim slapkey = "0"
    Dim slap = "0"
    Dim onfoot = "40"
    Dim incar = "40"
    Dim aimdata = "40"
    Dim xpos = "0"
    Dim ypos = "0"
    Dim zpos = "0"
    Dim xmap = "0"
    Dim ymap = "0"
    Dim togglemap = "0"
    Dim antistun = "0"

    Declare Sub Sleep Lib "kernel32" (ByVal milliseconds As Integer)

    Public Function GetModuleBaseAddress(ByVal ProcessName As String, ByVal ModuleName As String) As Integer
        Try
            For Each PM As ProcessModule In Process.GetProcessesByName(ProcessName)(0).Modules
                If ModuleName = PM.ModuleName Then
                    BaseAddress = PM.BaseAddress
                End If
            Next
        Catch ex As Exception

        End Try
        Return BaseAddress

    End Function

    Public Function disableAntiCheat()
        Try
            BaseAddress = GetModuleBaseAddress(proc, "samp.dll")
            firstcond = ReadLong(proc, BaseAddress + "&H99250", nsize:=4)
            secondcond = ReadLong(proc, BaseAddress + "&H286923", nsize:=4)
            If firstcond <> 507680707 Or secondcond <> 17848 Then
                WriteLong(proc, BaseAddress + "&H99250", Value:=507680707, nsize:=4)
                Sleep(100)
                WriteLong(proc, BaseAddress + "&H286923", Value:=17848, nsize:=4)
                disabled = "Yes"
            Else
                disabled = "Already Disabled"
            End If
        Catch ex As Exception

        End Try
    End Function

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        End
    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick

        ' TRIGGERBOT
        ' URMATOARELE CONDITII:
        '
        ' SA FIE TINTA PUSA PE CINEVA, ADICA SA EXISTE TRIUNGHIUL VERDE
        ' SA DETINA O ARMA CORECT CORESPUNZATOARE
        ' SA NU FIE IN MASINA
        ' SI CAM ATAT.

        ' ALLOWED SLOTS:
        '
        ' ARMELE DE AICI SUNT PUSE LA GENERAL;
        ' 6236162 (2 as Deagle)
        ' 6236163 (3 as Shotgun)
        ' 6236164 (4 as MP5)
        ' 6236165 (5 as M4)
        ' 6236166 (6 as Rifle)
        ' 6236167 (7 as Minigun)
        ' 
        If CheckBox2.Checked = True Then
            Try
                Dim target = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H79C}, Level:=1, nsize:=4)
                Dim slot = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H718}, Level:=1, nsize:=4)
                Dim checkcar = ReadLong(proc, "&HBA18FC", nsize:=4)
                Dim BaseInput = GetModuleBaseAddress(proc, "DINPUT8.dll")
                Dim input = ReadLong(proc, BaseInput + "&H2FE8C", nsize:=4)

                If target > 0 Then
                    If _
                        slot = 6236162 Or _
                        slot = 6236163 Or _
                        slot = 6236164 Or _
                        CheckBox10.Checked = True Or _
                        slot = 6236166 Or _
                        slot = 6236167 Then
                        If checkcar = 0 Then
                            '
                            ' ACUM FOLOSIM DINPUT8.DLL
                            ' AVEM URMATOARELE VALORI:
                            ' 0 = Nimic
                            ' 128 = Doar Click Stanga
                            ' 32768 = Doar Click Dreapta
                            ' 32896 = Click stanga + Click dreapta

                            'WriteLong(proc, BaseInput + "&H2FE8C", Value:=32896, nsize:=4)
                            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
                            Sleep(10)
                            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
                            'WriteLong(proc, BaseInput + "&H2FE8C", Value:=32768, nsize:=4)
                            Sleep(1)
                            WriteDMALong(proc, "&HB6F5F0", Offsets:={&H79C}, Value:=0, Level:=1, nsize:=4)
                        End If
                    End If
                End If

                pped = target.ToString
                slotweapon = slot.ToString
                checkcar = checkingcar.ToString
                shotstatus = input.ToString

            Catch ex As Exception

            End Try
        End If

        '
        ' ADVANCED NO RELOAD
        '
        ' IN CE CONSTA? SIMPLU:
        ' ATUNCI CAND TRAGI SI AI RAMAS LA ULTIMUL GLONT SE REINCARCA CARTUSUL AUTOMAT LA 7
        ' ACEST COD VA APLICA TREABA ASTA DOAR LA DEAGLE SI M4, BINEINTELES MERGE SI LA ARTA ARMA, GEN MP5 SAU TEC
        '

        If CheckBox4.Checked = True Then

            ' AVEM URMATOARELE ADRESE:
            ' BAA410 => Verifica ce arma detii in mana (respectiv id-ul armei, in cazul nostru vrem advanced no reload pentru deagle si m4)
            ' B6F5F0 => CPED
            ' 5E0 => OFFSET CLIP DEAGLE
            ' 634 => OFFSET CLIP M4
            Try
                wId = ReadLong(proc, "&HBAA410", nsize:=4)
                deagleclip = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H5E0}, Level:=1, nsize:=4)
                m4clip = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H634}, Level:=1, nsize:=4)

                If wId = 24 Then
                    If deagleclip <= 6 Then
                        WriteDMALong(proc, "&HB6F5F0", Offsets:={&H5E0}, Value:=deagleclip + 1, Level:=1, nsize:=4)
                    End If
                ElseIf wId = 31 Then
                    If m4clip <= 49 Then
                        WriteDMALong(proc, "&HB6F5F0", Offsets:={&H634}, Value:=m4clip + 1, Level:=1, nsize:=4)
                    End If
                End If
            Catch Ex As Exception
            End Try
        End If

        Try
            If disabled <> "Yes" Or disabled <> "Already Disabled" Then
                disableAntiCheat()
            End If
        Catch ex As Exception
        End Try


        '
        ' DISABLE PED RENDER
        ' OFF = 1465445507
        ' ON = 1469092035
        '

        Try
            Dim pedrender = ReadLong(proc, "&H60BA80", nsize:=4)
            If CheckBox1.Checked = True Then
                If pedrender <> 1469092035 Then
                    WriteLong(proc, "&H60BA80", Value:=1469092035, nsize:=4)
                End If
            Else
                If pedrender <> 1465445507 Then
                    WriteLong(proc, "&H60BA80", Value:=1465445507, nsize:=4)
                End If
            End If
            renderped = pedrender.ToString
        Catch Ex As Exception
        End Try

        If CheckBox3.Checked = True Then
            Label1.Text = "Debug Mode:" + vbNewLine + _
                "Disabled: " + disabled.ToString + vbNewLine + _
                "First Address: " + firstcond.ToString + vbNewLine + _
                "Second Address: " + secondcond.ToString + vbNewLine + _
                "Ped Render: " + renderped + vbNewLine + _
                "Weapon Slot: " + slotweapon + vbNewLine + _
                "Checkcar: " + checkingcar + vbNewLine + _
                "Shoot: " + shotstatus + vbNewLine + _
                "Target: " + pped + vbNewLine + _
                "Weapon ID: " + wId.ToString + vbNewLine + _
                "Deagle Clip: " + deagleclip.ToString + vbNewLine + _
                "M4 Clip: " + m4clip.ToString + vbNewLine + _
                "X Axis: " + xaxis.ToString + vbNewLine + _
                "Y Axis: " + yaxis.ToString + vbNewLine + _
                "FastConnect: " + fastconnect.ToString + vbNewLine + _
                "WallHack: " + wallhack.ToString + vbNewLine + _
                "Recoil: " + semi.ToString + vbNewLine + _
                "Rotation: " + rotation.ToString + vbNewLine + _
                "Slap Key: " + slapkey.ToString + vbNewLine + _
                "Slap: " + slap.ToString + vbNewLine + _
                "OnFoot: " + onfoot.ToString + vbNewLine + _
                "InCar: " + incar.ToString + vbNewLine + _
                "AimData: " + aimdata.ToString + vbNewLine + _
                "XPOS: " + xpos.ToString + vbNewLine + _
                "YPOS: " + ypos.ToString + vbNewLine + _
                "XMAP: " + xmap.ToString + vbNewLine + _
                "YMAP: " + ymap.ToString + vbNewLine + _
                "ToggleMap: " + togglemap.ToString + vbNewLine + _
                "Anti-Stun delay: " + antistun.ToString

        Else
            Label1.Text = "Debug Mode:"
        End If

        '
        ' MOUSEFIX, CEL MAU USOR EVER "CIT" DE FACUT, DOAR VA ARAT xD
        ' AVEM URMATOARELE ADRESE: AXA X, RESPECTIV AXA Y
        ' AXA Y NU POATE FI MODIFICATA DIN JOC, DAR SCOPUL NOSTRU ESTE DE A
        ' EGALA AXA X (Sensivitatea din optiuni) cu axa Y
        ' AXA X: B6EC1C
        ' AXA Y: B6EC18
        '

        If CheckBox5.Checked = True Then
            Try
                xaxis = ReadFloat(proc, "&HB6EC1C", nsize:=4)
                yaxis = ReadFloat(proc, "&HB6EC18", nsize:=4)
                If xaxis <> yaxis Then
                    'Egalarea
                    WriteFloat(proc, "&HB6EC18", Value:=xaxis, nsize:=4)
                End If
            Catch ex As Exception

            End Try
        Else
            Try
                If yaxis <> "0.0015" Then 'aici ar putea fi o problema, dar in fine.
                    yaxis = "0.0015"
                    WriteFloat(proc, "&HB6EC18", Value:=0.0015, nsize:=4)
                End If
            Catch ex As Exception

            End Try
        End If

        '
        ' FASTCONNECT
        ' // FARA CHEAT ENGINE PLS
        ' 3000 = delay normal de conectare
        ' 0 = fast connect (fara delay)
        ' ADRESA: samp.dll + 2D3C45
        '

            If CheckBox6.Checked = True Then
            Try
                Dim sampADDR = GetModuleBaseAddress(proc, "samp.dll")
                fastconnect = ReadLong(proc, sampADDR + "&H2D3C45", nsize:=4)
                If fastconnect <> 0 Then
                    fastconnect = "0"
                    WriteLong(proc, sampADDR + "&H2D3C45", Value:=0, nsize:=4)
                End If
            Catch ex As Exception
            End Try
            Else
            Try
                Dim sampADDR = GetModuleBaseAddress(proc, "samp.dll")
                fastconnect = ReadLong(proc, sampADDR + "&H2D3C45", nsize:=4)
                If fastconnect <> 3000 Then
                    fastconnect = "3000"
                    WriteLong(proc, sampADDR + "&H2D3C45", Value:=3000, nsize:=4)
                End If
            Catch ex As Exception
            End Try
            End If

        '
        ' WALLHACK - SOURCE CODE WAS STOLEN FROM CHEATSTW
        '

        If CheckBox7.Checked = True Then
            Try
                Dim sampADDR = GetModuleBaseAddress(proc, "samp.dll")
                Dim distance = ReadDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H27}, Level:=2, nsize:=4)
                Dim calutulauriu = ReadDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H2F}, Level:=2, nsize:=4)
                If calutulauriu <> 512 Then
                    WriteDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H27}, Value:=1203982336, Level:=2, nsize:=4)
                    WriteDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H2F}, Value:=512, Level:=2, nsize:=4)
                    wallhack = "ON"
                End If

            Catch ex As Exception
            End Try
        Else
            Try
                Dim sampADDR = GetModuleBaseAddress(proc, "samp.dll")
                Dim distance = ReadDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H27}, Level:=2, nsize:=4)
                Dim calutulauriu = ReadDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H2F}, Level:=2, nsize:=4)
                If calutulauriu <> 513 Then
                    WriteDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H27}, Value:=1112014848, Level:=2, nsize:=4)
                    WriteDMALong(proc, sampADDR + &H21A0F8, Offsets:={&H3C5, &H2F}, Value:=513, Level:=2, nsize:=4)
                    wallhack = "OFF"
                    End If

            Catch ex As Exception
            End Try
        End If

        '
        ' SEMI NO RECOIL
        ' ADDRESS: B7CDC8
        ' SET VAL: 1.074754357
        '

        If CheckBox8.Checked = True Then
            Try
                semi = ReadFloat(proc, "&HB7CDC8", nsize:=4)
                If semi >= 1.074754357 Then
                    WriteFloat(proc, "&HB7CDC8", Value:=0, nsize:=4)
                End If
            Catch ex As Exception

            End Try
        End If

        '
        ' ROTATION
        ' ADDRESS: B6F5F0 + 560 AS POINTER
        '
        If CheckBox9.Checked = True Then
            Try
                rotation = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H560}, Level:=1, nsize:=4)
                If rotation <> 1103626240 Then
                    WriteDMALong(proc, "&HB6F5F0", Offsets:={&H560}, Value:=1103626240, Level:=1, nsize:=4)
                End If
            Catch ex As Exception

            End Try
        End If

        '
        ' SLAP
        ' ACTIVATION: F10
        ' PRESS TYPE: ONCE
        ' ADDRESS FOR F10: BA6768 | 257 = off & 1 = on
        ' ADDRESS FOR Z POS: B6F5F0 + 14 + 38 AS POINTER
        ' 1084856730 for 5.3
        '

        If CheckBox11.Checked = True Then
            slap = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H14, &H38}, Level:=2, nsize:=4)
            slapkey = ReadLong(proc, "&HBA6768", nsize:=4)
            Const add = 1084856730
            Try
                If slapkey = 1 Then
                    WriteDMALong(proc, "&HB6F5F0", Offsets:={&H14, &H38}, Value:=slap + 4000000, Level:=2, nsize:=4)
                    Sleep(10)
                    WriteLong(proc, "&HBA6768", Value:=257, nsize:=4)
                End If
            Catch ex As Exception

            End Try

        End If

        '
        ' TELEPORT PE MAPA
        ' ADRESE:
        ' xmap = BA67B8
        ' ymap = BA67BC
        ' xpos = B6F5F0 + 14 + 30 AS POINTER
        ' ypos = B6F5F0 + 14 + 34 AS POINTER
        ' ACUM AVEM NEVOIE DE UN TOGGLE, De exemplu un target
        ' Vom folosi space ca sa ne teleportam pe mapa:
        ' togglemap = BA6778
        '

        If CheckBox15.Checked = True Then
            Try
                xmap = ReadLong(proc, "&HBA67B8", nsize:=4)
                ymap = ReadLong(proc, "&HBA67BC", nsize:=4)
                xpos = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H14, &H30}, Level:=2, nsize:=4)
                ypos = ReadDMALong(proc, "&HB6F5F0", Offsets:={&H14, &H34}, Level:=2, nsize:=4)
                togglemap = ReadLong(proc, "&HBA6778", nsize:=4)
                If togglemap = 0 Then
                    WriteDMALong(proc, "&HB6F5F0", Offsets:={&H14, &H30}, Value:=xmap, Level:=2, nsize:=4)
                    Sleep(10)
                    WriteDMALong(proc, "&HB6F5F0", Offsets:={&H14, &H34}, Value:=ymap, Level:=2, nsize:=4)
                End If
            Catch ex As Exception
            End Try
        End If

    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Timer1.Interval = 1
        Timer1.Start()
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        MsgBox("Goodule, vezi sa nu iei sursa codului si sa zici ca e facut de tine, ok?" + vbNewLine + "Apropo, e free.", MsgBoxStyle.OkOnly, "About")
    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button3.Click
        Try

            Dim SampADDR = GetModuleBaseAddress(proc, "samp.dll")

            If CheckBox12.Checked = True Then 'onfoot
                WriteLong(proc, SampADDR + "&HEC0A8", Value:=NumericUpDown1.Value, nsize:=4)
            End If

            If CheckBox13.Checked = True Then 'incar
                WriteLong(proc, SampADDR + "&HEC0AC", Value:=NumericUpDown1.Value, nsize:=4)
            End If

            If CheckBox14.Checked = True Then 'aimdata
                WriteLong(proc, SampADDR + "&HEC0B0", Value:=NumericUpDown1.Value, nsize:=4)
            End If
            onfoot = ReadLong(proc, SampADDR + "&HEC0A8", nsize:=4)
            incar = ReadLong(proc, SampADDR + "&HEC0AC", nsize:=4)
            aimdata = ReadLong(proc, SampADDR + "&HEC0B0", nsize:=4)
        Catch ex As Exception

        End Try
    End Sub
End Class

'RECAPITULARE:
'DISABLE ANTICHEAT (ALA DE LA SAMP NU DE LA SERVER), ACEASTA CHESTIE PREVINE BLOCAREA JOCULUI
'SI RESTU, CE MAI SCRIE MAI SUS.
