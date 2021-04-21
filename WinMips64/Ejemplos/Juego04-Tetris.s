.data

CONTROL:    .word32 0x10000

PALETTECLR: .word32  0x00000000, 0x00808080, 0x99ffff, 0x000080ff, 0x3333ff, 0x0033cc33, 0x00ff8000, 0xcc66cc, 0x00ffcc33
BG_COLOR:   .word32 0x00000000

CONTAINER_H: .byte  24  ;
CONTAINER_W: .byte  10

KEY_MOV_LFT: .byte 97  ; tecla a
KEY_MOV_RGT: .byte 100 ; tecla d
KEY_ROT_LFT: .byte 113 ; tecla q
KEY_ROT_RGT: .byte 101 ; tecla e
KEY_MOV_DWN: .byte 115 ; tecla s
KEY_START_GAME: .byte 32 ; tecla ESC
KEY_END_GAME: .byte 27 ; tecla ESC

DELAY1: .word  1000
DELAY_GAME_MOV: .word  100  


TEXT_SCREEN:  .ascii "    TETRIS V1.0 " 
TEXT_SCREEN2: .ascii "  Presione espacio"
END_S:  .byte 0

; es mu dificil manipular la memoria para almacenar una imagen.
; Para simplificar el ancho debe ser multiplo de 8
TETRIS_BMP:  .byte 32, 7  ; alineado de 8 bytes, 2 bytes pero ocupan 8
TETRIS_BMP1: .byte 0,0,0,0,0, 0, 0,0,0,0, 0, 0,0,0,0,0, 0, 0,0,0,0, 0, 0,0,0, 0, 0,0,0,0,0, 0
TETRIS_BMP2: .byte 2,2,2,2,2, 0, 3,3,3,3, 0, 4,4,4,4,4, 0, 5,5,5,0, 0, 6,6,6, 0, 7,7,7,7,7, 0
TETRIS_BMP3: .byte 0,0,2,0,0, 0, 3,0,0,0, 0, 0,0,4,0,0, 0, 5,0,0,5, 0, 0,6,0, 0, 7,0,0,0,0, 0
TETRIS_BMP4: .byte 0,0,2,0,0, 0, 3,3,3,0, 0, 0,0,4,0,0, 0, 5,5,5,0, 0, 0,6,0, 0, 7,7,7,7,7, 0
TETRIS_BMP5: .byte 0,0,2,0,0, 0, 3,0,0,0, 0, 0,0,4,0,0, 0, 0,5,0,0, 0, 0,6,0, 0, 0,0,0,0,7, 0
TETRIS_BMP6: .byte 0,0,2,0,0, 0, 3,3,3,3, 0, 0,0,4,0,0, 0, 0,0,5,0, 0, 0,6,0, 0, 7,7,7,7,7, 0
TETRIS_BMP7: .byte 0,0,0,0,0, 0, 0,0,0,0, 0, 0,0,0,0,0, 0, 0,0,0,0, 0, 6,6,6, 0, 0,0,0,0,0, 0

; figuras
; escructura de la figura, cada campo es de 1 byte:  tam matriz(0), despl paleta de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
FIG_I:  .byte 4, 32,  5,5,  0,2,  1,2,  2,2,  3,2
FIG_J:  .byte 3, 24,  5,5,  0,1,  1,1,  2,1,  2,0
FIG_L:  .byte 3, 12,  5,5,  0,1,  1,1,  2,1,  0,0
FIG_O:  .byte 2,  8,  5,5,  0,0,  1,1,  0,1,  1,0
FIG_S:  .byte 3, 20,  5,5,  2,0,  2,1,  1,1,  1,2
FIG_T:  .byte 3, 28,  5,5,  0,1,  1,1,  2,1,  1,2
FIG_Z:  .byte 3, 16,  5,5,  0,0,  0,1,  1,1,  1,2
figCur: .byte 0,  0,  0,0,  0,0,  0,0,  0,0,  0,0
figAux: .byte 0,  0,  0,0,  0,0,  0,0,  0,0,  0,0




Container: .space 400   ; 400 = 16 x 25 cantidad de memoria para almacenar una grilla 10x24 (tiene bordes laterales e inferior)
; En total son 400 bytes para alinear y hacer mas eficiente el acceso a la matriz del contenedor
; en realidad el tamanio es de 10x24. Por las paredes laterales e inferior es de 12x25 y para acceso eficiente de matriz queda 16x25





.code
                daddi   $sp, $0, 0x400
    
                jal     IntroScreen

    
                daddi   $a0, $0, Container
                jal     ClearContainer
                
                ;daddi   $a0, $0, figAux
                ;jal     GenerateFigure
                
                ;daddi   $a0, $0, Container
                ;daddi   $a1, $0, figAux
                ;jal     FitFigureInContainer    ; $v0=1 si entra figura
    
                jal     IntroScreen
                lwu     $a0, BG_COLOR($0)
                
                jal     InitGraphics  
                
                jal     DrawGameScreen

MainCreateFig:  daddi   $a0, $0, figCur
                jal     GenerateFigure
                daddi   $s1, $0, 0              ; veces que la figura cayo
                daddi   $a0, $0, figCur         ; puntero de figura a dibujar
                lbu     $a1, 1($a0)             ; indice de color
                lwu     $a1, PALETTECLR($a1)    ; color
                jal     DrawFigure
MainFigDown:    ld      $s0, DELAY_GAME_MOV($0) ; 
MainLoop:       ld      $a0, DELAY1($0)
                jal     DelayCycles             ; espera
                jal     KeyPressed
                bnez    $v0, MainKeypressed
MainKeyBack:    daddi   $s0, $s0, -1
                bnez    $s0, MainLoop
                ; fuerza movimiento de figura hacia abajo
                daddi   $a0, $0, figCur
                daddi   $a1, $0, figAux
                jal     MoveFigureDown  
                daddi   $a0, $0, Container
                daddi   $a1, $0, figAux
                jal     FitFigureInContainer    ; $v0=1 si entra figura

                beqz    $v0, MainDropFig
                ; hay que actualizar figura segun movimiento
                daddi   $s1, $s1, 1             ; cuenta movimiento hacia abajo
                daddi   $a0, $0, figAux         ; figura modificada
                daddi   $a1, $0, figCur         ; figura actual
                jal     UpdateFigure
                j       MainFigDown
MainDropFig:    ; la figura no pudo bajar, se la bloquea y selecciona otra
                daddi   $a0, $0, Container
                daddi   $a1, $0, figCur
                jal     FigureToContainer
                daddi   $a0, $0, Container
                daddi   $a1, $0, figCur
                lb      $a1, 3($a1)
                slti    $t0, $a1, 1
                beqz    $t0, MainCompactOk ; por forma de funcionar de fig, puede ser la linea 0, cuando debe ser 1
                daddi   $a1, $0, 1               
MainCompactOk:  jal     CompactContainer
                bnez    $v1, MainCreateFig        ; bajo al menos 1 linea => nueva figura
                beqz    $s1, MainEnd             ; no completo linea y no cayo figura => termina juego
                j       MainCreateFig
MainKeypressed: ;****** procesamiento de teclas *****;
                ; prepara figura actual y figura auxiliar para procesar segun teclas
                daddi   $a0, $0, figCur
                daddi   $a1, $0, figAux
                ; Verifica tecla para rotar figura a izquierda
                lbu     $t0, KEY_ROT_LFT($0)
                bne     $v0, $t0, MainNextKey1  
                jal     RotateFigureLeft        
                j       MainKeyResult
MainNextKey1:   lbu     $t0, KEY_ROT_RGT($0)
                bne     $v0, $t0, MainNextKey2  
                jal     RotateFigureRight        
                j       MainKeyResult
MainNextKey2:   lbu     $t0, KEY_MOV_LFT($0)
                bne     $v0, $t0, MainNextKey3  
                jal     MoveFigureLeft        
                j       MainKeyResult
MainNextKey3:   lbu     $t0, KEY_MOV_RGT($0)
                bne     $v0, $t0, MainNextKey4  
                jal     MoveFigureRight        
                j       MainKeyResult
MainNextKey4:   lbu     $t0, KEY_MOV_DWN($0)
                bne     $v0, $t0, MainNextKey5  
                jal     MoveFigureDown        
                j       MainKeyResult
MainNextKey5:   lbu     $t0, KEY_END_GAME($0)
                beq     $v0, $t0, MainEnd
                j       MainKeyBack
MainKeyResult:  ; Luego de procesada la tecla, actualiza                    

                daddi   $a0, $0, Container
                daddi   $a1, $0, figAux
                jal     FitFigureInContainer    ; $v0=1 si entra figura
                ;daddi   $a0, $0, 48
                ;daddi   $a1, $0, 48
                ;dsll    $a2, $v0, 16
                ;jal     PutPixel 
                                 
                beqz    $v0, MainLoop
                ; hay que actualizar figura segun movimiento
                daddi   $a0, $0, figAux         ; figura modificada
                daddi   $a1, $0, figCur         ; figura actual
                jal     UpdateFigure
                j       MainKeyBack
MainEnd:        halt
    
; Inicializa el modo grafico y borra la pantalla
; Asume:
;   - $a0 color de fondo
InitGraphics:   lwu     $t8, CONTROL($zero)
                daddi	$t9, $0, 7     ; codigo para borrar pantalla y pasar al modo grafico
                sd		$t9, 0($t8)
                daddi   $t9, $0, 5        ; codigo de funcion para dibujar pixel
                sw      $a0, 8($t8)       ; 8 =  posicion inicial de data (Escribe color de fondo)
                jr      $ra
                ; corte para no limpiar pantalla
                
                daddi   $t7, $0, 50       ; 50 filas
InitGraphicsL1: daddi   $t6, $0, 50       ; 50 columnas
                daddi   $t7, $t7, -1      ; cuenta filas faltantes
InitGraphicsL2: daddi   $t6, $t6, -1      ; cuenta pixels faltantes de fila
                sb      $t6, 13($t8)      ; 13= 8+5 posicion 5 de data (X)
                sb      $t7, 12($t8)      ; 12= 8+4 posicion 4 de data (Y) 
                sw      $a0, 8($t8)       ; 8 =  posicion inicial de data (Escribe color de fondo)      
                sd      $t9, 0($t8)       ; control = 5, dibuja pixel
                
                bnez    $t6, InitGraphicsL2 ; no llego a 0 pinta sig pixel en fila
                bnez    $t7, InitGraphicsL1 ; no llego a 0, pinta siguiente fila
                jr		$ra

; Pantalla de inicio con explicacion en modo texto
; Asume:
;   - $v0 retorna ascii de tecla presionada
IntroScreen:    daddi   $sp, $sp, -8
                sd      $ra, 0($sp)
                ;lwu     $t8, CONTROL($zero)
                ;daddi	$t9, $0, 6     ; codigo para borrar pantalla y pasar al modo text
                ;sd		$t9, 0($t8)
                ;daddi   $t9, $0, TEXT_SCREEN
                ;sd      $t9, 8($t8)       ; 8 =  posicion inicial de data (direccion del string)
                ;daddi   $t9, $0, 4        ; codigo de funcion para imprimir texto en pantalla
                ;sd      $t9, 0($t8)       ; 4 en control imprime string 
                daddi   $a0, $a0, 8
                daddi   $a1, $a1, 30
                daddi   $a2, $a2, TETRIS_BMP
                jal     PutBitmap
IntroScreenL1:  lbu     $t0,  KEY_START_GAME($0)
                jal     KeyPressed
                bne     $v0, $t0, IntroScreenL1
                ld      $ra, 0($sp)
                daddi   $sp, $sp, 8
                jr      $ra
                

; Verifica si hay un caracter para leer
; Asume:
;   - $V0 retorna 0 sino hay caracter presionado y sino retorna el código ASCII del mismo
KeyPressed:     lwu   $t8, CONTROL($zero)
                daddi $t9, $0, 10        ; codigo de funcion para leer caracter
                sd    $t9, 0($t8)        ; control = 10
                lbu   $v0, 8($t8)
                jr    $ra




; Espera una cantidad de ciclos
; Asume:
;   - $a0 cantidad de ciclos de espera
DelayCycles:  daddi $a0, $a0, -1
              bnez  $a0, DelayCycles
              jr $ra


; Dibuja un pixel en la posicion (X,Y) del color indicado
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 color RGBX
PutPixel:       lwu   $t8, CONTROL($zero)
                sb    $a0, 13($t8)      ; 13= 8+5 posicion 5 de data (X)
                sb    $a1, 12($t8)      ; 12= 8+4 posicion 4 de data (Y)
                sw    $a2, 8($t8)       ; 8 =  posicion inicial de data (Color)
                daddi $t9, $0, 5        ; codigo de funcion para dibujar pixel
                sd    $t9, 0($t8)       ; control = 5
                jr    $ra

; Dibuja una linea horizontal en la posicion (X,Y) del color y tamanio indicado
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 color RGBX
;   - $a3 largo de la linea
DrawHLine:      lwu $t8, CONTROL($zero)
                sb      $a1, 12($t8)      ; 12= 8+4 posicion 4 de data (Y)
                sw      $a2, 8($t8)       ; 8 =  posicion inicial de data (Color)
                daddi   $t9, $0, 5        ; codigo de funcion para dibujar pixel
DrawHLineLoop:  sb      $a0, 13($t8)      ; 13= 8+5 posicion 5 de data (X)
                sd      $t9, 0($t8)       ; control = 5
                daddi   $a0, $a0, 1       ; prox pixel horizontal
                daddi   $a3, $a3, -1      ; actualiza cant pixeles faltantes
                bnez    $a3, DrawHLineLoop
                jr    $ra
                

; Dibuja una linea vertical en la posicion (X,Y) del color y tamanio indicado
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 color RGBX
;   - $a3 largo de la linea
DrawVLine:      lwu $t8, CONTROL($zero)
                sb      $a0, 13($t8)      ; 13= 8+5 posicion 5 de data (X)
                sw      $a2, 8($t8)       ; 8 =  posicion inicial de data (Color)
                daddi   $t9, $0, 5        ; codigo de funcion para dibujar pixel
DrawVLineLoop:  sb      $a1, 12($t8)      ; 12= 8+4 posicion 4 de data (Y)
                sd      $t9, 0($t8)       ; control = 5
                daddi   $a1, $a1, 1       ; prox pixel horizontal
                daddi   $a3, $a3, -1      ; actualiza cant pixeles faltantes
                bnez    $a3, DrawVLineLoop
                jr    $ra

    
; Dibuja una imagen en la posicion (X,Y)       
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 direccion de imagen a dibujar
; Comantarios:
;   - asume que la imagen tiene un byte para la dim x y otro para la dim y. Luego los datos donde
;     cada byte hace referencia a la posicion de la paleta de color PALETTECLR
PutBitmap:      daddi   $sp, $sp, -48
                ;40 a 47 memoria auxiliar
            	sd	    $s3, 32($sp)      ; 	
		        sd	    $s2, 24($sp)      ; 
		        sd	    $s1, 16($sp)      ; 
		        sd	    $s0, 8($sp)       ; 
                sd      $ra, 0($sp)
                ; ajuste para que la coordenada x,y quede en la posicion inferior-izquierda del caracter
                lbu     $t0, 0($a2)           ; dimension x de la imagen
                sb      $t0, 40($sp)          ; guarda dim x en sp
                lbu     $t1, 1($a2)           ; dimension y de la imagen
                sb      $t1, 41($sp)          ; guarda dim en sp
                sb      $a0, 42($sp)          ; guarda coord ini x en sp
                sb      $a1, 43($sp)          ; guarda coord ini y en sp
                daddi   $s3, $a2, 8           ; apunta a los datos de (primera fila)
                
                dadd    $s1, $a1, $t1         ; coordenada y inicial 
PutBitmapL1:    lbu     $s0, 42($sp)          ; coordenada x inicial 
                lbu     $s2, 40($sp)          ; largo imagen en x   
PutBitmapL2:    lbu     $a2, 0($s3)           ; indice de color
                dsll    $a2, $a2, 2           ; mult x4
                lw      $a2, PALETTECLR($a2)  ; color de paleta a pintar
                daddi   $a0, $s0, 0           ; coordenada x 
                daddi   $a1, $s1, 0           ; coordenada y
PutBitmapPaint: jal     PutPixel              ; pinta (X,Y) =($a0,$a1) con color $a2
                daddi   $s2, $s2, -1          ; pixel menos a pintar en fila
                daddi   $s0, $s0, 1           ; prox pixel a pintar en pantalla
                daddi   $s3, $s3, 1           ; prox pixel de imagen
                bnez    $s2, PutBitmapL2      ; no termino fila, sigue con prox
                ; termino fila
                daddi   $s1, $s1, -1          ; proxima fila (pinta arriba-abajo)
                lbu     $t0, 43($sp)          ; recupera pos inicial a pintar (que es final porque pinta de arriba-abajo)
                bne     $t0, $s1, PutBitmapL1 ; no llego a la ultima fila, inicia pinta de nueva fila
PutBitmapEnd:   ld	    $s3, 32($sp)          ; 
		        ld	    $s2, 24($sp)          ; 
		        ld	    $s1, 16($sp)          ; 
		        ld	    $s0, 8($sp)           ; 
                ld      $ra, 0($sp)
                daddi   $sp, $sp, 48
                jr      $ra  


; Dibuja un bloque en la posicion (X,Y) del color indicado
; tener en cuenta que cada bloque ocupa 2x2
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 color 
DrawBlock:      daddi   $sp,$sp,-8
                sd      $ra, 0($sp)
                daddi   $t2, $a2,0
                jal     PutPixel
                daddi   $a0, $a0, 1
                jal     PutPixel
                daddi   $a1, $a1, 1
                jal     PutPixel
                ;lwu     $a2, PALETTECLRLIGHT($t2)
                daddi   $a0, $a0, -1
                jal     PutPixel

                ; epilogo               
                ld      $ra, 0($sp)
                daddi   $sp,$sp, 8
                jr      $ra
                 
    
; Dibuja una figura en la posicion (X,Y)
; Asume:
;   - $a0 direccion de de memoria de la estructura de la figura
;   - $a1 color
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
DrawFigure:     daddi   $sp, $sp, -40
				sd	    $s3, 32($sp)         ; para indice de color				
                sd	    $s2, 24($sp)         ; para puntero de coordenadas
				sd	    $s1, 16($sp)         ; para llevar cuenta de coordenadas/ bloques de figura
				sd	    $s0, 8($sp)          ; para mantener puntero a figura
                sd      $ra, 0($sp)
                ; cuerpo subrutina
                dadd    $s0, $0, $a0          ; puntero a figura
                daddi   $s1, $0, 4            ; cant coord/bloques que componen figura
                daddi   $s2, $s0, 4           ; puntero a coordenadas (x,y) de bloques 
                daddi   $s3, $a1, 0           ; color
DrawFigureLoop: lbu     $a0, 2($s0)           ; posicion x de la figura
                lbu     $t0, 0($s2)           ; desp en x del bloque respecto de posicion de la figura
                dadd    $a0, $a0, $t0
                dsll    $a0, $a0, 1           ; multiplica x2 porque los bloques son de 2x2
                lbu     $a1, 3($s0)           ; posicion y de la figura
                lbu     $t0, 1($s2)           ; desp en y del bloque respecto de posicion de la figura
                dadd    $a1, $a1, $t0
                daddi   $a2, $s3, 0           ; color
                dsll    $a1, $a1, 1           ; multiplica x2 porque los bloques son de 2x2
                jal     DrawBlock
                daddi   $s2, $s2, 2          ; apunta a proxima coordenada de bloque para dibujar
                daddi   $s1, $s1, -1         ; bloques que quedan por dibujar
                bnez    $s1, DrawFigureLoop             
                 
DrawFigureEnd:  ; epilogo subrutina
                ld	    $s3, 32($sp) 
                ld	    $s2, 24($sp) 
                ld	    $s1, 16($sp) 
				ld	    $s0, 8($sp) 
                ld      $ra, 0($sp)       
                daddi   $sp, $sp, 40
                jr      $ra
    
   
 
; Copia figura origen en destino
; Asume:
;   - $a0 direccion de de memoria de la estructura de la figura a rotar (origen)
;   - $a1 direccion de de memoria de la estructura de la figura a rotada (destino)
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3) [desp bloque coordx, desp bloque coordy](4...)
CopyFigure:     ld    $t0, 0($a0)
                sd    $t0, 0($a1)   
                ld    $t0, 8($a0)
                sd    $t0, 8($a1)   
                jr    $ra          
  
  
; Genera una figura 
; Asume:
;   - $a0 direccion de memoria de la estructura de la figura a generar
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
GenerateFigure:     ; Numero al azar entre 0 y 6 
                    lw    $t0, CONTROL($0)
                    daddi $t1, $0, 7          ; random int 7 (0 a 6)  son 7 figuras
                    sd    $t1, 8($t0)          ; data = 7
                    daddi $t1, $0, 20          ; funcion de codigo al azar
                    sd    $t1, 0($t0)          ; control=20, generar numero al azar
                    ld    $t1, 8($t0)          ; recupera de data el numero generado
                
                    ;;;;;;; DEBUG
                    ;sd      $t1, 8($t0)
                    ;daddi   $k1, $0, 1
                    ;sd      $k1, 0($t 0)
                    
                    dsll  $t1, $t1, 4          ; multiplica x16 (cada figura ocupa 16 bytes)
                    daddi $t0, $t1, FIG_I      ; FIG_I es la 1era(son 7 consecutivas), suma desplazamiento 
                    ld    $t1, 0($t0)
                    sd    $t1, 0($a0)   
                    ld    $t1, 8($t0)
                    sd    $t1, 8($a0) 
                    lbu   $t1, CONTAINER_H($0)  ; altura logica del contenedor
                    daddi $t1, $t1, 1           ; ajuste
                    lbu   $t0, 0($a0)           ; tamanio de la matriz logica que contiene la figura
                    dsub  $t1, $t1, $t0         ; resta para posicionar en lo mas alto
                    sb    $t1, 3($a0)           ; establece posicion y de figura
                    lbu   $t1, CONTAINER_W($0)  ; altura logica del contenedor
                    daddi $t1, $t1, 1           ; ajuste
                    dsub  $t1, $t1, $t0         ; resta para centrar horizontalmente
                    dsrl  $t1, $t1, 1           ; divide por 2
                    sb    $t1, 2($a0)           ; establece posicion x de figura
                    jr    $ra        
       
  

  
; Rota figura a izquierda
; Asume:
;   - $a0 direccion de memoria de la estructura de la figura a rotar (origen)
;   - $a1 direccion de memoria de la estructura de la figura a rotada (destino)
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
RotateFigureLeft: ld    $t0, 0($a0)
                  sd    $t0, 0($a1)             ; copia estructura que no varia con la rotacion
                  lbu   $t0, 0($a0)             ; recupera dimension matriz de figura
                  daddi $t0, $t0, -1
                  daddi $t1, $0, 4              ; recupera cantidad de coordenadas a rotar
                  daddi $a0, $a0, 4             ; apunta a coordenadas de desplazamientos
                  daddi $a1, $a1, 4             ; apunta a coordenadas de desplazamientos
RotateFigLeftL1:  lbu   $t2, 0($a0)             ; coord desp x
                  lbu   $t3, 1($a0)             ; coord desp y
                  sb    $t2, 1($a1)             ; y' = x
                  dsub  $t3, $t0, $t3           ; x' = D-y
                  sb    $t3, 0($a1)
                  daddi $a0, $a0, 2             ; proximas coordenadas fig origen
                  daddi $a1, $a1, 2             ; proximas coordenadas fig destino
                  daddi $t1, $t1,-1             ; cuenta coordenadas faltantes
                  bnez  $t1, RotateFigLeftL1
                  jr $ra  
                     
; Rota figura a derecha
; Asume:
;   - $a0 direccion de memoria de la estructura de la figura a rotar (origen)
;   - $a1 direccion de memoria de la estructura de la figura a rotada (destino)
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
RotateFigureRight: ld    $t0, 0($a0)
                  sd    $t0, 0($a1)             ; copia estructura que no varia con la rotacion
                  lbu   $t0, 0($a0)             ; recupera dimension matriz de figura
                  daddi $t0, $t0, -1
                  daddi $t1, $0, 4              ; recupera cantidad de coordenadas a rotar
                  daddi $a0, $a0, 4             ; apunta a coordenadas de desplazamientos
                  daddi $a1, $a1, 4             ; apunta a coordenadas de desplazamientos
RotateFigRightL1: lbu   $t2, 0($a0)             ; coord desp x
                  lbu   $t3, 1($a0)             ; coord desp y
                  dsub  $t2, $t0, $t2           ; y' = D-x
                  sb    $t2, 1($a1)             ; x' = y
                  sb    $t3, 0($a1)             ; x' = y

                  daddi $a0, $a0, 2             ; proximas coordenadas fig origen
                  daddi $a1, $a1, 2             ; proximas coordenadas fig destino
                  daddi $t1, $t1,-1             ; cuenta coordenadas faltantes
                  bnez  $t1, RotateFigRightL1
                  jr $ra   
                    
; Mueve figura a derecha
; Asume:
;   - $a0 direccion de memoria de la estructura de la figura a mover (actual)
;   - $a1 direccion de memoria de la estructura de la figura a auxiliar (nueva)
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
MoveFigureRight:  ld    $t0, 0($a0)
                  sd    $t0, 0($a1)             ; copia estructura que no varia con la rotacion
                  ld    $t0, 8($a0)
                  sd    $t0, 8($a1)             ; copia las 4 coordenadas x,y de la figura
                  lbu   $t0, 2($a1)             ; recupera posicion x de la figura
                  daddi $t0, $t0, 1             ; mueve 1 posicion a derecha
                  sb    $t0, 2($a1)             ; actualiza coordenada
                  jr $ra     
  
; Mueve figura a izquierda
; Asume:
;   - $a0 direccion de memoria de la estructura de la figura a mover (actual)
;   - $a1 direccion de memoria de la estructura de la figura a auxiliar (nueva)
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
MoveFigureLeft:   ld    $t0, 0($a0)
                  sd    $t0, 0($a1)             ; copia estructura que no varia con la rotacion
                  ld    $t0, 8($a0)
                  sd    $t0, 8($a1)             ; copia las 4 coordenadas x,y de la figura
                  lbu   $t0, 2($a1)             ; recupera posicion x de la figura
                  daddi $t0, $t0, -1            ; mueve 1 posicion a izquierda
                  sb    $t0, 2($a1)             ; actualiza coordenada
                  jr $ra     
  
; Mueve figura hacia abajo
; Asume:
;   - $a0 direccion de memoria de la estructura de la figura a mover (actual)
;   - $a1 direccion de memoria de la estructura de la figura a auxiliar (nueva)
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
MoveFigureDown:   ld    $t0, 0($a0)
                  sd    $t0, 0($a1)             ; copia estructura que no varia con la rotacion
                  ld    $t0, 8($a0)
                  sd    $t0, 8($a1)             ; copia las 4 coordenadas x,y de la figura
                  lbu   $t0, 3($a1)             ; recupera posicion y de la figura
                  daddi $t0, $t0, -1            ; mueve 1 posicion hacia abajo
                  sb    $t0, 3($a1)             ; actualiza coordenada
                  jr $ra     
  
  
; Borra la figura anterior, dibuja la nueva y copia la nueva en la actual
; Asume:
;   - $a0 direccion de de memoria de la estructura de la figura nueva
;   - $a1 direccion de de memoria de la estructura de la figura actual
;   escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
UpdateFigure:   daddi   $sp, $sp, -24			
				sd	    $s1, 16($sp)         ; para figura actual
				sd	    $s0, 8($sp)          ; para figura nueva
                sd      $ra, 0($sp)
                ; Cuerpo subrutina
                daddi   $s0, $a0, 0          ; salva figura nueva
                daddi   $s1, $a1, 0          ; salva figura actual
                daddi   $a0, $s1, 0          ; dir figura actual
                lwu     $a1, BG_COLOR($0)
                ;daddi   $a1, $0, 0xFFFF
                jal     DrawFigure           ; borra figura vieja
                daddi   $a0, $s0, 0          ; dir figura nueva
                lbu     $a1, 1($a0)          ; recupera indice de color
                lwu     $a1, PALETTECLR($a1) ; recupera color
                jal     DrawFigure
                daddi   $a0, $s0, 0
                daddi   $a1, $s1, 0
                jal     CopyFigure
                 ; Epilogo subrutina
                ld	    $s1, 16($sp) 
				ld	    $s0, 8($sp) 
                ld      $ra, 0($sp)       
                daddi   $sp, $sp, 24
                jr      $ra
   

                  
; Dibuja el contenedor de figuras
DrawGameScreen:     daddi   $sp,$sp,-32
                    sd      $s2, 24($sp)         ; columna a pintar
                    sd      $s1, 16($sp)         ; contador
                    sd      $s0, 8($sp)          ; salvar color
                    sd      $ra, 0($sp)
                    
                    daddi   $t0, $0, 4
                    lwu     $s0, PALETTECLR($t0)
                    
                    ; Dibuja borde Izquierdo
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 0
                    daddi   $a2, $s0, 0
                    daddi   $a3, $0, 50
                    jal     DrawVLine
                    daddi   $a0, $0, 1
                    daddi   $a1, $0, 0
                    daddi   $a2, $s0, 0
                    daddi   $a3, $0, 50
                    jal     DrawVLine
                    
                    ; Dibuja Seccion de Panel Izquierdo
                    daddi   $s1, $0, 22         ; columna inicial
                    daddi   $s2, $0, 28         ; cantidad de columnas
DrawGameScreenL1:   daddi   $a0, $s1, 0         ; coord x 
                    daddi   $a1, $0, 2          ; coord y
                    daddi   $a2, $s0, 0         ; color
                    daddi   $a3, $0, 48         ; largo
                    jal     DrawVLine
                    daddi   $s1, $s1, 1         ; proxima columna
                    daddi   $s2, $s2, -1        ; una columna menos
                    bnez    $s2, DrawGameScreenL1

                    ; Dibuja borde Derecho
                    daddi   $a0, $0, 2
                    daddi   $a1, $0, 0
                    daddi   $a2, $s0, 0
                    daddi   $a3, $0, 50
                    jal     DrawHLine
                    daddi   $a0, $0, 2
                    daddi   $a1, $0, 1
                    daddi   $a2, $s0, 0
                    daddi   $a3, $0, 50
                    jal     DrawHLine
                    
                    ; Dibuja Seccion de Contenedor de figuras
                    daddi   $s1, $0, 2          ; columna inicial
                    daddi   $s2, $0, 20         ; cantidad de columnas
DrawGameScreenL2:   daddi   $a0, $s1, 0         ; coord x 
                    daddi   $a1, $0, 2          ; coord y
                    lwu     $a2, BG_COLOR($0)    ; color
                    daddi   $a3, $0, 48         ; largo
                    jal     DrawVLine
                    daddi   $s1, $s1, 1         ; proxima columna
                    daddi   $s2, $s2, -1        ; una columna menos
                    bnez    $s2, DrawGameScreenL2

                    ; epilogo               
                    ld      $s2, 24($sp)        
                    ld      $s1, 16($sp)      
                    ld      $s0, 8($sp)
                    ld      $ra, 0($sp)
                    daddi   $sp,$sp, 32
                    jr      $ra  


            
; Limpia el contenedor (logico) de figuras
; Asume:
;   - $a0 direccion del contenedor
; Comentarios:
;   - El contenedor es una matriz de 16 x 25 con los bordes laterales e inferior.
;     Estos bordes permiten no verificar que la posicion de una figura quede fuera
;     del area cada vez que se realice un movimiento. Simplifica un poco la logica.
;     un cero en una celda del contenedor significa que esta vacia y un valor
;     diferente de cero significa que esta vacia
ClearContainer:     dadd    $t9, $0, $a0 ; salva 
                    daddi   $t0, $0, 400 ; 50 = 400/8, para borrar mas rapido
ClearContainerL1:   sd       $0, 0($t9)      ; 8 bytes en 0
                    daddi   $t0, $t0, -8
                    daddi   $t9, $t9, 8
                    beqz    $t0, ClearContainerL1
                    ; agrega bordes laterales en izq en pos 0 y y derecho en pos 11
                    daddi   $t9, $a0, 0     ; puntero a contenedor
                    daddi   $t1, $0, 4      ; valor de desp indice color de fondo
                    daddi   $t0, $0, 400    ; tamanio en bytes de contenedor
ClearContainerL2:   sb      $t1, 0($t9)     ;  borde izq
                    sb      $t1, 11($t9)    ;  borde der
                    daddi   $t9, $t9, 16    ;  proxima fila
                    daddi   $t0, $t0,-16    ;  descuenta 
                    bnez    $t0, ClearContainerL2
                    ; agrega en borde inferior en primera fila
                    daddi   $t9, $a0, 0     ; puntero a contenedor
                    daddi   $t0, $0, 12     ; largo del borde inferior
ClearContainerL3:   sb      $t1, 0($t9)     ;  copia borde
                    daddi   $t9, $t9, 1    ;  proxima fila
                    daddi   $t0, $t0,-1    ;  descuenta 
                    bnez    $t0, ClearContainerL3
                    jr      $ra
                    
 
; Verifica si una figura con su posicion, puede ser ubicada dentro del contenedor
; Asume:
;   - $a0 direccion del contenedor
;   - $a1 direccion de la estructura de la figura
;   - $v0 retorna 1 si la figura puede ubicarse sin tocar la estructura, 0 en caso contrario
; Comentarios:
;   - El contenedor es una matriz de 16 x 25 con los bordes laterales e inferior.
;     Estos bordes permiten no verificar que la posicion de una figura quede fuera
;     del area cada vez que se realice un movimiento. Simplifica un poco la logica.
;     un cero en una celda del contenedor significa que esta vacia y un valor
;     diferente de cero significa que esta vacia
;   - Escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
FitFigureInContainer: daddi   $v0, $0, 0
                      daddi   $t0, $0, 4        ; 4 coordenadas. Todas las figuras tienen la misma cantidad
                      lb      $t3, 2($a1)       ; posicion x de figura
                      lb      $t4, 3($a1)       ; posicion y de figura
                      
                      daddi   $a1, $a1, 4       ; apunta a coordenadas de bloques dentro de la estructura
FitFigureInContL1:    lb      $t1, 0($a1)       ; coordenada x relativa de bloque
                      dadd    $t1, $t1, $t3     ; cordenada x absoluta
                      

                      lb      $t2, 1($a1)       ; coordenada y de bloque
                      dadd    $t2, $t2, $t4     ; coordenada absoluta
                                          
                      dsll    $t2, $t2, 4       ; multiplica x16
                      dadd    $t2, $t2, $t1     ; desplaza en x
                      dadd    $t2, $t2, $a0     ; posicion de celda en x,y del contenedor
                      lbu     $t1, 0($t2)       ; recupera valor de celda

                      bnez    $t1, FitFigureInContEnd
                      daddi   $a1, $a1, 2       ; proxima coordenada
                      daddi   $t0, $t0, -1      ; coordenadas restantes
                      bnez    $t0, FitFigureInContL1
                      daddi   $v0, $0, 1        ; llego a ultima coorenada y entro
FitFigureInContEnd:   jr      $ra
        
                    
; Verifica si una figura con su posicion, puede ser ubicada dentro del contenedor
; Asume:
;   - $a0 direccion del contenedor
;   - $a1 direccion de la estructura de la figura
; Comentarios:
;   - El contenedor es una matriz de 16 x 25 con los bordes laterales e inferior.
;     Estos bordes permiten no verificar que la posicion de una figura quede fuera
;     del area cada vez que se realice un movimiento. Simplifica un poco la logica.
;     un cero en una celda del contenedor significa que esta vacia y un valor
;     diferente de cero significa que esta vacia
;   - Escructura de la figura, cada campo es de 1 byte:  tam matriz(0), indice de color(1), coordx(2), coordy(3), [desp bloque coordx, desp bloque coordy](4...)
FigureToContainer:    daddi   $t0, $0, 4        ; 4 coordenadas. Todas las figuras tienen la misma cantidad
                      lb      $t3, 2($a1)       ; posicion x de figura
                      lb      $t4, 3($a1)       ; posicion y de figura
                      lbu     $t5, 1($a1)       ; indice color a poner en contenedor
                      
                      daddi   $a1, $a1, 4       ; apunta a coordenadas de bloques dentro de la estructura
FigureToContainerL1:  lb      $t1, 0($a1)       ; coordenada x relativa de bloque
                      dadd    $t1, $t1, $t3     ; cordenada x absoluta
                      lb      $t2, 1($a1)       ; coordenada y de bloque
                      dadd    $t2, $t2, $t4     ; coordenada absoluta
                                          
                      dsll    $t2, $t2, 4       ; multiplica x16
                      dadd    $t2, $t2, $t1     ; desplaza en x
                      dadd    $t2, $t2, $a0     ; posicion de celda en x,y del contenedor
                      sb      $t5, 0($t2)       ; pone color de figura en celda de contenedor


                      daddi   $a1, $a1, 2       ; proxima coordenada
                      daddi   $t0, $t0, -1      ; coordenadas restantes
                      bnez    $t0, FigureToContainerL1
                      jr      $ra
                   
 
      ;;;; debug
      DebugInt:   
      
                  lw      $k0, CONTROL($0)
                  sd      $at, 8($k0)
                  daddi   $k1, $0, 1
                  sd      $k1, 0($k0)
                  jr $ra                     
      ;;;;       
   
; Verifica si hay lineas completas dentro del contenedor a partir de la linea indicada
; Si encuentra lineas las elimina
; Asume:
;   - $a0 direccion del contenedor
;   - $a1 linea donde empieza la verificacion
;   - $v0 retorna la cantidad de lineas eliminadas
; Comentarios:
;   - El contenedor es una matriz de 16 x 25 con los bordes laterales e inferior.
;     Estos bordes permiten no verificar que la posicion de una figura quede fuera
;     del area cada vez que se realice un movimiento. Simplifica un poco la logica.
;     un cero en una celda del contenedor significa que esta vacia y un valor
;     diferente de cero significa que esta vacia
CompactContainer:       daddi   $sp, $sp, -32			
				        sd	    $s2, 24($sp)      ; 
				        sd	    $s1, 16($sp)      ; 
				        sd	    $s0, 8($sp)       ; 
                        sd      $ra, 0($sp)         

                        daddi   $v1, $0,  0       ; cantidad de lineas eliminadas
                        daddi   $s0, $a0, 0       ; direccion del contenedor
                        daddi   $s1, $a1, 0       ; linea a verificar
                        daddi   $s2, $0,  4       ; cantidad maxima de lineas a verificar
                        
CompactContainerChkLn:  daddi   $a0, $s0, 0       ; dir contenedor
                        daddi   $a1, $s1, 0       ; linea a verificar
                        
                        jal     CCLineCompleted   ; linea llena de bloques?
                        beqz    $v0, CompactContainerSkipLn
                        ; linea completa, hay que borrarla                        
                        daddi   $a0, $s0, 0       ; dir contenedor
                        daddi   $a1, $s1, 0       ; linea a verificar
                        
                        lwu     $k0, CONTROL($0)
                        sd      $a1, 8($k0)     ; celdas faltantes
                        daddi   $k1, $0, 1
                        sd      $k1, 0($k0)
                        
                        jal     CCRemoveLine       
                        daddi   $v1, $v1, 1       ; cuenta linea borrada
                        daddi   $s1, $s1, -1     ; luego inc linea y como se borro no debe avanzar
CompactContainerSkipLn:                          
                        daddi   $s2, $s2, -1      ; Decrementa lineas faltantes
                        daddi   $s1, $s1, 1       ; prox linea a verificar
                        bnez    $s2, CompactContainerChkLn
CompactContainerEnd:   		
				        ld	    $s2, 24($sp)      ; 
				        ld	    $s1, 16($sp)      ; 
				        ld	    $s0, 8($sp)       ; 
                        ld      $ra, 0($sp)
                        daddi   $sp, $sp, 32	
                        
                        
                        
CCLineCompleted:        daddi   $v0, $0, 0        ; linea no completa
                        dsll    $t0, $a1, 4       ; multiplica la linea por 16 para obtener desplazamiento inicial
                        daddi   $t0, $t0, 1       ; saltea borde izquierdo
                        dadd    $t0, $t0, $a0     ; addr(contenedor) + fila*16 + 1
                        daddi   $t1, $0, 10       ; cantidad de lineas a verificar
CCLineCompletedNext:    lbu     $t2, 0($t0)       ; valor de celda
                        beqz    $t2, CCLineCompletedEnd ; 0 => celda vacia, la linea no esta completa
                        
           
                        daddi   $t1, $t1, -1      ; decuenta celda
                        daddi   $t0, $t0, 1       ; prox celda
                        bnez    $t1, CCLineCompletedNext
                        daddi   $v0, $0, 1        ; linea completa
CCLineCompletedEnd:                             ;;;;;;; DEBUG ;;;;;;;
                        lwu     $k0, CONTROL($0)
                        sd      $t1, 8($k0)     ; celdas faltantes
                        daddi   $k1, $0, 1
                       ;sd      $k1, 0($k0)
                        
                        jr      $ra
 
; Remueve linea de pantalla y del contenedor
; Asume:
;   - $a0 direccion del contenedor
;   - $a1 linea donde empieza la verificacion
; Comentarios:
;   - El contenedor es una matriz de 16 x 25 con los bordes laterales e inferior.
;     Estos bordes permiten no verificar que la posicion de una figura quede fuera
;     del area cada vez que se realice un movimiento. Simplifica un poco la logica.
;     un cero en una celda del contenedor significa que esta vacia y un valor
;     diferente de cero significa que esta vacia

CCRemoveLine:           daddi   $sp, $sp, -40
                		sd	    $s3, 32($sp)      ; 	
				        sd	    $s2, 24($sp)      ; 
				        sd	    $s1, 16($sp)      ; 
				        sd	    $s0, 8($sp)       ; 
                        sd      $ra, 0($sp)
                        
                        dsll    $t0, $a1, 4       ; multiplica la linea por 16 para obtener desplazamiento inicial
                        daddi   $t0, $t0, 1       ; saltea borde izquierdo
                        dadd    $s0, $t0, $a0     ; addr(contenedor) + fila*16 + 1
                        daddi   $s1, $a1, 0       ; coordenada y
                        daddi   $s2, $0,  1       ; coordenada inicial x
                        daddi   $s3, $s3, 10      ; cantidad de lineas a verificar
CCRemoveLineNext:       sb      $0, 0($s0)        ; valor de celda
                        daddi   $s3, $s3, -1      ; decuenta celda restanes
                        daddi   $s0, $s0, 1       ; prox celda
                        dsll    $a0, $s2, 1       ; coord x logica a coord x pantalla(x2)
                        dsll    $a1, $s1, 1       ; coord y logica a coord y pantalla(x2)
                        daddi   $a2, $0, 0        ; color negro
                        jal     DrawBlock
                        daddi   $s2, $s2, 1       ; prox coord x de pantalla 
                        bnez    $s3, CCRemoveLineNext

                        ;debug
                        ;lwu     $k0, CONTROL($0)
                        ;sd      $a1, 8($k0)     ; celdas faltantes
                        ;daddi   $k1, $0, 1
                        ;sd      $k1, 0($k0)
                        
                        			
				        ld	    $s3, 32($sp)      ; 
				        ld	    $s2, 24($sp)      ; 
				        ld	    $s1, 16($sp)      ; 
				        ld	    $s0, 8($sp)       ; 
                        ld      $ra, 0($sp)
                        daddi   $sp, $sp, 40
                        jr      $ra       