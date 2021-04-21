.data
CONTROL:    .word32 0x10000

; 4 colores reservados, el resto usables para dibujos



TECLA_IZQ: .byte 97  ; tecla a
TECLA_DER: .byte 100 ; tecla d
;KEY_ROT_LFT: .byte 113 ; tecla q
;KEY_ROT_RGT: .byte 101 ; tecla e
TECLA_ARRIBA: .byte 119 ; tecla s
TECLA_ABAJO: .byte 115 ; tecla s
;KEY_START_GAME: .byte 32 ; tecla ESC
TECLA_FIN: .byte 27 ; tecla ESC      
TECLA_ESP: .byte 32  ; BARRA DE ESPACIO



PALETA_CLR:  .word32  0x00004040, 0x00008000, 0x00e8f1ff, 0x000080ff, 0x00c0c0c0, 0x00532b1d, 0x00000000, 0x00e8f1ff, 0x00ffad29, 0x00ffcc33
; Formato color XBGR
BG_COLOR:    .word32 0x00000000
CLR_PASTO:   .word32 0x0000ff00
CLR_CALLE:   .word32 0x00c0c0c0
CLR_LINEA:   .word32 0x00ffffff
CLR_CIELO:   .word32 0x00ffad29
CLR_FONDO:   .word32 0x00000000
CLR_DISPARO: .word32 0x0000ff00


dummy: .space 16

CALLE_INI:  .byte 10
CALLE_FIN:  .byte 35
CIELO_INI:  .byte 45
PANT_ANCHO: .byte 64
PANT_ALTO:  .byte 64


; particulas para simular movimiento en el pasto, usan 3 colores de la paleta 0,1 y 2. Son puntos x,y con un indice de color
;PARTICULAS_CANT: .byte 10
DISPAROS_MAX:  .byte 16
DISPAROS_CANT: .byte 0 ; cantidad de disparos disponibles
DISPAROS_SPR:  .space 30 ; reserva 3 bytes por particula = coord x, coord y, 1 activo / 0 inactivo
DISPAROS_DESP: .byte 0  ; para desplazar cada vez que tira vale alterna entre 0 y 1

DISPAROS_POS1: .byte  4 ; 1era posicion x de disparo 
DISPAROS_POS2: .byte  7 ; 2da posicion x de disparo
;
ESPERA1: .word 1

NAVE_X:     .byte 26  ; 26=(64-12)/2  centrada en x
NAVE_Y:     .byte 0   ; posicion de nave en y
NAVE_DIRX:  .byte 0   ; direccion x de movimiento de la nave  (-1, 0 o +1)
NAVE_ALTO:  .byte 12
NAVE_ANCHO: .byte 12

NAVE_TOPE_IZQ: .byte -1  ; parte mas baja de la calle que puede alcanzar: CALLE_INI -1
NAVE_TOPE_DER: .byte 53  ; parte mas alta de la calle que puede alcanzar CALLE_FIN-NAVE_ALTO-1(-9)

; Estas variables controlan la velocidad de animacion/movimiento de los objetos.
; La velocidad se realaciona con la cantidad de veces que se ejecuta el bucle principal
; la variable es una mascara que se aplica y si el resultado es 0 se ejecuta la animacion/movimiento
; El valor de la mascara deberia ser (2^n)-1
LOOP_ACT_NAVE:    .word    1 ; actualiza cada 2 veces el dibujo/movimiento de la nave
LOOP_ACT_DISPARO: .word   15 ; mask=1111, determinar que el auto-disparo se haga cada 32 veces en el bucle principal

; Esta Imagen ocupa 584 bytes incluyendo dimension y pixeles. Cada declaracion de variable contiene 8 pixeles
; Para dibujarla pasar a la subrutina la referencia a la variable NAVE
NAVE:    .word32 12,12
NAVE_00: .word 0x0000000000000000,0x0000000000000000,0x0000000000000000,0x0000000000000000
NAVE_08: .word 0x0000000000000000,0x0000000000000000,0x0000000000000000,0x0000000000000000
NAVE_10: .word 0x007D7D7600000000,0x00000000007D7D76,0x0000000000000000,0x0000000000000000
NAVE_18: .word 0x0000000000000000,0x0000000000000000,0x007D7D7600000000,0x00000000007D7D76
NAVE_20: .word 0x0000000000000000,0x0000000000000000,0x0000000000000000,0x0000000000000000
NAVE_28: .word 0x00C8C82E007F7F77,0x007F7F7700C8C82E,0x0000000000000000,0x0000000000000000
NAVE_30: .word 0x0000000000000000,0x0000000000000000,0x0095950000808079,0x0080807900959500
NAVE_38: .word 0x0000000000000000,0x0000000000000000,0x0000000000000000,0x007F7F7800000000
NAVE_40: .word 0x0092920000BDBDB4,0x00BDBDB400929200,0x00000000007F7F78,0x0000000000000000
NAVE_48: .word 0x0000000000000000,0x00BDBDB4007F7F78,0x004E4E4D00BDBDB4,0x00BDBDB4004E4E4D
NAVE_50: .word 0x007F7F7800BDBDB4,0x0000000000000000,0x007F7F7800000000,0x00BDBDB400BDBDB4
NAVE_58: .word 0x004F4F4B00BDBDB4,0x00BDBDB4004F4F4B,0x00BDBDB400BDBDB4,0x00000000007F7F78
NAVE_60: .word 0x007F7F7800000000,0x00BDBDB400BDBDB4,0x004E4E4D00000000,0x00000000004E4E4D
NAVE_68: .word 0x00BDBDB400BDBDB4,0x00000000007F7F78,0x0000000000000000,0x007F7F78007F7F78
NAVE_70: .word 0x009C9CFF00000000,0x00000000009C9CFF,0x007F7F78007F7F78,0x0000000000000000
NAVE_78: .word 0x0000000000000000,0x009C9CFF009C9CFF,0x0000000000000000,0x0000000000000000
NAVE_80: .word 0x009C9CFF009C9CFF,0x0000000000000000,0x0000000000000000,0x0000000000000000
NAVE_88: .word 0x0000000000000000,0x0000000000000000,0x0000000000000000,0x0000000000000000







.code
                    daddi   $sp,$0,0x1000     

                    jal     IniciarGraficos
                    jal     DibujarFondo
                    
                    
            
                    daddi   $s0, $s0, -1              ; cuanta la cantidad de veces que se ejecuta el loop
MainLoop:           daddi   $s0, $s0, 1               ; cuenta ejecucion del bucle principal
                    ; seccion de animacion movimiento de la nave
                    ld      $t0, LOOP_ACT_NAVE($0)
                    and     $t0, $t0, $s0            ; mascara para  determinar si acutaliza nave
                    bnez    $t0, MainLoopDisparos    ; res=0 ejecuta, sino saltea animacion de nave
                    
                    ; La nave se dibuja siempre aunque no se haya movido. Es menos eficiente
                    ; pero hace que la animacion general sea mas suave, sin saltos
                    daddi   $a0, $0, NAVE_X          ; posicion actual de nave
                    lb      $a1, NAVE_DIRX($0)       ; direccion a mover
                    jal     MoverNave
                    lb      $a0, NAVE_X($0)
                    lb      $a1, NAVE_Y($0)          ; coordenada y de nave
                    daddi   $a2, $0, NAVE
                    jal     DibujarImagen
                    
MainLoopDisparos:   ; animacion de DISPAROS, siempre se generan/animan los disparos
                    ld      $t0, LOOP_ACT_DISPARO($0)
                    and     $t0, $t0, $s0              ; mascara determina cada cuanto debe auto-disparar
                    bnez    $t0, MainLoopAnimar        ; res<>0, saltea generacion de disparos
                    ; Generacion de disparos   
                    lb      $t0, DISPAROS_MAX($0)                 
                    lb      $t1, DISPAROS_CANT($0)
                    dsub    $t0, $t0, $t1              ; cantidad de disparos disponibles
                    daddi   $t0, $t0, -2               ; cantidad de disparos a generar
                    slt     $t1, $t0, $0               ; 1 si $t0 < 0, no hay espacio
                    bnez    $t1, MainLoopAnimar        ; no hay 2 lugares para el disparo, solo anima
                    ; genera 2 disparos
                    daddi   $a0, $0, DISPAROS_SPR       ; arreglo de estructuras de disparos
                    daddi   $a1, $0, DISPAROS_CANT      ; cant disparos activos, se va a modificar
                    lb      $a2, NAVE_X($0)             ; posicion de imagen de nave
                    lb      $t0, DISPAROS_POS1($0)
                    dadd    $a2, $a2, $t0               ; posicion 1 de disparo
                    jal     GenerarDisparo
                    daddi   $a0, $0, DISPAROS_SPR       ; arreglo de estructuras de disparos
                    daddi   $a1, $0, DISPAROS_CANT      ; cant disparos activos, se va a modificar
                    lb      $a2, NAVE_X($0)             ; posicion de imagen de nave
                    lb      $t0, DISPAROS_POS2($0)
                    dadd    $a2, $a2, $t0               ; posicion 2 de disparo
                    jal     GenerarDisparo
                    j       MainLoopVerTeclas
MainLoopAnimar:     daddi   $a0, $0, DISPAROS_SPR
                    daddi   $a1, $0, DISPAROS_CANT  
                    jal     AnimarDisparos
                    ;daddi   $a0, $0, 200
                    ;jal     EsperaCiclos
                    ; verificacion de teclas presionadas
MainLoopVerTeclas:  jal     KeyPressed
                    bnez    $v0, MainTecla1
                    ; vuelta al inicio del Loop
                    ld      $a0, ESPERA1($0)
                    jal     EsperaCiclos             ; espera
                    j       MainLoop
                    ;****** procesamiento de teclas *****;
                    ; Verifica tecla presionada
MainTecla1:         lbu     $t0, TECLA_FIN($0)
                    beq     $v0, $t0, MainTerminar
MainTecla2:         lbu     $t0, TECLA_DER($0)
                    bne     $v0, $t0, MainTecla3 
                    daddi   $t0, $0, 1
                    sb      $t0, NAVE_DIRX($0)    
                    j       MainLoop
MainTecla3:         lbu     $t0, TECLA_IZQ($0)
                    bne     $v0, $t0, MainTecla4  
                    daddi   $t0, $0, -1
                    sb      $t0, NAVE_DIRX($0)   
                    j       MainLoop 
MainTecla4:         ; ninguna tecla reconocida, detiene el movimiento de la nave
                    sb      $0, NAVE_DIRX($0)
                    j       MainLoop  
MainTerminar:      ; Tecla ESC, sale de programa,                   
                    halt
                    

; Espera una cantidad de ciclos
; Asume:
;   - $a0 cantidad de ciclos de espera
EsperaCiclos:  daddi $a0, $a0, -1
               bnez  $a0, DelayCycles
               jr $ra
              
              
; Asume:
;   a0: puntero a arreglo de punteros
;   a1: direccion a cantidad de disparos activos
;   a2: posicion x de la nave
;   Recorre el arreglo de estructuras de disparos (x,y, activo) apuntado con $a0
;   DISPAROS_MAX indica cuantos disparos puede haber como maximo. El arreglo puede
;   tener disparos activos (moviendose) o inactivos (fuera de pantalla o alcanzo un objeto).
;   La rutina busca un disparo inactivo en el arreglo, lo inicializa, lo pinta y marca como activo

GenerarDisparo:     daddi   $sp, $sp, -8			
                    sd      $ra, 0($sp)
                    ; Cuerpo de subrutina
                    lb      $t0, DISPAROS_MAX($0)  ; cantidad de disparos que puede haber en el arreglo
GenerarDisparoLoop: lb      $t1, 2($a0)            ; recupera estado de disparo: 0=inactivo
                    beqz    $t1, GenerarDisparoOk
                    daddi   $a0, $a0, 3            ; prox disparo
                    daddi   $t0, $t0, -1           ; descuenta disparo
                    bnez    $t0, GenerarDisparoLoop ; no hay lugar para el disparo
                    j       GenerarDisparoFin
                    ; se encontro un disparo inactivo para activar
GenerarDisparoOk:   lb      $t0, 0($a1)            ; cant disparos activos
                    daddi   $t0, $t0, 1            ; incrementa disparos activos
                    sb      $t0, 0($a1)            ; actualiza referencia
                    daddi   $t0, $0, 1             ; para activar
                    sb      $t0, 2($a0)            ; marca estructura activa
                    sb      $a2, 0($a0)            ; actualiza coord x de disparo
                    lb      $t1, NAVE_ALTO($0)     ; coord y del disparo
                    sb      $t1, 1($a0)            ; actualiza coord y de disparo
                    ; pinta disparo
                    dadd    $a0, $0, $a2
                    dadd    $a1, $0, $t1
                    lwu     $a2, CLR_DISPARO($0)
                    jal     PintarPixel 
                    ; Epilogo
GenerarDisparoFin:  ld      $ra, 0($sp)       
                    daddi   $sp, $sp, 8
                    jr      $ra
                    
; Asume:
;   a0: puntero a arreglo de estructuras de disparo: 3bytes(x,y, activo)
;   a1: direccion a cantidad de disparos activos
;   Recorre el arreglo de estructuras de disparos (x,y, activo) apuntado con $a0
;   DISPAROS_MAX indica cuantos disparos puede haber como maximo. El arreglo puede
;   tener disparos activos (moviendose) o inactivos (fuera de pantalla o alcanzo un objeto).
;   Solo se animan disparos activos indicado con 1 en el tercer byte (activo) 
AnimarDisparos:     daddi   $sp, $sp, -32			
                    sd      $s2, 24($sp)
                    sd      $s1, 16($sp)
                    sd      $s0,  8($sp)
                    sd      $ra,  0($sp)
                    ; Cuerpo subrutina
                    lb      $t0, 0($a1)         ; Para verificar si hay disparos para animar
                    beqz    $t0, AnimarDisparosFin
                    daddi   $s0, $a0, 0        ; salva puntero para trabajar
                    daddi   $s1, $a1, 0        ; salva direccion disparos activos
                    lbu     $s2, DISPAROS_MAX($0)  ; cant disparos max
AnimarDisparosLoop: lbu     $t0, 2($s0)        ; recupera campo activo
                    beqz    $t0, AnimarDisparosProx ; disparo no activo => no animar, pasar a prox disparo
                    ; animar disparo: avanzar 1 posicion hacia arriba
                    lb      $a0, 0($s0)        ; coord x
                    lb      $a1, 1($s0)        ; coord y
                    lwu     $a2, CLR_FONDO($0) ; color
                    jal     PintarPixel
                    ; calcula nueva posicion  y la guarda
                    lb      $a1, 1($s0)        ; coord y
                    daddi   $a1, $a1, 1        ; mueve disparo hacia arriba 1 posicion
                    sb      $a1, 1($s0)        ; guarda nueva posicion
                    lb      $t0, PANT_ALTO($0) ; borde superior
                    bne     $t0, $a1, AnimarDisparosCont ; no alcanzo borde? => pintar
                    ; en este punto el disparo llego al borde, no se pinta y se desactiva
                    sb      $0,  2($s0)        ; activado = 0
                    lb      $t0, 0($s1)        ; recupera cant disparos activos
                    daddi   $t0, $t0, -1       ; descuenta activos
                    sb      $t0, 0($s1)        ; actualiza referencia
                    beqz    $t0, AnimarDisparosFin ; se desactivo ultimo disparo => termina
                    ; pinta disparo en nueva posicion
AnimarDisparosCont: lb      $a0, 0($s0)          ; recupera coord x
                    lwu     $a2, CLR_DISPARO($0) ; color
                    jal     PintarPixel
AnimarDisparosProx: daddi   $s0, $s0, 3        ; avanza a estructura de proximo disparo
                    daddi   $s2, $s2, -1       ; descuenta disparos pendientes
                    bnez    $s2, AnimarDisparosLoop ; no llego al ultimo
AnimarDisparosFin:  ld      $s2, 24($sp)
                    ld      $s1, 16($sp)
                    ld      $s0,  8($sp)
                    ld      $ra,  0($sp)       
                    daddi   $sp, $sp, 32
                    jr      $ra                    

; Asume:
;   a0: puntero variavle de  posicion x de nave
;   a1: direccion en x de la nave
;   Si el calculo de la posicion es valido, modifica la posicion
MoverNave:          beqz    $a1, MoverNaveFin       ; no hay que mover
                    lb      $t0, 0($a0)             ; recupera posicion actual
                    dadd    $t0, $t0, $a1           ; nueva posicion x
                    lb      $t1, NAVE_TOPE_IZQ($0)  ; posicion invalida a la izq
                    beq     $t0, $t1, MoverNaveFin  ; nada que hacer
                    lb      $t1, NAVE_TOPE_DER($0)  ; posicion invalida a la der
                    beq     $t0, $t1, MoverNaveFin  ; nada que hacer
                    sb      $t0, 0($a0)             ; actualiza posicion
MoverNaveFin:       jr      $ra                           



; Dibujar bloque horizontal de un color uniforme que ocupa el ancho de la pantalla
; Asume:
;   - $a0 coordenada y inicial
;   - $a1 coordenada y final
;   - $a2 color RGBX
   
DibujarBloque:      daddi   $sp, $sp, -32			
				    sd	    $s2, 24($sp)         ; para color
				    sd	    $s1, 16($sp)         ; para coordenada y final
				    sd	    $s0, 8($sp)          ; para coordenada y inicial/actual
                    sd      $ra, 0($sp)
                    ; Cuerpo subrutina  
                    dadd    $s0, $0,$a0
                    dadd    $s1, $0,$a1
                    dadd    $s2, $0,$a2
                    ; dibuja parte inferior de la pantalla
                    
DibujarBloqueLoop1: daddi   $a0, $0, 0            ; coord x de inicio
                    dadd    $a1, $0, $s0          ; coord y inicio/actual
                    dadd    $a2, $0, $s2          ; color 
                    lbu     $a3, PANT_ANCHO($0)    ; ancho de la pantalla
                    jal     DibujarLnH
                    daddi   $s0, $s0, 1           ; prox coord y
                    bne     $s0, $s1, DibujarBloqueLoop1 ; no termino, otra linea 
                    ; Epilogo subrutina
                    ld	    $s2, 24($sp) 
                    ld	    $s1, 16($sp) 
    				ld	    $s0, 8($sp) 
                    ld      $ra, 0($sp)       
                    daddi   $sp, $sp, 32
                    jr      $ra
                    
; Dibujar Fondo
; dibuja la calle donde se mueven los autos
; Asume:
; no hay parametros. 
DibujarFondo:       daddi   $sp, $sp, -8			
                    sd      $ra, 0($sp)
                    ; Cuerpo subrutina  
                    
                    ; dibuja parte inferior de la pantalla  de color verde
                    
                    daddi   $a0, $0, 0;          ; coordenada y inicial
                    lb      $a1, PANT_ALTO($0)   ; coordenada y final
                    lwu     $a2, CLR_FONDO($0)   ; color fondo
                    jal     DibujarBloque
                    
                    ; Epilogo subrutina
                    ld      $ra, 0($sp)       
                    daddi   $sp, $sp, 8
                    jr      $ra




; Inicializa el modo grafico
; Asume:
IniciarGraficos:    lwu     $t8, CONTROL($zero)
                    daddi	$t9, $0, 7     ; codigo para borrar pantalla y pasar al modo grafico
                    sd		$t9, 0($t8)
                    ;daddi   $t9, $0, 5     ; codigo de funcion para dibujar pixel
                    sw      $a0, 8($t8)   ; 8 =  posicion inicial de data (Escribe color de fondo)
                    jr      $ra



; Dibuja un pixel en la posicion (X,Y) del color indicado
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 color RGBX
PintarPixel:    lwu   $t8, CONTROL($zero)
                sb    $a0, 13($t8)      ; 13= 8+5 posicion 5 de data (X)
                sb    $a1, 12($t8)      ; 12= 8+4 posicion 4 de data (Y)
                sw    $a2, 8($t8)       ; 8 =  posicion inicial de data (Color)
                daddi $t9, $0, 5        ; codigo de funcion para dibujar pixel
                sd    $t9, 0($t8)       ; control = 5
                jr    $ra


; Dibuja una imagen en la posicion (X,Y)       
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 direccion de imagen a dibujar
; Comantarios:
;   - asume que la imagen tiene un byte para la dim x y otro para la dim y. Luego los datos donde
;     cada byte hace referencia a la posicion de la paleta de color PALETTECLR
DibujarImagen:      daddi   $sp, $sp, -48
                    ;40 a 47 memoria auxiliar
              	    sd	    $s3, 32($sp)      ; 	
  		            sd	    $s2, 24($sp)      ; 
  		            sd	    $s1, 16($sp)      ; 
  		            sd	    $s0, 8($sp)       ; 
                    sd      $ra, 0($sp)
                    ; ajuste para que la coordenada x,y quede en la posicion inferior-izquierda del caracter
                    lwu     $t0, 0($a2)           ; dimension x de la imagen
                    sb      $t0, 40($sp)          ; guarda dim x en sp
                    lwu     $t1, 4($a2)           ; dimension y de la imagen
                    sb      $t1, 41($sp)          ; guarda dim en sp
                    sb      $a0, 42($sp)          ; guarda coord ini x en sp
                    sb      $a1, 43($sp)          ; guarda coord ini y en sp
                    daddi   $s3, $a2, 8           ; apunta a los datos de (primera fila)
                    
                    dadd    $s1, $a1, $t1         ; coordenada y inicial 
DibujarImagenL1:    lbu     $s0, 42($sp)          ; coordenada x inicial 
                    lbu     $s2, 40($sp)          ; largo imagen en x   
DibujarImagenL2:    lwu     $a2, 0($s3)           ; color del pixel
                    daddi   $a0, $s0, 0           ; coordenada x 
                    daddi   $a1, $s1, 0           ; coordenada y
DibujarImagenPinta: jal     PintarPixel           ; pinta (X,Y) =($a0,$a1) con color $a2
                    daddi   $s2, $s2, -1          ; pixel menos a pintar en fila
                    daddi   $s0, $s0, 1           ; prox pixel a pintar en pantalla
                    daddi   $s3, $s3, 4           ; prox pixel de imagen
                    bnez    $s2, DibujarImagenL2  ; no termino fila, sigue con prox
                    ; termino fila
                    daddi   $s1, $s1, -1          ; proxima fila (pinta arriba-abajo)
                    lbu     $t0, 43($sp)          ; recupera pos inicial a pintar (que es final porque pinta de arriba-abajo)
                    bne     $t0, $s1, DibujarImagenL1 ; no llego a la ultima fila, inicia pinta de nueva fila
DibujarImagenEnd:   ld	    $s3, 32($sp)          ; 
    		        ld	    $s2, 24($sp)          ; 
    		        ld	    $s1, 16($sp)          ; 
    		        ld	    $s0, 8($sp)           ; 
                    ld      $ra, 0($sp)
                    daddi   $sp, $sp, 48
                    jr      $ra 
                    
                    
; Dibuja una linea horizontal en la posicion (X,Y) del color y tamanio indicado
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 color RGBX
;   - $a3 largo de la linea
DibujarLnH:         lwu $t8, CONTROL($zero)
                    sb      $a1, 12($t8)      ; 12= 8+4 posicion 4 de data (Y)
                    sw      $a2, 8($t8)       ; 8 =  posicion inicial de data (Color)
                    daddi   $t9, $0, 5        ; codigo de funcion para dibujar pixel
DibujarLnHLoop:     sb      $a0, 13($t8)      ; 13= 8+5 posicion 5 de data (X)
                    sd      $t9, 0($t8)       ; control = 5
                    daddi   $a0, $a0, 1       ; prox pixel horizontal
                    daddi   $a3, $a3, -1      ; actualiza cant pixeles faltantes
                    bnez    $a3, DibujarLnHLoop
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


