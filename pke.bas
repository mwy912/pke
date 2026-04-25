   set romsize 16kSC
   set kernel_options player1colors pfheights
   
   ;***************************************************************
   ;   Variable Declarations
   ;***************************************************************

   dim rand16 = a
   ; b and c reserved for GB Theme
   dim _Buster_Room = d
   dim _Ghost1_Room = e
   ; f reserved for player1 frame count
   dim _Ghost2_Room = g
   dim _Ghost3_Room = h
   dim _Map_Position_x = i
   dim _Map_Position_y = j
   dim _Previous_x = k
   dim _Previous_y = l
   dim _Ghost_x = m
   dim _Ghost_y = n
   dim _Buster_Direction = o
   dim _Ghost_Direction = p
   dim _Ghost_Timer = q
   dim _Game_Timer = r
   dim _Distance_to_Ghost = s
   dim _Wand_Temperature = t
   dim _Wand_Temperature_Subpixel = u
   dim _Transition_Quick_Count = v
   dim _GB_Vol = w
   dim _GB_Ch = x
   dim _GB_Frq = y
   dim _GB_Dur = z
   
   dim _Stun_Timer = var1
   dim _Hit_Count = var2
   dim _Beam_Color = var3
   dim _Previous_Missile_x = var4
   dim _Stream_Counter = var5
   dim _Ghost_Color = var6
   dim _Score_Timer = var7
   dim _SFX_Vol = var8
   dim _SFX_Ch = var9
   dim _SFX_Frq = var10
   dim _SFX_Dur = var11
   dim _SFX_Index = var12
   

   ;***************************************************************
   ;  set bit variables
   ;***************************************************************

   dim _Bit0_Reset_Restrainer = var0 ; Restrains the reset switch for the main loop.
   dim _Bit1_Missile_Flag = var0     ; 0 = stream starting over, 1 = stream already flying
   dim _Bit2_Wand_Lock = var0        ; 0 = not locked, 1 = locked out
   dim _Bit3_Stunned_Ghost = var0    ; 0 = not stunned, 1 = stunned
   dim _Bit4_Trap_Active = var0      ; 0 = not deployed, 1 = deployed
   dim _Bit5_Left_DifficultyB = var0  ; 0 = A - PKE only 1 room away, 1 = B - PKE up to 2 rooms away
   dim _Bit6_Right_DifficultyB = var0 ; 0 = A, 1 = B
   ;***************************************************************
   ;  Converts 6 digit score to 3 sets of two digits.
   ;***************************************************************

   dim _sc1 = score     ;  The 100 thousands and 10 thousands digits are held by _sc1.
   dim _sc2 = score+1   ;  The thousands and hundreds digits are held by _sc2.
   dim _sc3 = score+2   ;  The tens and ones digits are held by _sc3.

   ;***************************************************************
   ;   Data tables and defaults
   ;***************************************************************

   data _Heat_Bar_Table
   %00000000, %00000001, %00000011, %00000111, %00001111, %00011111, %00111111, %01111111, %11111111
end

   data _Ghost_Damage_Colors
   $D4, $D4, $D6, $D6, $D8, $DA, $DC, $DE, $0E
end

   ;***************************************************************
   ;  PROGRAM START/RESTART
   ;***************************************************************

__Start_Restart

   ;***************************************************************
   ;  Reset all variables
   ;***************************************************************

   b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0
   r = 0 : s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0
   z = 0
   
   var0 = 0 : var1 = 0 : var2 = 0 : var3 = 0 : var4 = 0 : var5 = 0
   var6 = 0 : var7 = 0 : var8 = 0 : var9 = 0 : var10 = 0 : var11 = 0
   var12 = 0 : var13 = 0 : var14 = 0 : var15 = 0 : var16 = 0 : var17 = 0
   var18 = 0 : var19 = 0 : var20 = 0 : var21 = 0 : var22 = 0 : var23 = 0
   var24 = 0 : var25 = 0 : var26 = 0 : var27 = 0 : var28 = 0 : var29 = 0
   var30 = 0 : var31 = 0 : var32 = 0 : var33 = 0 : var34 = 0 : var35 = 0
   var36 = 0 : var37 = 0 : var38 = 0 : var39 = 0 : var40 = 0 : var41 = 0
   var42 = 0 : var43 = 0 : var44 = 0 : var45 = 0 : var46 = 0 : var47 = 0

   player0y = 0
   player1y = 0
   missile0y = 0
   bally = 0
   score = 0
   pfscore1 = 0
   
   ;***************************************************************
   ;   Initial Startup Value Settings
   ;***************************************************************

   if switchleftb then _Bit5_Left_DifficultyB{5} = 1 else _Bit5_Left_DifficultyB{5} = 0
   if switchrightb then _Bit6_Right_DifficultyB{6} = 1 else _Bit6_Right_DifficultyB{6} = 0

   const pfscore = 1
   AUDV0 = 0 : AUDV1 = 0
   _SFX_Dur = 1
   _SFX_Index = 0
   _GB_Dur = 1
   pfscore1 = %00101010 ; 3 lives
   pfscorecolor = $0E
   scorecolor = $0E
   missile0height = 0
   f = 10
   goto __Theme_Setup bank4

__End_Theme
   AUDV0 = 0
   AUDV1 = 0
   score = 1000
   pfscorecolor = $D4
   scorecolor = $00

      pfheights:
    4
    8
    9
    4
    17
    4
    17
    4
    9
    8
    4
end

__Start_Turn
   gosub __Ghost_Sprite bank2
   COLUBK = $02
   gosub __Spawn_Ghosts
   _Map_Position_x = 5
   _Map_Position_y = 9
   _Buster_Room = 95
   gosub __Set_Room_Layout bank3
   player1x = 78
   player1y = 83
   _Buster_Direction = 0
   f = 10
   _Wand_Temperature = 0
   _Bit0_Reset_Restrainer{0} = 1
   _Bit1_Missile_Flag{1} = 0
   _Bit2_Wand_Lock{2} = 0
   _Bit3_Stunned_Ghost{3} = 0
   _Bit4_Trap_Active{4} = 0

   _Game_Timer = 0

      player1color:
      $00;
    $00;
    $F8;
    $F8;
    $3E;
    $F8;
    $F8;
    $F8;
    $3E;
    $3E;
    $3E;
    $F0;
    $C2;
end

   _Ghost1_Room = 85

__One_Second_Pause
   _Game_Timer = _Game_Timer + 1
   COLUPF = $F0
   COLUBK = $02
   drawscreen
   if _Game_Timer < 60 then goto __One_Second_Pause
   
   ;***************************************************************
   ;  MAIN LOOP
   ;***************************************************************

__Main_Loop
   _Game_Timer = _Game_Timer + 1
   _Score_Timer = _Score_Timer - 1
   
   if _Score_Timer < 1 then scorecolor = $00
   
   if _sc1 = $00 && _sc2 = $00 && _sc3 < $01 then goto __Game_Over_Loop

   if _Bit2_Wand_Lock{2} then gosub __Play_Overheat_SFX bank2 else AUDV1 = 0

   ;***************************************************************
   ;   Colors, Missiles, Ball and Sprite Setup
   ;***************************************************************
   
   COLUPF = $F0
   COLUBK = $02
   NUSIZ0 = $30
   gosub __Buster_Sprite bank2

   ;***************************************************************
   ;   Buster Movement
   ;***************************************************************

   _Previous_x = player1x : _Previous_y = player1y
   
   if joy0fire then goto __Move_While_Streaming
   
   if !joy0fire then _Bit1_Missile_Flag{1} = 0 : _Bit3_Stunned_Ghost{3} = 0
   
   if joy0right then player1x = player1x + 1 : _Buster_Direction = 0 : f = f + 1
   if joy0left then player1x = player1x - 1 : _Buster_Direction = 8 : f = f + 1
   if joy0up then player1y = player1y - 1 : f = f + 1
   if joy0down then player1y = player1y + 1 : f = f + 1
   
   goto __Heat_Logic
   
   ;***************************************************************
   ;   Proton Stream Control
   ;***************************************************************

__Move_While_Streaming
   if joy0right then player1x = player1x + 1 : f = f + 1
   if joy0left then player1x = player1x - 1 : f = f + 1
   if joy0up then player1y = player1y - 1 : f = f + 1 :
   if joy0down then player1y = player1y + 1 : f = f + 1

__Heat_Logic
   temp1 = _Wand_Temperature / 8
   pfscore2 = _Heat_Bar_Table[temp1]
   
   if joy0fire && !_Bit2_Wand_Lock{2} then gosub __Fire_The_Wand else gosub __Cool_The_Wand

   ;***************************************************************
   ;   PKE Sound check
   ;***************************************************************

   if _Distance_to_Ghost = 0 then gosub __PKE_Chirp bank2
   if _Distance_to_Ghost = 1 then gosub __PKE_Drone bank2
   if _Distance_to_Ghost = 2 then gosub __PKE_Hum bank2
   if _Distance_to_Ghost > 2 then gosub __PKE_Off bank2

   ;***************************************************************
   ;   Overheat Check
   ;***************************************************************

   if _Wand_Temperature > 64 then _Bit2_Wand_Lock{2} = 1
   if _Wand_Temperature = 0 then _Bit2_Wand_Lock{2} = 0
   if _Bit2_Wand_Lock{2} then pfscorecolor = $46
   if !_Bit2_Wand_Lock{2} && _Wand_Temperature > 33 then pfscorecolor = $1C
   if !_Bit2_Wand_Lock{2} && _Wand_Temperature < 32 then pfscorecolor = $D4

   ;***************************************************************
   ;   Ghost Movement
   ;***************************************************************

   gosub __Move_Ghost
   
   if collision(player1, player0) then goto __Lose_A_Life

   if !collision(missile0, player0) then goto __Skip_Collision_Logic
   _Bit1_Missile_Flag{1} = 0
   _Bit3_Stunned_Ghost{3} = 1
   if _Hit_Count > 31 then goto __Skip_Collision_Logic
   _Hit_Count = _Hit_Count + 1

__Skip_Collision_Logic

   ;***************************************************************
   ;   Ghost Color Update
   ;***************************************************************

   _Ghost_Color = _Hit_Count / 4
   COLUP0 = _Ghost_Damage_Colors[_Ghost_Color]

   if _Hit_Count > 31 then gosub __Trap_The_Ghost
   gosub __Trap_Logic

   ;***************************************************************
   ;   Draw Screen
   ;***************************************************************
   
   drawscreen
   
   ;***************************************************************
   ;   Collision Check
   ;***************************************************************

   if collision(player1, playfield) then player1x = _Previous_x : player1y = _Previous_y
   
   ; REM Room Movement
   if player1x > 140 then gosub __Move_Right
   if player1x < 15 then gosub __Move_Left
   if player1y < 10 then gosub __Move_Up
   if player1y > 90 then gosub __Move_Down

   ;***************************************************************
   ;  Reset switch check/end of main loop
   ;***************************************************************

   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop
   goto __Start_Restart

   ;***************************************************************
   ;   Subroutines - Moving Rooms
   ;***************************************************************

__Move_Right
   if _Map_Position_x = 9 then return
   gosub __Transition_Out
   _Map_Position_x = _Map_Position_x + 1
   player1x = 18
   gosub __Set_Room_Layout bank3
   return
   
__Move_Left
   if _Map_Position_x = 0 then return
   gosub __Transition_Out
   _Map_Position_x = _Map_Position_x - 1
   player1x = 137
   gosub __Set_Room_Layout bank3
   return

__Move_Up
   if _Map_Position_y = 0 then return
   gosub __Transition_Out
   _Map_Position_y = _Map_Position_y - 1
   player1y = 89
   gosub __Set_Room_Layout bank3
   return
   
__Move_Down
   if _Map_Position_y = 9 then return
   gosub __Transition_Out
   _Map_Position_y = _Map_Position_y + 1
   player1y = 11
   gosub __Set_Room_Layout bank3
   return
   
__Transition_Out
   pfclear
   COLUBK = $02
   player0y = 0
   _Hit_Count = 0
   _Stun_Timer = 0
   _Transition_Quick_Count = 4
__Fade_Loop
   drawscreen
   _Transition_Quick_Count = _Transition_Quick_Count - 1
   if _Transition_Quick_Count > 0 then goto __Fade_Loop
   return

   ;***************************************************************
   ;   Subroutines - Firing the Wand
   ;***************************************************************
   
__Fire_The_Wand
   _Wand_Temperature_Subpixel = _Wand_Temperature_Subpixel + 1
   if _Wand_Temperature_Subpixel > 3 then _Wand_Temperature_Subpixel = 0 : _Wand_Temperature = _Wand_Temperature + 1
   if !_Bit1_Missile_Flag{1} then gosub __Missile_Start
   if _Bit1_Missile_Flag{1} then gosub __Missile_Moving
   AUDV1 = 4 : AUDF1 = 30 : AUDC1 = 8 ; Wand sound
   return
   
__Missile_Start
   missile0y = player1y - 5
   if _Buster_Direction = 0 then missile0x = player1x + 4
   if _Buster_Direction = 8 then missile0x = player1x - 4
   _Bit1_Missile_Flag{1} = 1
   _Stream_Counter = 0
   return

__Missile_Moving
   _Stream_Counter = _Stream_Counter + 1
   _Previous_Missile_x = missile0x
   if _Buster_Direction = 0 then missile0x = missile0x + 8
   if _Buster_Direction = 8 then missile0x = missile0x - 8
   if collision(missile0, playfield) then _Bit1_Missile_Flag{1} = 0 : missile0x = _Previous_Missile_x : score = score - 100 : scorecolor = $42 : _Score_Timer = 60
   if (_Stream_Counter & 1) = 0 then missile0y = missile0y + 1 else missile0y = missile0y - 1
   if missile0x < 15 then _Bit1_Missile_Flag{1} = 0
   if missile0x > 140 then _Bit1_Missile_Flag{1} = 0
   return
 
__Cool_The_Wand
   missile0y = 0 ; Hide the beam
   if _Wand_Temperature = 0 then return
   if _Wand_Temperature_Subpixel = 0 then _Wand_Temperature_Subpixel = 5 : _Wand_Temperature = _Wand_Temperature - 1
   _Wand_Temperature_Subpixel = _Wand_Temperature_Subpixel - 1
   return
   
   ;***************************************************************
   ;   Subroutines - Trapping the Ghost
   ;***************************************************************   

__Trap_The_Ghost
   _Bit3_Stunned_Ghost{3} = 1
   if _Bit4_Trap_Active{4} then return ; Prevent firing again if already sliding
   
   CTRLPF = $31
   ballheight = 2
   
   if _Buster_Direction = 0 then ballx = player1x + 4
   if _Buster_Direction = 8 then ballx = player1x - 4
   bally = player1y + 2
   
   _Bit4_Trap_Active{4} = 1 
   
   return

__Trap_Logic
   if !_Bit4_Trap_Active{4} then return

   if ballx < player0x then ballx = ballx + 1
   if ballx > player0x then ballx = ballx - 1
   if bally < player0y then bally = bally + 1
   if bally > player0y then bally = bally - 1

   if collision(ball, player0) then gosub __Ghost_Caught
   return

__Ghost_Caught
   _Ghost1_Room = 100
   _Ghost2_Room = 100
   _Ghost3_Room = 100
   missile0y = 0
   AUDV0 = 0 : AUDV1 = 0
   _Transition_Quick_Count = 60
   COLUBK = $0E
   COLUPF = $0E
   _SFX_Dur = 1
   _SFX_Index = 0
   score = score + 5000 : scorecolor = $C4 : _Score_Timer = 60
Trap_Loop
   gosub __Play_Trap_SFX bank2
   drawscreen
   COLUBK = $02
   COLUPF = $F0
   _Transition_Quick_Count = _Transition_Quick_Count - 1
   if _Transition_Quick_Count > 0 then goto Trap_Loop
   player0y = 0
   bally = 0
   _Bit4_Trap_Active{4} = 0
   
   _Hit_Count = 0
   gosub __Spawn_Ghosts
   gosub __Set_Room_Layout bank3
   return

   ;***************************************************************
   ;   Subroutines - Ghost Movement in Room
   ;***************************************************************

__Move_Ghost
   if _Ghost1_Room <> _Buster_Room && _Ghost2_Room <> _Buster_Room && _Ghost3_Room <> _Buster_Room then return
   if _Game_Timer & 1 then return
   if !_Bit3_Stunned_Ghost{3} then goto __Not_Stunned
   _Stun_Timer = _Stun_Timer + 1
   if _Stun_Timer > 30 then _Bit3_Stunned_Ghost{3} = 0 : _Stun_Timer = 0
   return

__Not_Stunned
   if _Bit2_Wand_Lock{2} then goto __Choose_To_Chase

   if _Ghost_Timer > 0 then goto __Keep_Moving

   ; --- New direction decision ---
   ; Longer base timer = more committed movement, less jitter
   ; rand & 15 gives 0-15, + 10 gives 10-25 ticks
   _Ghost_Timer = (rand & 15) + 10

   temp5 = player1x - _Ghost_x : if _Ghost_x > player1x then temp5 = _Ghost_x - player1x
   temp6 = player1y - _Ghost_y : if _Ghost_y > player1y then temp6 = _Ghost_y - player1y

   ; --- Graduated proximity: tight range flees cardinally,
   ;     mid range can flee diagonally, far range wanders ---
   if temp5 > 30 && temp6 > 30 then goto __Pick_Random_Direction
   if temp5 < 12 && temp6 < 12 then goto __Flee_Diagonal
   if (rand & 1) then goto __Choose_To_Flee_X else goto __Choose_To_Flee_Y

__Choose_To_Flee_X
   if player1x > _Ghost_x then _Ghost_Direction = 2 else _Ghost_Direction = 3
   goto __Keep_Moving

__Choose_To_Flee_Y
   if player1y > _Ghost_y then _Ghost_Direction = 0 else _Ghost_Direction = 1
   goto __Keep_Moving

__Flee_Diagonal
   ; Very close: flee diagonally — feels panicked and organic
   if player1x > _Ghost_x && player1y > _Ghost_y then _Ghost_Direction = 4 : goto __Keep_Moving  ; NW
   if player1x > _Ghost_x && player1y < _Ghost_y then _Ghost_Direction = 5 : goto __Keep_Moving  ; SW
   if player1x < _Ghost_x && player1y > _Ghost_y then _Ghost_Direction = 6 : goto __Keep_Moving  ; NE
   _Ghost_Direction = 7                                                                            ; SE
   goto __Keep_Moving

__Pick_Random_Direction
   ; Bias toward cardinal directions (0-3) — diagonals feel strange when wandering
   ; rand & 7 still gives 0-7, but reroll diagonals sometimes
   _Ghost_Direction = (rand & 7)
   if _Ghost_Direction > 3 && (rand & 3) then _Ghost_Direction = (rand & 3)
   goto __Keep_Moving

__Choose_To_Chase
   if _Ghost_Timer > 0 then goto __Keep_Moving

   ; Longer chase timer too — ghost commits to a path instead of stuttering
   _Ghost_Timer = (rand & 7) + 12

   temp5 = player1x - _Ghost_x : if _Ghost_x > player1x then temp5 = _Ghost_x - player1x
   temp6 = player1y - _Ghost_y : if _Ghost_y > player1y then temp6 = _Ghost_y - player1y

   ; Close on both axes: chase diagonally — more threatening
   if temp5 < 20 && temp6 < 20 then goto __Chase_Diagonal

   ; Far on both axes: bias toward closing the larger gap
   if temp5 > temp6 then goto __Choose_To_Chase_X else goto __Choose_To_Chase_Y

__Choose_To_Chase_X
   if player1x > _Ghost_x then _Ghost_Direction = 3 else _Ghost_Direction = 2
   goto __Keep_Moving

__Choose_To_Chase_Y
   if player1y > _Ghost_y then _Ghost_Direction = 1 else _Ghost_Direction = 0
   goto __Keep_Moving

__Chase_Diagonal
   ; Close range chase: diagonal pursuit feels relentless
   if player1x > _Ghost_x && player1y > _Ghost_y then _Ghost_Direction = 7 : goto __Keep_Moving  ; SE
   if player1x > _Ghost_x && player1y < _Ghost_y then _Ghost_Direction = 6 : goto __Keep_Moving  ; NE  (corrected: NE moves +x -y)
   if player1x < _Ghost_x && player1y > _Ghost_y then _Ghost_Direction = 5 : goto __Keep_Moving  ; SW
   _Ghost_Direction = 4                                                                            ; NW
   goto __Keep_Moving

__Keep_Moving
   _Ghost_Timer = _Ghost_Timer - 1
   if _Ghost_Direction = 0 then _Ghost_y = _Ghost_y - 1 : goto __Bounce_Out_Of_Corner
   if _Ghost_Direction = 1 then _Ghost_y = _Ghost_y + 1 : goto __Bounce_Out_Of_Corner
   if _Ghost_Direction = 2 then _Ghost_x = _Ghost_x - 1 : goto __Bounce_Out_Of_Corner
   if _Ghost_Direction = 3 then _Ghost_x = _Ghost_x + 1 : goto __Bounce_Out_Of_Corner
   if _Ghost_Direction = 4 then _Ghost_x = _Ghost_x - 1 : _Ghost_y = _Ghost_y - 1 : goto __Bounce_Out_Of_Corner
   if _Ghost_Direction = 5 then _Ghost_x = _Ghost_x - 1 : _Ghost_y = _Ghost_y + 1 : goto __Bounce_Out_Of_Corner
   if _Ghost_Direction = 6 then _Ghost_x = _Ghost_x + 1 : _Ghost_y = _Ghost_y - 1 : goto __Bounce_Out_Of_Corner
   if _Ghost_Direction = 7 then _Ghost_x = _Ghost_x + 1 : _Ghost_y = _Ghost_y + 1 : goto __Bounce_Out_Of_Corner

__Bounce_Out_Of_Corner
   if _Ghost_x < 20 then _Ghost_x = 20 : _Ghost_Direction = 3 : _Ghost_Timer = 20
   if _Ghost_x > 140 then _Ghost_x = 140 : _Ghost_Direction = 2 : _Ghost_Timer = 20
   if _Ghost_y < 15 then _Ghost_y = 15 : _Ghost_Direction = 1 : _Ghost_Timer = 20
   if _Ghost_y > 89 then _Ghost_y = 89 : _Ghost_Direction = 0 : _Ghost_Timer = 20
   player0x = _Ghost_x : player0y = _Ghost_y
   return
   
   ;***************************************************************
   ;   Subroutines - Life Management
   ;***************************************************************
   
__Lose_A_Life
   player0y = 0
   pfscore1 = pfscore1 / 4
   COLUBK = $D6
   player1color:
    $D0;
    $D0;
    $D8;
    $D8;
    $DE;
    $D8;
    $D8;
    $D8;
    $DE;
    $DE;
    $DE;
    $D0
    $D2;
end
   _Transition_Quick_Count = 60

   AUDC0 = 3
   AUDF0 = 10

__Slimed_Loop
   drawscreen
   _Transition_Quick_Count = _Transition_Quick_Count - 1
   AUDV0 = _Transition_Quick_Count / 4
   if (_Transition_Quick_Count & 3) = 0 then AUDF0 = AUDF0 + 1
   if _Transition_Quick_Count > 0 then goto __Slimed_Loop
   AUDV0 = 0

   if pfscore1 >= %00000010 then goto __Start_Turn

__Game_Over_Loop
   AUDV0 = 0 : AUDV1 = 0
   pfscore2 = 0
   missile0y = 0
   player1x = 0
   player1y = 0

   _Game_Timer = _Game_Timer + 1
   if _Game_Timer > 180 then COLUBK = rand : COLUPF = rand : _Game_Timer = 0
   gosub __Random_Ghost_Move

   drawscreen

   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Game_Over_Loop
   if _Bit0_Reset_Restrainer{0} then goto __Game_Over_Loop
   goto __Start_Restart

__Random_Ghost_Move
   if _Ghost_Timer > 0 then goto _Random_Keep_Moving

   _Ghost_Timer = (rand & 15) + 20
   _Ghost_Direction = (rand & 7)
   
_Random_Keep_Moving
   _Ghost_Timer = _Ghost_Timer - 1
   if _Ghost_Direction = 0 then _Ghost_y = _Ghost_y - 1 ; north
   if _Ghost_Direction = 1 then _Ghost_y = _Ghost_y + 1 ; south
   if _Ghost_Direction = 2 then _Ghost_x = _Ghost_x - 1 ; west
   if _Ghost_Direction = 3 then _Ghost_x = _Ghost_x + 1 ; east
   if _Ghost_Direction = 4 then _Ghost_x = _Ghost_x - 1 : _Ghost_y = _Ghost_y - 1 ; northwest
   if _Ghost_Direction = 5 then _Ghost_x = _Ghost_x - 1 : _Ghost_y = _Ghost_y + 1 ; southwest
   if _Ghost_Direction = 6 then _Ghost_x = _Ghost_x + 1 : _Ghost_y = _Ghost_y - 1 ; northeast
   if _Ghost_Direction = 7 then _Ghost_x = _Ghost_x + 1 : _Ghost_y = _Ghost_y + 1 ; southeast
   
   if _Ghost_y >  89 then _Ghost_y =  89 : _Ghost_Direction = 0 : _Ghost_Timer = 20
   if _Ghost_y <  15 then _Ghost_y =  15 : _Ghost_Direction = 1 : _Ghost_Timer = 20
   if _Ghost_x > 140 then _Ghost_x = 140 : _Ghost_Direction = 2 : _Ghost_Timer = 20
   if _Ghost_x <  20 then _Ghost_x =  20 : _Ghost_Direction = 3 : _Ghost_Timer = 20
   
   player0x = _Ghost_x : player0y = _Ghost_y
   
   return

   ;***************************************************************
   ;   Subroutines - Spawning Ghosts
   ;***************************************************************

__Spawn_Ghosts
   _Hit_Count = 0
   _Bit3_Stunned_Ghost{3} = 0
__Roll_Ghost1
   _Ghost1_Room = rand
   if _Ghost1_Room > 99 then goto __Roll_Ghost1
   if _Ghost1_Room = _Buster_Room then goto __Roll_Ghost1
__Roll_Ghost2
   _Ghost2_Room = rand
   if _Ghost2_Room > 99 then goto __Roll_Ghost2
   if _Ghost2_Room = _Buster_Room then goto __Roll_Ghost2
   if _Ghost2_Room = _Ghost1_Room then goto __Roll_Ghost2
__Roll_Ghost3
   _Ghost3_Room = rand
   if _Ghost3_Room > 99 then goto __Roll_Ghost3
   if _Ghost3_Room = _Buster_Room then goto __Roll_Ghost3
   if _Ghost3_Room = _Ghost1_Room then goto __Roll_Ghost3
   if _Ghost3_Room = _Ghost2_Room then goto __Roll_Ghost3
   return

   ;***************************************************************
   ;***************************************************************     
   bank 2
   ;***************************************************************
   ;***************************************************************

   ;***************************************************************
   ;   Subroutines - Sprites
   ;***************************************************************
   
__Buster_Sprite
   REFP1 = _Buster_Direction
   if f >= 10 && f < 15 then player1:
    %00111100
    %00101000
    %00101000
    %00111000
    %01000100
    %01111100
    %01111100
    %00111000
    %00010000
    %00011000
    %00011000
    %00011000
    %00001000
end
   player1color:
    $00;
    $00;
    $F8;
    $F8;
    $3E;
    $F8;
    $F8;
    $F8;
    $3E;
    $3E;
    $3E;
    $F0;
    $C2;
end
   if f >= 15 && f < 20 then player1:
    %00110000
    %00101100
    %00101000
    %00111000
    %01000100
    %01111100
    %01111100
    %00111000
    %00010000
    %00011000
    %00011000
    %00011000
    %00001000
end
   if f >= 20 && f < 25 then player1:
    %00111100
    %00101000
    %00101000
    %00111000
    %01000100
    %01111100
    %01111100
    %00111000
    %00010000
    %00011000
    %00011000
    %00011000
    %00001000
end
   if f >= 25 then player1:
    %00001100
    %00111000
    %00101000
    %00111000
    %01000100
    %01111100
    %01111100
    %00111000
    %00010000
    %00011000
    %00011000
    %00011000
    %00001000
end
   if f >= 30 then f = 10
   return
   
__Ghost_Sprite
   player0:
    %10101010
    %11111111
    %11111111
    %11111111
    %11011011
    %01111110
    %00111100
end
   return

   ;***************************************************************
   ;   Subroutines - Audio
   ;***************************************************************

__PKE_Chirp
   if (_Game_Timer & 7) = 0 then AUDV0 = 3 : AUDF0 = 20 : AUDC0 = 12
   if (_Game_Timer & 7) = 3 then AUDV0 = 0
   return
   
__PKE_Drone
   if (_Game_Timer & 31) = 0 then AUDV0 = 2 : AUDF0 = 20 : AUDC0 = 12
   if (_Game_Timer & 31) = 5 then AUDV0 = 0
   return
   
__PKE_Hum
   if !_Bit5_Left_DifficultyB{5} then return
   if (_Game_Timer & 63) = 0 then AUDV0 = 1 : AUDF0 = 20 : AUDC0 = 12
   if (_Game_Timer & 63) = 15 then AUDV0 = 0
   return

__PKE_Off
   AUDV0 = 0
   return

 data trap_sfx
   14,4,22,2
   14,4,21,2
   14,4,21,2
   14,4,18,2
   14,4,14,2
   14,4,12,2
   14,4,14,2
   14,4,18,2
   10,4,21,2
   8,4,21,2
   255
end

__Play_Trap_SFX
   _SFX_Dur = _SFX_Dur - 1
   if _SFX_Dur > 0 then return

   _SFX_Vol = trap_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1
   if _SFX_Vol = 255 then _SFX_Dur = 1 : _SFX_Index = 0 : AUDV0 = 0 : return

   _SFX_Ch = trap_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1
   _SFX_Frq = trap_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1

   AUDV1 = _SFX_Vol
   AUDC1 = _SFX_Ch
   AUDF1 = _SFX_Frq

   _SFX_Dur = trap_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1
   
   return

 data overheat_sfx
   4,4,27
   1
   10,4,28
   1
   15,4,28
   1
   15,4,27
   1
   15,4,28
   1
   15,4,28
   1
   15,4,25
   1
   15,4,28
   1
   15,4,28
   1
   15,4,28
   1
   9,4,28
   1
   15,4,28
   1
   15,4,28
   1
   15,4,28
   1
   9,4,28
   1
   15,4,28
   1
   15,4,28
   1
   15,4,28
   1
   9,4,28
   1
   15,4,28
   1
   15,4,28
   1
   8,4,29
   1
   2,4,29
   1
   1,4,29
   1
   0,4,29
   1
   2,4,29
   1
   1,4,29
   1
   255
end

__Play_Overheat_SFX
   _SFX_Dur = _SFX_Dur - 1
   if _SFX_Dur > 0 then return

   _SFX_Vol = overheat_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1
   if _SFX_Vol = 255 then _SFX_Dur = 1 : _SFX_Index = 0 : AUDV0 = 0 : return

   _SFX_Ch = overheat_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1
   _SFX_Frq = overheat_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1

   AUDV1 = _SFX_Vol
   AUDC1 = _SFX_Ch
   AUDF1 = _SFX_Frq

   _SFX_Dur = overheat_sfx[_SFX_Index] : _SFX_Index = _SFX_Index + 1
   
   return

   ;***************************************************************
   ;***************************************************************     
   bank 3
   ;***************************************************************
   ;***************************************************************

   ;***************************************************************
   ;   Subroutines - Room Setup/Layout
   ;***************************************************************

   data my_world_map
     1,  7,  7,  7,  7,  7,  7,  7,  7, 4
     2, 11, 13, 11, 12, 13, 13, 12, 11, 5
     2, 12, 12, 13, 11, 12, 11, 13, 13, 5
     2, 13, 11, 12, 13, 11, 12, 11, 12, 5
     2, 12, 13, 11, 11, 13, 12, 11, 13, 5
     2, 11, 11, 12, 10, 12, 13, 12, 11, 5
     2, 13, 12, 13, 13, 11, 11, 13, 12, 5
     2, 11, 13, 11, 12, 13, 12, 11, 13, 5
     2, 13, 11, 12, 11, 12, 13, 12, 11, 5
     3,  8,  8,  8,  8,  9,  8,  8,  8, 6
end

__Set_Room_Layout
   _Buster_Room = _Map_Position_y * 10 + _Map_Position_x
   temp2 = my_world_map[_Buster_Room]
   if temp2 =  1 then goto __Layout_Room_1
   if temp2 =  2 then goto __Layout_Room_2
   if temp2 =  3 then goto __Layout_Room_3
   if temp2 =  4 then goto __Layout_Room_4
   if temp2 =  5 then goto __Layout_Room_5
   if temp2 =  6 then goto __Layout_Room_6
   if temp2 =  7 then goto __Layout_Room_7
   if temp2 =  8 then goto __Layout_Room_8
   if temp2 =  9 then goto __Layout_Room_9
   if temp2 = 10 then goto __Layout_Room_10
   if temp2 = 11 then goto __Layout_Room_11
   if temp2 = 12 then goto __Layout_Room_12
   if temp2 = 13 then goto __Layout_Room_13

__Check_Room_For_Ghosts
   player0y = 0
   if _Ghost1_Room = _Buster_Room then gosub __Draw_Ghost
   if _Ghost2_Room = _Buster_Room then gosub __Draw_Ghost
   if _Ghost3_Room = _Buster_Room then gosub __Draw_Ghost
   
   _Distance_to_Ghost = 255
   temp5 = _Ghost1_Room
   gosub __Calculate_Distance_to_Closest_Ghost
   if temp4 < _Distance_to_Ghost then _Distance_to_Ghost = temp4

   temp5 = _Ghost2_Room
   gosub __Calculate_Distance_to_Closest_Ghost
   if temp4 < _Distance_to_Ghost then _Distance_to_Ghost = temp4

   temp5 = _Ghost3_Room 
   gosub __Calculate_Distance_to_Closest_Ghost
   if temp4 < _Distance_to_Ghost then _Distance_to_Ghost = temp4
   return

__Calculate_Distance_to_Closest_Ghost
   temp3 = 0
   temp2 = temp5
   
__Extract_Loop
   if temp2 < 10 then goto __Absolute_Difference
   temp2 = temp2 - 10
   temp3 = temp3 + 1
   goto __Extract_Loop

__Absolute_Difference
   if _Map_Position_x > temp2 then temp2 = _Map_Position_x - temp2 else temp2 = temp2 - _Map_Position_x
   if _Map_Position_y > temp3 then temp3 = _Map_Position_y - temp3 else temp3 = temp3 - _Map_Position_y
   
   temp4 = temp2
   if temp3 > temp2 then temp4 = temp3
   return

__Draw_Ghost
   if player0y <> 0 then goto __Continue_Draw_Ghost
   _Ghost_x = (rand/2) + 15
   _Ghost_y = (rand/4) + 15
__Continue_Draw_Ghost
   player0x = _Ghost_x : player0y = _Ghost_y
   return

   ;***************************************************************
   ;   Subroutines - Playfield Layouts
   ;***************************************************************

__Layout_Room_1
   playfield:
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    X...............................
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts
   
__Layout_Room_2
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    X...............................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts

__Layout_Room_3
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    X...............................
    X...............................
    X.................XXXXXXXXXXXXXX
    X...............................
    X.................XXXXXXXXXXXXXX
    X...............................
    X.................XXXXXXXXXXXXXX
    X...............................
    X...............................
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts
   
__Layout_Room_4
   playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   ...............................X
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
   ...............................X
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts
   
__Layout_Room_5
   playfield:
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
   ...............................X
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
   ...............................X
   ...............................X
   XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts
   
__Layout_Room_6
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ...............................X
    ...............................X
    XXXXXXXXXXXXXX.................X
    ...............................X
    XXXXXXXXXXXXXX.................X
    ...............................X
    XXXXXXXXXXXXXX.................X
    ...............................X
    ...............................X
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts

__Layout_Room_7
   playfield:
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts

__Layout_Room_8
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts

__Layout_Room_9
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ....X......................X....
    ....X......................X....
    XXXXX......................XXXXX
    ....X....X............X....X....
    XXXXX.....XXXXXXXXXXXX.....XXXXX
    ....X......................X....
    XXXXX......................XXXXX
    ....X......................X....
    ....X......................X....
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts 
   
__Layout_Room_10
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    X..............................X
    ................................
    X..............................X
    ................................
    X..............................X
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts

__Layout_Room_11
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXXXXXXXXXXXX....XXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXX....XXXXXXXXXXXXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts
   
__Layout_Room_12
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    XXXX....XXXXXXXXXXXXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXXXXXXXXXXXX....XXXX
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts

__Layout_Room_13
   playfield:
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
    ................................
    ................................
    XXXXXXXXXXXXXX....XXXXXXXXXXXXXX
end
   goto __Check_Room_For_Ghosts


   ;***************************************************************
   ;***************************************************************     
   bank 4
   ;***************************************************************
   ;***************************************************************

   ;***************************************************************
   ;   Subroutines - Startup Screen
   ;***************************************************************

__Theme_Setup
   sdata GhostbustersTheme = b
    0,0,0,30
    4,4,14,7
    0,0,0,1
    4,4,14,8
    4,4,11,15
    4,4,14,15
    4,4,12,15
    4,4,16,15
    0,0,0,30
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,8
    4,4,16,15
    4,4,14,15
    0,0,0,30
    4,4,14,7
    0,0,0,1
    4,4,14,8
    4,4,11,15
    4,4,14,15
    4,4,12,15
    4,4,16,15
    0,0,0,30
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,8
    4,4,16,15
    4,4,13,15
    4,4,14,15  
    0,0,0,15
    4,4,14,7   ; If there's something strange...
    0,0,0,1
    4,4,14,8
    4,4,12,15
    4,4,14,15
    4,4,12,30
    0,0,0,30
    0,0,0,30
    4,4,14,8
    4,4,16,8
    4,4,14,14
    0,0,0,1
    4,4,14,14
    0,0,0,1
    4,4,14,30
    0,0,0,30
    0,0,0,30
    4,4,11,8
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,30
    0,0,0,30
    4,4,10,29
    0,0,0,1
    4,4,10,29
    0,0,0,1
    4,4,10,15
    4,4,0,30
    4,4,0,30
    4,4,0,15
    4,4,14,7       ; If there's something weird
    0,0,0,1
    4,4,14,8
    4,4,12,15
    4,4,14,15
    4,4,12,30
    0,0,0,30
    0,0,0,30
    4,4,14,8
    4,4,16,8
    4,4,14,14
    0,0,0,1
    4,4,14,14
    0,0,0,1
    4,4,14,30
    0,0,0,30
    0,0,0,30
    4,4,11,8
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,7
    0,0,0,1
    4,4,14,30
    0,0,0,30
    4,4,10,29
    0,0,0,1
    4,4,10,29
    0,0,0,1
    4,4,10,15
    4,4,0,30
    4,4,0,30
    4,4,0,15    
    4,4,12,15  ; doo-do
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,12,15
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,12,15
    4,4,14,15
    4,4,12,8
    4,4,13,8
    4,4,14,15
    0,0,0,1
    4,4,12,15  ; doo-do 2
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,12,15
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,12,15
    4,4,14,15
    4,4,12,8
    4,4,13,8
    4,4,14,15
    0,0,0,1
    4,4,12,15 ; doo-do 3
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,12,15
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,12,15
    4,4,14,15
    4,4,12,8
    4,4,13,8
    4,4,14,15
    4,4,12,15 ; doo-do 4
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,12,15
    4,4,14,15
    0,0,0,15
    4,4,12,15
    4,4,12,15
    4,4,14,15
    4,4,10,30
    0,0,0,60
    255
end

__Game_Credits
   pfheights:
    8
    8
    8
    8
    8
    8
    8
    8
    8
    8
    8
end
   pfscorecolor = $00
   scorecolor = $00

   _Game_Timer = _Game_Timer + 1
   if _Game_Timer > 120 then goto __Startup_Loop
   
   gosub __Credits_Screen_1
   gosub __Play_Theme
   
   drawscreen

   if joy0fire then goto __End_Title
   if _GB_Vol = 255 then goto __End_Title

   _Ghost_x = 0
   _Ghost_Direction = 1

   goto __Game_Credits


__Startup_Loop
   pfscorecolor = $02
   scorecolor = $02
   COLUP0 = $0E 

   gosub __Title_Screen

   gosub __Play_Theme

   f = f + 1   

   if (_Ghost_Direction & 1) then gosub __Left_to_Right else gosub __Right_to_Left
   
   drawscreen
   
   if joy0fire then goto __End_Title
   if _GB_Vol = 255 then goto __End_Title

   goto __Startup_Loop

__Title_Screen
   playfield:
    ................................
    ................................
    ....XXXX.....X...X....XXXXX.....
    ....X...X....X..X.....X.........
    ....XXXX.....XXX......XXX.......
    ....X........X..X.....X.........
    ....X...X....X...X.X..XXXXX.X...
    ................................    
    ................................
    ................................
    ................................
end
   COLUBK = $02
   COLUPF = $46
   return

__Play_Theme
   _GB_Dur = _GB_Dur - 1
   if _GB_Dur > 0 then return

   _GB_Vol = sread(GhostbustersTheme)
   if _GB_Vol = 255 then return
   _GB_Ch = sread(GhostbustersTheme)
   _GB_Frq = sread(GhostbustersTheme)

   AUDV0 = _GB_Vol
   AUDC0 = _GB_Ch
   AUDF0 = _GB_Frq

   _GB_Dur = sread(GhostbustersTheme)   
   return

__End_Title
   AUDV0 = 0
   score = 1000
   goto __End_Theme bank1


__Credits_Screen_1
      playfield:
    ................................
    .........XX.XX..X.X..X..........
    ........X...XXX.X.X.X.X.........
    ........X.X.X.X.X.X.XXX.........
    .........XX.XXX..X..X.X.........
    ................................
    .XX......................X......
    .X.X.XX.XXX..XX.XXX.XX..XXX..XX.
    .XX..X..XX...X..XX..X.X..X...X..
    .X...X..XXX.XX..XXX.X.X..X..XX..
    ................................
end     
   COLUBK = $00
   COLUPF = $86
   return

__Left_to_Right
   gosub __Ghost_Sprite bank2
   _Ghost_x = _Ghost_x + 1

   player0x = _Ghost_x
   if _Ghost_x < 150 then player0y = 78 else player0y = 0
   
   gosub __Buster_Sprite bank2
   REFP1 = 0

   _Previous_x = _Ghost_x - 30
   player1x = _Previous_x
   if _Previous_x < 150 then player1y = 80 else player1y = 0

   if _Ghost_x > 200 then _Ghost_Direction = 0 : _Previous_x = 175
   return



__Right_to_Left
   gosub __Buster_Sprite bank2
   REFP1 = 8

   _Previous_x = _Previous_x - 1
   player1x = _Previous_x
   if _Previous_x < 150 then player1y = 80 else player1y = 0

   gosub __Ghost_Sprite bank2

   _Ghost_x = _Previous_x - 30
   player0x = _Ghost_x
   if _Ghost_x < 150 then player0y = 78 else player0y = 0
   
   if _Previous_x > 175 && _Previous_x < 220 then _Ghost_Direction = 1 : _Ghost_x = 0

   return
