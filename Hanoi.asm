
#HECHO POR:
#	JOSE JUAN DIAZ CAMPOS
#	ANGEL RAMIREZ CARRILLO
.text

main: 
      addi a0, zero, 0         # Inicializamos contador de movimientos
      addi s4, zero, 1         # Variable de iteracion para el bucle for
      addi s0, zero, 10        # Aqui tenemos n para los discos 
      jal inicio               # llamada a funcion inicio que se encarga de el lui, torres 
      jal inicializacion       #llamada a la funcion incializacion inicia los discos en la memoria y mueve los apuntadores

for: 			# Bucle for: i desde 1 hasta n
      blt s0, s4, endfor       
      sw s4, 0(s1)            # Almacena el valor actual de i en la memoria
      addi s1, s1, 32          # Incremento de los punteros de las torres
      addi s2, s2, 32
      addi s3, s3, 32
      addi s4, s4, 1          # Incrementa i
      jal for
			
endfor:
      addi s1, s1, -32       # Decrementa el puntero s1 para apuntar al primer disco
      
      jal hanoi               # Llama a la funcion hanoi despues de inicializar los discos
      jal exit                # Sale del algoritmo despues de ejecutarlo

hanoi: 
      bne s0, a1, else        # Condicion if para verificar si n es igual a 1

      sw zero, 0(s1)          # Mueve el disco de la torre origen a la torre destino (pop disc)
      sw s0, 0(s3)            # (push disk)
      addi a0, a0, 1          # Incrementa el contador de movimientos

      jalr ra

else:
      addi sp, sp, -20        # 1ra llamada a la funcion hanoi (Guarda los registros en la pila)
      sw s0, 0(sp)		#valor de n en esta llamada 
      sw ra, 4(sp)		#ra, para volver
      sw s1, 8(sp)		#apuntador a la torre 1
      sw s2, 12(sp)		#apuntador a la torre 2
      sw s3, 16(sp)		#apuntador a la torre 3
      
      addi s0, s0, -1		# Decrementa n
      addi s1, s1, -32		# Actualiza punteros
      addi s2, s2, -32
      addi s3, s3, -32
      
      addi s9, s2, 0		# almacenamos tower2 de forma temporal temp = tower2
      addi s2, s3, 0            # tower2 = tower3 (ahora tower 3 es middle tower)
      addi s3, s9, 0            # tower3 = temp	(ahora start es )
      jal hanoi			# Realiza la llamada recursiva a hanoi
      
      lw s0, 0(sp)            # Restaura los registros de la pila
      lw ra, 4(sp)
      lw s1, 8(sp)
      lw s2, 12(sp)
      lw s3, 16(sp)
      addi sp, sp, 20
      
      sw zero, 0(s1)	#popear (guardar 0 hasta la cima de s1 (start))
      sw s0, 0(s3)	#Mueve el disco de la torre origen a la torre destino (start to end)
      addi a0, a0, 1    # Incrementa el contador de movimientos
      
      addi sp, sp, -20        # 2da llamada a la funcion hanoi (Guarda los registros en la pila)
      sw s0, 0(sp)		
      sw ra, 4(sp)
      sw s1, 8(sp)
      sw s2, 12(sp)
      sw s3, 16(sp)
      
      addi s9, s1, 0		# Actualiza las torres para la segunda llamada
      addi s1, s2, 0 		# start = middle (la torre aux será start la siguiente recursion)
      addi s2, s9, 0		# middle = start (la torre de en medio sera start)
      				#end sigue siendo end
      addi s0, s0, -1         	# Decrementa n
      
      addi s1, s1, -32         # Actualiza punteros
      addi s2, s2, -32
      addi s3, s3, -32
      
      jal hanoi               # Realiza la segunda llamada recursiva a hanoi
      
      lw s0, 0(sp)            # Restaura los registros de la pila
      lw ra, 4(sp)
      lw s1, 8(sp)
      lw s2, 12(sp)
      lw s3, 16(sp)
      addi sp, sp, 20
      
      jalr ra                  # Salta a la direccion de retorno

inicio:
      lui s1, 0x10010         # Inicializa puntero a la Torre 1 (primer dirección de ram)
      addi a1, zero, 1        # Registro para el caso default (n=1)
      addi a2,zero,4		##offset entre torres (vertical =4bytes)
      #slli a2, s0, 2      # Calcula el offset para cada torre (como es vertical, no se usa)
      add s2, s1, a2          # Torre 2 auxiliar (+4)
      add s3, s2, a2          # Torre 3 Destino (+4)
      jalr ra 
	
inicializacion:
      addi s2, s2, -32         # Como queremos apuntar al final de los arreglos, nuestro for apuntara a la posicion
                              # n+1, recortamos esa distancia 
      addi s3, s3, -32
      jalr ra

exit: 
      nop
