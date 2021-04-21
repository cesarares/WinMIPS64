.data

; ##################################################################
; 
; 	Catedra:  Arquitectura de Computadoras 2020
;   Profesor: Cesar Estrebou
;	Alumno:   Diego Lanciotti
;
; ##################################################################

CONTROL: .word32 0x10000
DATA: .word32 0x10008


COLORES: .word32 0x000000, 0xe8f1ff, 0x532b1d, 0x82769c , 0x7e2553, 0x4d00ff ,0xa877ff , 0xaaccff, 0x36e400, 0x518700, 0x3652ab, 0x27ecff, 0xff0052


ARROW_DER: .byte 0x64
ARROW_IZQ: .byte 0x61
ARROW_ARR: .byte 32


BACKGROUND: .byte 12,0,0,1,0,2,0,3,0,4,0,0,1,1,1,2,1,3,1,4,1,0,2,1,2,2,2,3,2,4,2,0,3,1,3,2,3,3,3,4,3,0,4,1,4,2,4,3,4,4,4,99,99,99,99,99,99,99,99,99
BLOQUE: .byte 16,0,0,0,1,0,2,0,3,98,8,1,0,2,0,3,0,98,24,4,0,1,1,2,1,3,1,1,2,2,2,3,2,1,3,2,3,3,3,0,4,98,28,1,4,2,4,3,4,4,1,4,2,4,3,98,4,4,4,99
SUELO: .byte 40,0,0,1,0,3,0,4,0,0,1,1,1,2,1,3,1,4,1,98,16,2,0,0,2,1,2,2,2,3,2,4,2,98,36,0,3,1,3,2,3,3,3,4,3,1,4,2,4,3,4,4,4,98,32,0,4,99,99,99
SIGNIVEL: .byte 44,2,2,3,2,1,2,2,3,2,1,99

JELPI: .byte 28,1,0,3,0,1,3,2,3,3,3,4,3,0,4,2,4,3,4,4,4,0,5,1,5,2,5,3,5,4,5,5,5,0,6,4,6,98,48,1,1,2,1,3,1,98,20,1,2,2,2,3,2,98,24,0,3,5,3,98,8,1,4,5,4,99
BORRAR_JELPI: .byte 12,1,0,98,12,1,0,3,0,1,3,2,3,3,3,4,3,0,4,2,4,3,4,4,4,0,5,1,5,2,5,3,5,4,5,5,5,0,6,4,6,98,12,1,1,2,1,3,1,98,12,1,2,2,2,3,2,98,12,0,3,5,3,98,12,1,4,5,4,99
JELPI2: .byte 12,4,6,98,28,4,6,2,6,4,3,3,3,2,3,1,3,5,2,3,2,2,2,1,2,5,1,4,1,3,1,2,1,1,1,0,1,5,0,1,0,98,48,4,5,3,5,2,5,98,20,4,4,3,4,2,4,98,24,5,3,0,3,98,8,4,2,0,2,99
BORRAR_JELPI2: .byte 12,4,6,98,12,4,6,2,6,4,3,3,3,2,3,1,3,5,2,3,2,2,2,1,2,5,1,4,1,3,1,2,1,1,1,0,1,5,0,1,0,98,12,4,5,3,5,2,5,98,12,4,4,3,4,2,4,98,12,5,3,0,3,98,12,4,2,0,2,99


;Mapa

MAPA1:	.byte  1,1,1,1,1,1,1,1,1,1
FILA2:	.byte  1,3,0,1,0,0,0,0,0,1
FILA3:	.byte  1,1,0,0,0,0,0,0,0,0
FILA4:	.byte  1,0,0,0,0,0,0,0,0,1
FILA5:	.byte  1,1,1,1,1,1,0,0,0,1
FILA6:	.byte  1,0,0,0,0,1,0,0,0,1
FILA7:	.byte  1,0,0,0,0,0,0,0,0,1
FILA8:	.byte  0,0,0,0,0,0,0,0,0,1
FILA9:	.byte  1,0,0,1,0,0,0,0,0,1
FILA10:	.byte  2,2,2,2,2,2,2,2,2,2

MAPA2:	.byte  1,1,1,1,1,1,1,1,1,1
MAPA22:	.byte  1,1,1,1,1,1,1,1,1,1
FILAB1:	.byte  1,0,1,0,0,0,0,0,0,1
FILAB3:	.byte  1,0,1,0,0,0,0,0,0,1
FILAB4:	.byte  1,0,0,0,1,1,1,1,0,1
FILAB5:	.byte  1,0,0,0,1,3,0,1,0,1
FILAB6:	.byte  1,0,0,0,1,1,0,1,0,1
FILAB7:	.byte  1,0,2,0,2,0,0,0,0,1
FILAB8:	.byte  1,0,2,0,2,0,0,0,0,1
FILAB9:	.byte  1,0,2,0,2,0,1,0,0,1
FILAB10: .byte  2,2,2,2,2,2,2,2,2,2


CAER: .word 0										; 0 = caer hacia abajo / 1 = caer hacia arriba
NIVEL_ACTUAL: .word 0								; numero de mapa en el que se esta jugando


.text
			lwu $s0, DATA($zero)					; $s0 = dirección de DATA
			lwu $s1, CONTROL($zero)					; $s1 = dirección de CONTROL


inicio: 	daddi $t0, $zero, 7						; $t0 = 7 -> función 7: limpiar pantalla gráfica
			sd $t0, 0($s1)							; CONTROL recibe 7 y limpia la pantalla gráfica

			jal DibujarMapa

			daddi $v0, $zero, 5						; coordenada inicial X del personaje
			daddi $v1, $zero, 5						; coordenada inicial Y del personaje
			daddi $t4, $zero, 0
			sd $t4, CAER($zero)						; siempre cae hacia abajo al iniciar
			
													; control de personaje
			ld $s2, ARROW_IZQ($zero)  				; $s2 = tecla "<-" izquierda
			ld $s3, ARROW_DER($zero)  				; $s3 = tecla "->" derecha
			ld $s4, ARROW_ARR($zero)  				; $s4 = tecla "Barra espaciadora" arriba

			dadd $a0, $zero, $v0					; se precarga con la pos X actual para el primer ciclo
			dadd $a1, $zero, $v1					; se precarga con la pos Y actual para el primer ciclo


													; REPETIR CICLO INFINITO
ciclo_principal: daddi $a2, $zero, 73				; offset de sprite borrar_pj
			daddi $a3, $zero, 72					; offset al nuevo color a usar
			jal DibujarPersonaje					; primero borra el personaje ya dibujado

			daddi $a2, $zero, 219					; offset de sprite borrar_pj (invertido)
			daddi $a3, $zero, 218					; offset al nuevo color a usar
			jal DibujarPersonaje					; primero borra el personaje ya dibujado

			dadd $a0, $zero, $v0					; carga pos X del pj
			dadd $a1, $zero, $v1					; carga pos Y del pj
			
			ld $a2, CAER($zero)
			bnez $a2, dibujarInvertido				; dibujar pj invertido
			daddi $a2, $zero, 1						; offset de pj
			daddi $a3, $zero, 0						; offset al nuevo color a usar
			jal DibujarPersonaje					; despues lo vuelve a redibujar
			j input

dibujarInvertido: daddi $a2, $zero, 145				; offset de pj
			daddi $a3, $zero, 146					; offset al nuevo color a usar
			jal DibujarPersonaje					; despues lo vuelve a redibujar
			
input:		ld $a2, CAER($zero)
			jal CaerAbajo 							; verifica colision con el suelo y techo
			jal MoverPersonaje						; verifica colisiones y mueve PJ
			

			j ciclo_principal

			halt




; Controla los input de teclado. Usa un delay.
; Asume:
;   - $a0 coordenada X del personaje
;	- $a1 coordenada Y del personaje
; Devuelve:
;   - $v0 coordenada X del personaje modificada
MoverPersonaje: daddi $t0, $zero, 10				; modo teclado
				daddi $t1, $zero, 7000      		; $t1 = ciclos de espera
				daddi $t3, $zero, 5					; $t3 = tamanio de bloque mapa para colision
				daddi $t4, $zero, 0					;
				daddi $t5, $zero, 0					;	
				daddi $t6, $zero, 0					;
				daddi $t7, $zero, 9					; tamanio del mapa (10x10)
				daddi $t8, $zero, 0					;
				daddi $t9, $zero, 0					;
				dadd $v0, $zero, $a0				; devuelve la posicion X del pj modificada
				

				sd $t0, 0($s1)						; CONTROL recibe 10 y espera teclado
				ld $t0, 0($s0)						; lee la tecla presionada guardada en DATA
				andi $t0, $t0, 255 					; mascara para quedarse con la tecla presionada
				j delayCycles

				
teclContinuarCiclo: beq $t0, $s2, colisionIzq	    ; verifica tecla "<-" presionada
				beq $t0, $s3, colisionDer			; verifica tecla "->" preisonada
				j finMoverPersonaje

invertirGravedad: bne $t0, $s4, teclContinuarCiclo  ; verifica tecla "Barra espaciadora" presionada
				ld $t4, CAER($zero)
				beqz $t4, invertGrav
				daddi $t4, $zero, 0
				sd $t4, CAER($zero)					; cambia la gravedad
				j teclContinuarCiclo
invertGrav:		daddi $t4, $zero, 1					; 
				sd $t4, CAER($zero)					; cambia la gravedad
				j teclContinuarCiclo

moverDerecha: 	daddi $v0, $v0, 2					; velocidad de movimiento del pj
				j finMoverPersonaje

moverIzquierda: daddi $v0, $v0, -2					; velocidad de movimiento del pj
				j finMoverPersonaje

delayCycles:  	daddi $t1, $t1, -1					; queda repitiendo ciclos, evita flickering
              	bnez  $t1, delayCycles
              	j invertirGravedad

colisionIzq:	daddi $a0, $a0, -2					; simula movimiento a la izquierda
				daddi $a1, $a1, 2					; mueve el punto de colision al centro del pj
				ddiv $t4, $a0, $t3					; divide posX/5 para ver en MAPA
				ddiv $t5, $a1, $t3					; divide posY/5 para ver en MAPA
				daddi $a0, $a0, 2					; le vuelve a sumar 2 para dejarlo original
				daddi $a1, $a1, -2					; le vuelve a restar 2 para dejarlo original
				dsub $t5, $t7, $t5 					; 9 - $t5 para corregir el eje Y (que va al revez del mapa)
				daddi $t7, $zero, 16
				dmul $t5, $t5, $t7					; multiplica y*16 para avanzar en filas
				dadd $t4, $t4, $t5					; se lo suma a x y obtiene el offset al bloque en el mapa

				ld $t8, NIVEL_ACTUAL($zero)	 		; ajusta el nivel actual del juego
				daddi $t9, $zero, 176				; offset entre cada mapa siguiente	
				dmul $t8, $t8, $t9
				dadd $t4, $t8, $t4					; le suma offset del mapa siguiente

				lbu $t4, MAPA1($t4)					; carga que hay en el mapa
				daddi $t5, $zero, 0					; 0 = bloque libre 
				beq $t4, $t5, moverIzquierda	 	; 
				daddi $t5, $zero, 3					; 3 = bloque siguiente nivel 
				beq $t4, $t5, siguienteNivel	 	; avanzar al siguiente nivel
				j finMoverPersonaje					;

colisionDer:	daddi $a0, $a0, 7					; simula movimiento a la derecha 3+5(del offset del dibujo)
				daddi $a1, $a1, 2					; mueve el punto de colision al centro del pj
				ddiv $t4, $a0, $t3					; divide posX/5 para ver en MAPA
				ddiv $t5, $a1, $t3					; divide posY/5 para ver en MAPA
				daddi $a0, $a0, -7					; le vuelve a restar 7 para dejarlo original
				daddi $a1, $a1, -2					; le vuelve a restar 2 para dejarlo original
				dsub $t5, $t7, $t5 					; 9 - $t5 para corregir el eje Y (que va al revez del mapa)
				daddi $t7, $zero, 16
				dmul $t5, $t5, $t7					; multiplica y*16 para avanzar en filas
				dadd $t4, $t4, $t5					; se lo suma a x y obtiene el offset al bloque en el mapa

				ld $t8, NIVEL_ACTUAL($zero)	 		; ajusta el nivel actual del juego
				daddi $t9, $zero, 176				; offset entre cada mapa siguiente	
				dmul $t8, $t8, $t9
				dadd $t4, $t8, $t4					; le suma offset del mapa siguiente

				lbu $t4, MAPA1($t4)					; carga que hay en el mapa
				daddi $t5, $zero, 0					; 0 = bloque libre 
				beq $t4, $t5, moverDerecha 		 	; 
				j finMoverPersonaje					;

siguienteNivel: ld $t9, NIVEL_ACTUAL($zero)			; carga nivel actual
				daddi $t9, $t9, 1					; le suma 1
				sd $t9, NIVEL_ACTUAL($zero)			; lo vuelve a guardar
				j inicio 							; reinicia al siguite nivel

finMoverPersonaje: jr $ra




; Controla la colision con el suelo y con el techo
; Asume:
;   - $a0 coordenada X del personaje
;	- $a1 coordenada Y del personaje
;   - $a2 cae hacia abajo(0) o arriba(1)
; Devuelve:
;   - $v1 coordenada Y del personaje modificada
CaerAbajo:	 	daddi $t3, $zero, 5					; $t3 = tamanio de bloque mapa para colision
				daddi $t4, $zero, 0					;
				daddi $t5, $zero, 0					;
				daddi $t7, $zero, 9					; tamanio del mapa (10x10)
				daddi $t8, $zero, 0					;
				daddi $t9, $zero, 0					;
				dadd $v1, $zero, $a1				; devuelve la posicion Y del pj modificada
				
continuarCaer:	beq $a2, $t5, colisionAbajo			; $a2 = 0 cae hacia abajo
				j colisionArriba					; sino cae hacia arriba

colisionAbajo:	daddi $a1, $a1, -2					; simula movimiento para abajo
				daddi $a0, $a0, 2					; corrige offset personaje, para borde abismo
				ddiv $t4, $a0, $t3					; divide posX/5 para ver en MAPA
				ddiv $t5, $a1, $t3					; divide posY/5 para ver en MAPA
				daddi $a1, $a1, 2					; le vuelve a sumar 2 para dejarlo original
				daddi $a0, $a0, -2					; le vuelve a restar 2 para dejarlo original
				dsub $t5, $t7, $t5 					; 9 - $t5 para corregir el eje Y (que va al revez del mapa)
				daddi $t7, $zero, 16
				dmul $t5, $t5, $t7					; multiplica y*16 para avanzar en filas
				dadd $t4, $t4, $t5					; se lo suma a x y obtiene el offset al bloque en el mapa
				
				ld $t8, NIVEL_ACTUAL($zero)	 		; ajusta el nivel actual del juego
				daddi $t9, $zero, 176				; offset entre cada mapa siguiente	
				dmul $t8, $t8, $t9
				dadd $t4, $t8, $t4					; le suma offset del mapa siguiente

				lbu $t4, MAPA1($t4)					; carga que hay en el mapa
				daddi $t5, $zero, 0					; 0 = bloque libre 
				beq $t4, $t5, moverAbajo		 	;
				j finCaerAbajo	

colisionArriba:	daddi $a1, $a1, 7					; simula movimiento para arriba
				daddi $a0, $a0, 2					; corrige offset personaje, para borde abismo
				ddiv $t4, $a0, $t3					; divide posX/5 para ver en MAPA
				ddiv $t5, $a1, $t3					; divide posY/5 para ver en MAPA
				daddi $a1, $a1, -7					; le vuelve a restar 7(5+2) para dejarlo original
				daddi $a0, $a0, -2					; le vuelve a restar 2 para dejarlo original
				dsub $t5, $t7, $t5 					; 9 - $t5 para corregir el eje Y (que va al revez del mapa)
				daddi $t7, $zero, 16
				dmul $t5, $t5, $t7					; multiplica y*16 para avanzar en filas
				dadd $t4, $t4, $t5					; se lo suma a x y obtiene el offset al bloque en el mapa
				
				ld $t8, NIVEL_ACTUAL($zero)	 		; ajusta el nivel actual del juego
				daddi $t9, $zero, 176				; offset entre cada mapa siguiente	
				dmul $t8, $t8, $t9
				dadd $t4, $t8, $t4					; le suma offset del mapa siguiente

				lbu $t4, MAPA1($t4)					; carga que hay en el mapa
				daddi $t5, $zero, 0					; 0 = bloque libre 
				beq $t4, $t5, moverArriba		 	;
				j finCaerAbajo	

moverAbajo: 	daddi $v1, $v1, -2					; velocidad de caida del pj
				j finCaerAbajo				

moverArriba: 	daddi $v1, $v1, 2					; velocidad de subida del pj
				j finCaerAbajo	

finCaerAbajo: jr $ra




; Dibuja toda la matriz del mapa
; Asume:
;   - 
DibujarMapa:	daddi $t0, $zero, 0					; contador de sprites dibujados
				daddi $t1, $zero, 160				; maxima cant de elementos en la matriz -> 10+6 por salto de fila de matriz
				daddi $t2, $zero, 0					; posicion X del elemento en la matriz
				daddi $t3, $zero, 45				; posicion Y del elemento en la matriz
				daddi $t4, $zero, 50				; tamanio de la fila
				daddi $t5, $zero, 0					; 
				daddi $t6, $zero, 0					; 
				daddi $t7, $zero, 1					; offset de pixeles del objeto a dibujar
				daddi $t8, $zero, 0					; posicion del nuevo color a usar
				daddi $t9, $zero, 99				; condicion de corte del sprite

				ld $t5, NIVEL_ACTUAL($zero)	 		; ajusta el nivel actual del juego
				daddi $t6, $zero, 176				; offset entre cada mapa siguiente	
				dmul $t5, $t5, $t6
				dadd $t0, $t5, $t0					; le suma offset del mapa siguiente
				dadd $t1, $t5, $t1					; le suma offset del mapa siguiente


dibujar:		beq $t0, $t1, finDibujar 			; si se dibujo toda la matriz, finalizar subrutina
				lbu $t5, MAPA1($t0)					; $t5: dato de la matriz
				daddi $t6, $zero, 0					; condicion de sprite a dibujar 0 == BACKGROUND
				daddi $t7, $zero, 1					; offset de pixeles del objeto a dibujar
				beq $t5, $t6, dibujarBackgr			; $t5 == 0 => dibujar background
				daddi $t6, $zero, 1					; condicion de sprite a dibujar 1 == BLOQUE
				daddi $t7, $zero, 65				; offset al siguiente sprite en la lista
				daddi $t8, $zero, 64    			; offset al nuevo color a usar
				beq $t5, $t6, dibujarBackgr			; $t5 == 1 => dibujar BLOQUE
				daddi $t6, $zero, 2					; condicion de sprite a dibujar 2 == SUELO
				daddi $t7, $zero, 129				; offset al siguiente sprite en la lista
				daddi $t8, $zero, 128  				; offset al nuevo color a usar
				beq $t5, $t6, dibujarBackgr			; $t5 == 2 => dibujar SUELO
				daddi $t6, $zero, 3					; condicion de sprite a dibujar 3 == SIGNIVEL
				daddi $t7, $zero, 193				; offset al siguiente sprite en la lista
				daddi $t8, $zero, 192  				; offset al nuevo color a usar
				beq $t5, $t6, dibujarBackgr			; $t5 == 3 => dibujar SIGNIVEL
				j finElemento

cambiarColor:	daddi $t7, $t7, 1
				dadd $t8, $zero, $t7				; $t8 guarda offset al nuevo color
				daddi $t7, $t7, 1
				j dibujarBackgr

dibujarBackgr:	lbu $t6, BACKGROUND($t7)			; carga la posX del sprite a dibujar
				beq $t6, $t9, finElemento			; $t6 == 99 => pasar al siguiente sprite
				daddi $t9, $zero, 98				; 
				beq $t6, $t9, cambiarColor			; $t6 == 98 => cambiar de color
				daddi $t9, $zero, 99				;
				dadd $t6, $t6, $t2   				; ajusta posicion X del sprite
				sb $t6, 5($s0)						; DATA+5 recibe el valor de coordenada X
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

				lbu $t6, BACKGROUND($t7)			; carga la posY del sprite a dibujar
				dadd $t6, $t6, $t3   				; ajusta posicion Y del sprite
				sb $t6, 4($s0)						; DATA+4 recibe el valor de coordenada Y
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

													; pintar y mostrar
				lbu $t6, BACKGROUND($t8)  			; $t6 = offset, respecto a NEGRO, del color a pintar
				lwu $t6, COLORES($t6)				; $t6 = color a pintar en hexa
				sw $t6, 0($s0)						; DATA recibe el valor del color a pintar
				daddi $t6, $zero, 5					; $t0 = 5 -> función 5: salida gráfica
				sd $t6, 0($s1)						; CONTROL recibe 5 y produce el dibujo del punto
				
				j dibujarBackgr						; dibujar siguiente pixel


finElemento:	daddi $t0, $t0, 1					; pasa al siguiente elemento de la matriz
				daddi $t2, $t2, 5					; cambia la coordenada X
				daddi $t8, $zero, 0					; reinicia el offset del color
				beq	$t2, $t4, sigFila				; x == 50 => j sigFila
				j dibujar

sigFila:		daddi $t2, $zero, 0					; pasa a la sig fila. Pone X en 0
				daddi $t3, $t3, -5					; disminuye Y
				daddi $t0, $t0, 6
				j dibujar

finDibujar:		jr $ra
				



; Dibuja el personaje
; Asume:
;   - $a0 coordenada X del personaje
;	- $a1 coordenada Y del personaje
;   - $a2 offset al sprite del personaje (se usa para poder dibujar/borrar)
;   - $a3 offset al nuevo color a usar
DibujarPersonaje: daddi $t6, $zero, 0				; 
				dadd $t7, $zero, $a2				; offset de pixeles del objeto a dibujar
				dadd $t8, $zero, $a3				; offset al nuevo color a usar
				daddi $t9, $zero, 99				; condicion de corte del sprite


dibujarPixel:	lbu $t6, JELPI($t7)					; carga la posX del sprite a dibujar
				beq $t6, $t9, finPersonaje			; $t6 == 99 => termino de dibujar al personaje
				daddi $t9, $zero, 98				; 
				beq $t6, $t9, cambiarColorPersonaje	; $t6 == 98 => cambiar de color
				daddi $t9, $zero, 99				;
				dadd $t6, $t6, $a0   				; ajusta posicion X del sprite
				sb $t6, 5($s0)						; DATA+5 recibe el valor de coordenada X
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

				lbu $t6, JELPI($t7)					; carga la posY del sprite a dibujar
				dadd $t6, $t6, $a1   				; ajusta posicion Y del sprite
				sb $t6, 4($s0)						; DATA+4 recibe el valor de coordenada Y
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

													; pintar y mostrar
				lbu $t6, JELPI($t8)  				; $t6 = offset, respecto a NEGRO, del color a pintar
				lwu $t6, COLORES($t6)				; $t6 = color a pintar en hexa
				sw $t6, 0($s0)						; DATA recibe el valor del color a pintar
				daddi $t6, $zero, 5					; $t0 = 5 -> función 5: salida gráfica
				sd $t6, 0($s1)						; CONTROL recibe 5 y produce el dibujo del punto
				
				j dibujarPixel						; dibujar siguiente pixel

cambiarColorPersonaje:	daddi $t7, $t7, 1
				dadd $t8, $zero, $t7				; $t8 guarda offset al nuevo color
				daddi $t7, $t7, 1
				j dibujarPixel

finPersonaje:   jr $ra