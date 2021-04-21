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



PALETA_CLR:  .word32  0x00004040, 0x00008000, 0x00e8f1ff, 0x000080ff, 0x00c0c0c0, 0x00532b1d, 0x00000000, 0x00e8f1ff, 0x00ffad29, 0x00ffcc33
BG_COLOR:    .word32 0x00000000
CLR_PASTO:   .word32 0x0000ff00
CLR_CALLE:   .word32 0x00c0c0c0
CLR_LINEA:   .word32 0x00ffffff
CLR_CIELO:   .word32 0x00ffad29

; la definicion de la imagen debe estar alineada de a 8 bytes
AUTO_JUGADOR:   .byte 14, 8, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 4, 4, 4, 4 
AUTO_JUGADOR01: .byte  4, 4, 4, 4, 6, 7, 7, 7, 7, 5, 4, 4, 4, 4, 4, 4
AUTO_JUGADOR02: .byte  8, 6, 7, 7, 7, 7, 6, 6, 8, 8, 8, 7, 4, 8, 8, 5
AUTO_JUGADOR03: .byte  5, 5, 6, 6, 6, 8, 8, 8, 7, 8, 4, 8, 8, 8, 8, 8
AUTO_JUGADOR04: .byte  5, 5, 8, 8, 8, 8, 8, 6, 6, 6, 6, 6, 6, 6, 6, 6
AUTO_JUGADOR05: .byte  6, 6, 6, 6, 6, 4, 4, 4, 6, 7, 6, 6, 4, 4, 6, 7
AUTO_JUGADOR06: .byte  6, 6, 4, 4, 4, 4, 4, 6, 6, 4, 4, 4, 4, 6, 6, 4, 4, 4


CALLE_INI: .byte 10
CALLE_FIN: .byte 35
CIELO_INI: .byte 45
PANT_ANCHO: .byte 64
PANT_ALTO: .byte 64

AUTO_X: .byte 1
AUTO_Y: .byte 20
AUTO_ALTO: .byte 8
AUTO_ANCHO: .byte 14

; particulas para simular movimiento en el pasto, usan 3 colores de la paleta 0,1 y 2. Son puntos x,y con un indice de color
PARTICULAS_CANT: .byte 10
particulas: .space 30 ; reserva 3 bytes por particula = coord x, coord y, ind color

;
ESPERA1: .word 1000

AUTO_TOPE_BAJO: .byte 9  ; parte mas baja de la calle que puede alcanzar: CALLE_INI -1
AUTO_TOPE_ALTO: .byte 26     ; parte mas alta de la calle que puede alcanzar CALLE_FIN-AUTO_ALTO-1(-9)

.code
                    daddi   $sp,$0,0x1000     
                    jal     IniciarGraficos
                    jal     DibujarFondo
                    
                    daddi   $s0, $0, particulas
                    lb      $s1, PARTICULAS_CANT($0)
MainGenParticulas:  daddi   $a0, $s0, 0
                    jal     GenerarParticula
                    daddi   $s0, $s0, 3
                    daddi   $s1, $s1, -1
                    bnez    $s1, MainGenParticulas
                    daddi   $a0, $0, particulas
                    lb      $t0, 0($a0)
                    lb      $t1, 1($a0)
                    lb      $t2, 2($a0)
                    
                    jal     MoverParticula
                    
                    lb      $a0, AUTO_X($0)
                    lb      $a1, AUTO_Y($0)          ; coordenada y del auto
                    daddi   $a2, $0, AUTO_JUGADOR
                    jal     DibujarImagen
                    
MainLoop:           ; animacion de particulas del pasto
                    daddi   $s0, $0, particulas
                    lb      $s1, PARTICULAS_CANT($0)
MainMovParticulas:  daddi   $a0, $s0, 0
                    jal     MoverParticula
                    daddi   $s0, $s0, 3
                    daddi   $s1, $s1, -1
                    bnez    $s1, MainMovParticulas
                    ; verificacion de teclas presionadas
                    jal     KeyPressed
                    bnez    $v0, MainTecla1
                    ; vuelta al inicio del Loop
                    ld      $a0, ESPERA1($0)
                    jal     EsperaCiclos             ; espera
                    j       MainLoop
                    ;****** procesamiento de teclas *****;
                    ; Verifica tecla presionada
MainTecla1:         lbu     $t0, TECLA_ARRIBA($0)
                    bne     $v0, $t0, MainTecla2  
                    jal     MoverAutoArriba        
                    j       MainLoop
MainTecla2:         lbu     $t0, TECLA_ABAJO($0)
                    bne     $v0, $t0, MainTecla3  
                    jal     MoverAutoAbajo 
                    j       MainLoop
MainTecla3:         lbu     $t0, TECLA_FIN($0)
                    beq     $v0, $t0, MainTerminar
                    j       MainLoop  
MainTerminar:      ; Tecla ESC, sale de programa, 
                    
                    halt
                    

; Espera una cantidad de ciclos
; Asume:
;   - $a0 cantidad de ciclos de espera
EsperaCiclos:  daddi $a0, $a0, -1
               bnez  $a0, DelayCycles
               jr $ra
              
              
              
; - $a0 = puntero a la particula  
GenerarParticula:   lwu   $t0, CONTROL($0)
                    lbu   $t1, CALLE_INI($0)   ; arriba y abajo el bloque de pasto tiene igual longitud
                    daddi $t1, $t1, -1         ; ajusta
                    sd    $t1, 8($t0)          ; data = max nro al azar
                    daddi $t2, $0, 20          ; funcion de codigo al azar
                    sd    $t2, 0($t0)          ; control=20, generar numero al azar
                    ld    $t3, 8($t0)          ; recupera de data el numero generado
                    daddi $t1, $0, 2           ; para decidir si va arriba (1) o abajo (0)
                    sd    $t1, 8($t0)          ; data = max nro al azar
                    sd    $t2, 0($t0)          ; control=20, generar numero al azar
                    ld    $t1, 8($t0)          ; recupera data nro al azar
                    beqz  $t1, GenerarParticulaC1 ;  va abajo, no hay que ajustar nada
                    ld    $t1, CALLE_FIN($0)   ; desp a pasto de arriba
                    dadd  $t3, $t3, $t1        ; suma desp para ubicar en pasto superior
                    daddi $t3, $t3, 1         ; ajusta
GenerarParticulaC1: sb    $t3, 1($a0)          ; asigna coordenada y 
                    lb    $t1, PANT_ANCHO($0)  ; random para que no siempre aparezca cuando sale de pantalla
                    sd    $t1, 8($t0)          ; data = max nro al azar
                    sd    $t2, 0($t0)          ; control=20, generar numero al azar
                    ld    $t3, 8($t0)          ; recupera de data el numero generado
                    lb    $t1, PANT_ANCHO($0)  ; final de pantalla
                    dadd  $t3, $t3, $t1        ; ajusta coord x fuera de pantalla 
                    sb    $t3, 0($a0)          ; ubica coordenada x
                    ; genera color 
                    daddi $t1, $0, 3           ; random para primeros 3 colores de paleta
                    sd    $t1, 8($t0)          ; data = max nro al azar
                    sd    $t2, 0($t0)          ; control=20, generar numero al azar
                    ld    $t3, 8($t0)          ; recupera de data el numero generado
                    sb    $t3, 2($a0)          ; ubica color
                    lb    $t0, 0($a0)
                    lb    $t1, 1($a0)
                    lb    $t2, 2($a0)
                    jr    $ra
                    
; Asume $a0: puntero a particula
MoverParticula:     daddi   $sp, $sp, -16			
                    sd      $s0, 8($sp)
                    sd      $ra, 0($sp)
                    ; Cuerpo subrutina
                    daddi   $s0, $a0, 0        ; salva puntero para trabajar
                    ; borrado de perticula antes de actualizar
                    lb      $a0, 0($s0)        ; coord x
                    lb      $a1, 1($s0)        ; coord y
                    lwu     $a2, CLR_PASTO($0) ; color
                    jal     PintarPixel
                    ; borrado de perticula antes de actualizar
                    lb      $a0, 0($s0)        ; coord x
                    lb      $a1, 1($s0)        ; coord y
                    daddi   $a0, $a0, -1       ; mueve particula
                    sb      $a0, 0($s0)        ; guarda nueva posicion
                    lb      $a2, 2($s0)        ; indice de color
                    dsll    $a2, $a2, 2        ; mult x4 para desplazamiento en paleta
                    lwu     $a2, PALETA_CLR($a2); color
                    jal     PintarPixel
                    ; mueve a
                    lb      $t0, 0($s0)        ; recupera coord x
                    slt     $t1, $t0, $0       ; t1 = 1 si $t0 < 0
                    beqz    $t1, MoverParticulaFin ;termina
                    daddi   $a0, $s0, 0         
                    jal     GenerarParticula 
MoverParticulaFin:  ld      $s0, 8($sp)
                    ld      $ra, 0($sp)       
                    daddi   $sp, $sp, 16
                    jr      $ra                    
                            

MoverAutoArriba:    daddi   $sp, $sp, -8			
                    sd      $ra, 0($sp)
                    ; Cuerpo subrutina  
                    
                    lb      $a1, AUTO_Y($0)          ; coordenada y del auto
                    daddi   $a1, $a1, 1              ; nueva coord y
                    lb      $t0, AUTO_TOPE_ALTO($0)  ; limite superior es la calle
                    slt     $t1, $t0, $a1            ; $t1=1 si llega al limite
                    bnez    $t1, MoverAutoArribaFin
                    ; puede moverse arriba, hay que actualizar el grafico
                    sb      $a1, AUTO_Y($0)          ; actualiza coordenada  y
                    lb      $a0, AUTO_X($0)          ; recupera coordenada x
                    daddi   $a2, $0, AUTO_JUGADOR    
                    jal     DibujarImagen 
                    ; tambien hay que borrar la linea inferior
                    lb      $a0, AUTO_X($0)          ; coordenada x del auto
                    lb      $a1, AUTO_Y($0)          ; coordenada y del auto
                    lwu     $a2, CLR_CALLE($0)       ; color a pintar
                    lb      $a3, AUTO_ANCHO($0)      ; ancho del auto en pixeles
                    jal     DibujarLnH
                    ; Epilogo subrutina
MoverAutoArribaFin: ld      $ra, 0($sp)       
                    daddi   $sp, $sp, 8
                    jr      $ra


MoverAutoAbajo:     daddi   $sp, $sp, -8			
                    sd      $ra, 0($sp)
                    ; Cuerpo subrutina  
                    
                    lb      $a1, AUTO_Y($0)          ; coordenada y del auto
                    daddi   $a1, $a1, -1             ; nueva coord y
                    lb      $t0, AUTO_TOPE_BAJO($0)  ; limite superior es la calle
                    slt     $t1, $a1, $t0            ; $t1=1 si llega al limite
                    bnez    $t1, MoverAutoAbajoFin
                    ; puede moverse arriba, hay que actualizar
                    sb      $a1, AUTO_Y($0)          ; actualiza coordenada  y
                    lb      $a0, AUTO_X($0)          ; recupera coordenada x
                    daddi   $a2, $0, AUTO_JUGADOR    
                    jal     DibujarImagen 

                    ; tambien hay que borrar la linea superior, son 3 casos
                    lb      $a0, AUTO_X($0)          ; coordenada x del auto
                    lwu     $a2, CLR_CALLE($0)       ; color por defecto para pintar, puede cambiar
                    lb      $a3, AUTO_ANCHO($0)      ; ancho del auto en pixeles
                    lb      $t0, AUTO_ALTO($0)       ; alto del auto
                    lb      $a1, AUTO_Y($0)          ; coordenada y del auto
                    dadd    $a1, $a1, $t0            ; ajusta coord y segun altura
                    daddi   $a1, $a1, 1              ; ajuste adicional
                    jal     DibujarLnH
                    ; Epilogo subrutina
MoverAutoAbajoFin:  ld      $ra, 0($sp)       
                    daddi   $sp, $sp, 8
                    jr      $ra


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
                    ld      $a3, PANT_ANCHO($0)    ; ancho de la pantalla
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
                    ld      $a1, CALLE_INI($0)   ; coordenada y final
                    daddi   $a1, $a1, -1         ; ajusta
                    ld      $a2, CLR_PASTO($0)   ; color pasto
                    jal     DibujarBloque
                    
                    ; dibuja linea externa inferior de calle
                    ld      $a0, CALLE_INI($0)    ; coordenada y inicial
                    daddi   $a1, $a0, 1           ; coordenada y final
                    ld      $a2, CLR_LINEA($0)    ; color linea
                    jal     DibujarBloque                      
                    
                    ; dibuja calle de la pantalla  de color gris
                    ld      $a0, CALLE_INI($0)    ; coordenada y inicial
                    ld      $a1, CALLE_FIN($0)    ; coordenada y final
                    ld      $a2, CLR_CALLE($0)    ; color calle
                    jal     DibujarBloque

                    ; dibuja linea externa superior de calle
                    ld      $a0, CALLE_FIN($0)    ; coordenada y inicial
                    daddi   $a1, $a0, 1           ; coordenada y final
                    ld      $a2, CLR_LINEA($0)    ; color linea
                    jal     DibujarBloque

                    ; dibuja linea externa superior de calle
                    ld      $a0, CALLE_FIN($0)    ; coordenada y inicial
                    daddi   $a0, $a0, 1           ; ajuste
                    ld      $a1, CIELO_INI($0)    ; coordenada y final
                    ld      $a2, CLR_PASTO($0)    ; color pasto
                    jal     DibujarBloque

                    ; dibuja linea externa superior de calle
                    ld      $a0, CIELO_INI($0)    ; coordenada y inicial
                    ld      $a1, PANT_ALTO($0)    ; coordenada y final
                    ld      $a2, CLR_CIELO($0)    ; color cielo
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
                    lbu     $t0, 0($a2)           ; dimension x de la imagen
                    sb      $t0, 40($sp)          ; guarda dim x en sp
                    lbu     $t1, 1($a2)           ; dimension y de la imagen
                    sb      $t1, 41($sp)          ; guarda dim en sp
                    sb      $a0, 42($sp)          ; guarda coord ini x en sp
                    sb      $a1, 43($sp)          ; guarda coord ini y en sp
                    daddi   $s3, $a2, 2           ; apunta a los datos de (primera fila)
                    
                    dadd    $s1, $a1, $t1         ; coordenada y inicial 
DibujarImagenL1:    lbu     $s0, 42($sp)          ; coordenada x inicial 
                    lbu     $s2, 40($sp)          ; largo imagen en x   
DibujarImagenL2:    lbu     $a2, 0($s3)           ; indice de color
                    dsll    $a2, $a2, 2           ; mult x4
                    lw      $a2, PALETA_CLR($a2)  ; color de paleta a pintar
                    daddi   $a0, $s0, 0           ; coordenada x 
                    daddi   $a1, $s1, 0           ; coordenada y
DibujarImagenPinta: jal     PintarPixel           ; pinta (X,Y) =($a0,$a1) con color $a2
                    daddi   $s2, $s2, -1          ; pixel menos a pintar en fila
                    daddi   $s0, $s0, 1           ; prox pixel a pintar en pantalla
                    daddi   $s3, $s3, 1           ; prox pixel de imagen
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


