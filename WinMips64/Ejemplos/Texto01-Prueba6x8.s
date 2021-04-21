.data

CONTROL:    .word32 0x10000

FUENTE_ANCHO: .byte  6
FUENTE_ALTO:  .byte  8
FUENTE_6X8:    .word  0x0000000000000000,0x040E0E0404000400,0x1B1B120000000000,0x000A1F0A0A1F0A00,0x080E100C021C0400,0x1919020408131300 ;32-37
FUENTE_6X8_38:  .word  0x0814140815120D00,0x0C0C080000000000,0x0408080808080400,0x0804040404040800,0x000A0E1F0E0A0000,0x0004041F04040000 ;38-43
FUENTE_6X8_44:  .word  0x00000000000C0C08,0x0000001F00000000,0x00000000000C0C00,0x0001020408100000,0x0E11131519110E00,0x040C040404040E00 ;44-49
FUENTE_6X8_50:  .word  0x0E11010608101F00,0x0E11010E01110E00,0x02060A121F020200,0x1F10101E01110E00,0x0608101E11110E00,0x1F01020408080800 ;50-55
FUENTE_6X8_56:  .word  0x0E11110E11110E00,0x0E11110F01020C00,0x00000C0C000C0C00,0x00000C0C000C0C08,0x0204081008040200,0x00001F00001F0000 ;56-61
FUENTE_6X8_62:  .word  0x0804020102040800,0x0E11010604000400,0x0E11171517100E00,0x0E1111111F111100,0x1E11111E11111E00,0x0E11101010110E00 ;62-67  
FUENTE_6X8_68:  .word  0x1E11111111111E00,0x1F10101E10101F00,0x1F10101E10101000,0x0E11101711110F00,0x1111111F11111100,0x0E04040404040E00 ;68-73
FUENTE_6X8_74:  .word  0x0101010111110E00,0x1112141814121100,0x1010101010101F00,0x111B151111111100,0x1119151311111100,0x0E11111111110E00 ;74-79 
FUENTE_6X8_80:  .word  0x1E11111E10101000,0x0E11111115120D00,0x1E11111E12111100,0x0E11100E01110E00,0x1F04040404040400,0x1111111111110E00 ;80-85  
FUENTE_6X8_86:  .word  0x11111111110A0400,0x1111151515150A00,0x11110A040A111100,0x1111110A04040400,0x1E02040810101E00,0x0E08080808080E00 ;86-91   
FUENTE_6X8_92:  .word  0x0010080402010000,0x0E02020202020E00,0x040A110000000000,0x000000000000003F,0x0C0C040000000000,0x00000E010F110F00 ;92-97 
FUENTE_6X8_98:  .word  0x10101E1111111E00,0x00000E1110110E00,0x01010F1111110F00,0x00000E111E100E00,0x0608081E08080800,0x00000F11110F010E ;98-103 
FUENTE_6X8_104: .word  0x10101C1212121200,0x0400040404040600,0x020006020202120C,0x1010121418141200,0x0404040404040600,0x00001A1515111100 ;104-109
FUENTE_6X8_110: .word  0x00001C1212121200,0x00000E1111110E00,0x00001E1111111E10,0x00000F1111110F01,0x0000160908081C00,0x00000E100E010E00 ;110-115
FUENTE_6X8_116: .word  0x00081E08080A0400,0x0000121212160A00,0x00001111110A0400,0x00001111151F0A00,0x000012120C121200,0x00001212120E0418 ;116-121
FUENTE_6X8_127: .word  0x00001E020C101E00,0x0608081808080600,0x0404040004040400,0x0C02020302020C00,0x0A14000000000000,0x040E1B11111F0000 ;122-127



texto1: .asciiz "0123456789"
texto2: .asciiz "ABCDEFGHIJ"
texto3: .asciiz "KLMNOPQRST"
texto4: .asciiz "UVWXYZ"
texto5: .asciiz "abcdefghij"
texto5: .asciiz "klmnopqrst"
texto6: .asciiz "uvwxyz"
texto7: .asciiz "!+-*/=^%()"
texto8: .asciiz "{}[}/<>:.,"


TXT_CLR: .word32 0x00ff0000


.code
                    daddi   $sp, $0, 0x1000 
                    
                    jal     IniciarGraficos
                       
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 56
                    daddi   $a2, $0, texto1
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 48
                    daddi   $a2, $0, texto2
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 40
                    daddi   $a2, $0, texto3
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 32
                    daddi   $a2, $0, texto4
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 24
                    daddi   $a2, $0, texto5
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 16
                    daddi   $a2, $0, texto6
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 8
                    daddi   $a2, $0, texto7
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    daddi   $a0, $0, 0
                    daddi   $a1, $0, 0
                    daddi   $a2, $0, texto8
                    lwu     $a3, TXT_CLR($0)
                    jal     ImprimirCadena
                    ;daddi   $a2, $0, 65
                    ;jal     ImprimirCaracter

                    halt


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       SUBRUTINAS PRINCIPALES     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

 
; Imprime una cadena de texto terminada en asciiz 
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 puntero a cadena asciiz
;   - $a3 Color texto  
; Comantarios:
;   - Utiliza 1 bit/pixel, asume que en un byte entra la fila del caracter (max 8 pixeles)
;   - Un caracter de 5x8 utiliza 8 bytes. cada byte contiene una fila de la que se utilizan 5 bits
ImprimirCadena:     daddi  $sp, $sp, -40			
                    sd     $s3, 32($sp)
                    sd     $s2, 24($sp)
                    sd     $s1, 16($sp)
                    sd     $s0, 8($sp)
                    sd     $ra, 0($sp)
                    daddi   $s0, $a0, 0 
                    daddi   $s1, $a1, 0 
                    daddi   $s2, $a2, 0
                    daddi   $s3, $a3, 0
ImprimirCadenaLoop: lbu     $a2, 0($s2) 
                    beqz    $a2, ImprimirCadenaFin
                    daddi   $a0, $s0, 0
                    daddi   $a1, $s1, 0
                    daddi   $a3, $s3, 0
                    jal     ImprimirCaracter
                    lbu     $t0, FUENTE_ANCHO($0)   ; ancho del caracter
                    dadd    $s0,$s0, $t0            ; proxima posicion en pantalla
                    daddi   $s2, $s2, 1             ; proximo caracter a imprimir
                    j       ImprimirCadenaLoop                    
ImprimirCadenaFin:  ld      $s2, 32($sp)
                    ld      $s2, 24($sp)
                    ld      $s1, 16($sp)
                    ld      $s0,  8($sp)
                    ld      $ra,  0($sp)       
                    daddi   $sp, $sp, -40
                    jr      $ra                    

; Imprime un caracter en una coordenda de la pantalla    
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 codigo ascci del caracter a dibujar
;   - $a3 color del texto

; Comantarios:
;   - Utiliza 1 bit/pixel, asume que en un byte entra la fila del caracter (max 8 pixeles)
;   - Un caracter de 5x8 utiliza 8 bytes. cada byte contiene una fila de la que se utilizan 5 bits
ImprimirCaracter:    daddi  $sp, $sp, -8			
                     sd     $ra, 0($sp)
                     daddi  $t0, $0, 128    ; maximo caracter (127) a dibujar
                     slt    $t1, $a2, $t0   ; car < 128 ?
                     beqz   $t1, ImprimirCaracterFin
                     daddi  $t0, $0, 32     ; minimo caracter a dibujar
                     slt    $t1, $a2, $t0   ; car < 32 
                     bnez   $t1, ImprimirCaracterFin
                     ; calculo de posicion en tabla de caracteres
                     dsub   $a2, $a2, $t0   ; cod ascii - 32 apunta al inicio de tabla
                     dsll   $a2, $a2, 3     ; multiplica x 8 para apuntar a caracter (8 bytes c/u)
                     daddi  $t0, $0, FUENTE_6X8 ; tabla de caracteres
                     dadd   $a2, $a2, $t0       ; apunta a primer byte de caracter 
                     jal    DibujarCaracter
ImprimirCaracterFin: ld     $ra, 0($sp)       
                     daddi  $sp, $sp, 8
                     jr     $ra
                     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       SUBRUTINAS AUXILIARES      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
 
; Dibuja un caracter en la posicion (X,Y)       
; Asume:
;   - $a0 coordenada x
;   - $a1 coordenada y
;   - $a2 direccion de imagen a dibujar
;   - $a3 color del texto
; Comantarios:
;   - Utiliza 1 bit/pixel, asume que en un byte entra la fila del caracter (max 8 pixeles)
;   - Un caracter de 5x8 utiliza 8 bytes. cada byte contiene una fila de la que se utilizan 5 bits

DibujarCaracter:    lwu   $t8, CONTROL($zero)     ; t8 siempre control
                    daddi $t9, $0, 5              ; t9 siempre codigo de funcion para dibujar pixel
                    
                    
                    dadd    $t1, $0, $a1          ; coordenada y pantalla
                    
                    daddi   $t0, $0, 1            ; para calcular mascara inicial 
                    lbu     $t2, FUENTE_ANCHO($0) ; cantidad de columnas (x)
                    daddi   $t2, $t2,-1     
                    dsllv   $t2, $t0, $t2         ; pone mascara
                    
                    lbu     $t3, FUENTE_ALTO($0)  ; cantidad de filas  (y)
                    
DibujarCarL1:       dadd    $t0, $0, $a0          ; coordenada x pantalla
                    lbu     $t4, 0($a2)           ; recupera fila completa a procesar
                    daddi   $t5, $t2, 0           ; pone mascara inicial en t5
DibujarCarL2:       and     $t6, $t4, $t5         ; aplica mascara
                    beqz    $t6, DibujarCarNoPintar  ; 0 =fondo, 1= color
DibujarCarPintar:   sb      $t0, 13($t8)          ; 13= 8+5 posicion 5 de data (X)
                    sb      $t1, 12($t8)          ; 12= 8+4 posicion 4 de data (Y)
                    sw      $s3, 8($t8)           ; 8 =  posicion inicial de data (Color)
                    sd      $t9, 0($t8)           ; control = 5
                    ; cuenta columna
DibujarCarNoPintar: dsrl    $t5, $t5, 1           ; proximo bit de fila
                    daddi   $t0, $t0, 1           ; proximo pixel en pantalla
                    bnez    $t5, DibujarCarL2     ; procesa proximo bit
                    ; cuenta la fila
                    daddi   $a2, $a2, 1           ; proximo byte a de fila a recuperar
                    daddi   $t1, $t1, 1           ; proxima fila en pantalla
                    daddi   $t3, $t3, -1          ; descuenta filas faltantes
                    bnez    $t3, DibujarCarL1     ; no es ultima fila, procesa proxima fila
                    jr      $ra
              

      
; Inicializa el modo grafico
; Asume:
IniciarGraficos:    lwu     $t8, CONTROL($zero)
                    daddi	$t9, $0, 7     ; codigo para borrar pantalla y pasar al modo grafico
                    sd		$t9, 0($t8)
                    ;daddi   $t9, $0, 5     ; codigo de funcion para dibujar pixel
                    sw      $a0, 8($t8)   ; 8 =  posicion inicial de data (Escribe color de fondo)
                    jr      $ra

