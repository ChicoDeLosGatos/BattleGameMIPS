.globl __start
.data 0x10000000
choose_class: 	.asciiz "Elige una clase de entre las siguientes\n"
nvo:		.asciiz "Esa no es una opcion valida.\n"
classes:	.asciiz "1) Guerrero\n2) Arquero\n3) Mago\n4)Stats de las clases\n5)Salir del juego\n"
stats:		.asciiz "Guerrero:\n\tFuerza: 4\n\tPoder: 3\n\tDefensa: 2\n\tVelocidad: 1\n\tVida: 60\n\nArquero:\n\tFuerza: 3\n\tPoder: 2\n\tDefensa: 1\n\tVelocidad: 4\n\tVida: 40\nMago:\n\tFuerza: 1\n\tPoder: 4\n\tDefensa: 3\n\tVelocidad: 2\n\tVida: 80\n\n"
say_w:		.asciiz "Has elegido un guerrero!\n"
say_a:		.asciiz "Has elegido un arquero!\n"
say_m:		.asciiz "Has elegido un mago!\n"
yeiw:		.asciiz "Tu enemigo es un guerrero.\n\nEmpieza la batalla!\n"
yeia:		.asciiz "Tu enemigo es un arquero.\n\nEmpieza la batalla!\n"
yeim:		.asciiz "Tu enemigo es un mago.\n\nEmpieza la batalla!\n"
iyt:		.asciiz "\nEs tu turno.\n"
cya:		.asciiz "Elige que quieres hacer:\n1) Atacar.\n2) Defender.\n"
ict:		.asciiz "\nEs el turno del enemigo.\n"
ewd:		.asciiz "El enemigo se va a defender.\n"
ewa:		.asciiz "El enemigo va a atacar.\n"
pdef_0:		.asciiz "Consigues "
pdef_1:		.asciiz " puntos de defensa y te preparas para defenderte de cualquier ataque.\n"
pat_0:		.asciiz "Consigues inflingir "
pat_1:		.asciiz " puntos de daño a tu enemigo, dejándole con "
pat_2:		.asciiz " puntos de vitalidad.\n"
cdef_0:		.asciiz "Tu enemigo consigue "
cdef_1:		.asciiz " puntos de defensa y se prepara para defenderse de cualquier ataque.\n"
cat_0:		.asciiz "Tu enemigo te inflinge "
cat_1:		.asciiz " puntos de daño, dejándote con "
cat_2:		.asciiz " puntos de vitalidad.\n"
ploose:		.asciiz "Has perdido."
pwin:		.asciiz "Has ganado."

mc_class:	.word 0
mc_str:		.word 0
mc_pw:		.word 0
mc_spd:		.word 0
mc_def:		.word 0
cpu_class:	.word 0
cpu_str:	.word 0
cpu_pw:		.word 0
cpu_spd:	.word 0
cpu_def:	.word 0

player_moved:	.word 0
cpu_moved:	.word 0

		.text 0x00400000
__start:	li $v0, 4
		la $a0, choose_class
		syscall					# print(choose_class)
		
		li $v0, 4
		la $a0, classes
		syscall					# print(classes)
						
		li $v0, 5
		syscall			
		sw $v0, mc_class			# mc_class = nextInt()
			
		lw $s0, mc_class			# s0 = mc_class
			
							# switch(s0)
		beq $s0, 1, say_warrior				# case 1: say_warrior()
		beq $s0, 2, say_archer				# case 2: say_archer()
		beq $s0, 3, say_mage				# case 3: say_mage()
		beq $s0, 4, say_stats				# case 4: say_stats()
		beq $s0, 5, end_program				# case 5: end_program()
								# case default: menu_error()	

menu_error:	li $v0, 4
		la $a0, nvo
		syscall					# print(nvo)		
		b __start

say_stats:	li $v0, 4
		la $a0, stats
		syscall					# print(stats)
		b __start
		

say_warrior: 	li $v0, 4
		la $a0, say_w
		syscall					# print(say_w)
		b create_w					

say_archer: 	li $v0, 4
		la $a0, say_a
		syscall					# print(say_a)
		b create_a
			 
say_mage: 	li $v0, 4
		la $a0, say_m
		syscall					# print(say_m)
		b create_m
			
						
							# La clase Fighter utiliza los registros del s0 al s7 para los
							# stats del jugador.
							# Fuerza = s0 = s4
							# Poder = s1 = s5
							# Defensa = s2 = s6
							# Velocidad = s3 = s7
							
							# La vida se calcula en base al poder siendo esta Poder*20
							# Este valor será almacenado en los registros t8 y t9
							# tanto para el jugador como para la cpu respectivamente.
							
# --------------------------------------- Constructores del jugador ---------------------------------------							
create_w:	li $t0, 4		
		sw $t0, mc_str
		li $t1, 3
		sw $t1, mc_pw
		li $t2, 2
		sw $t2, mc_def
		li $t3, 1
		sw $t3, mc_spd
		move $s0, $t0
		li $t0, 0
		move $s1, $t1
		li $t1, 0
		move $s2, $t2
		li $t2, 0
		move $s3, $t3
		li $t3, 0
		mul $t8, $s1, 20
		b create_enemy
			
create_a:	li $t0, 3
		sw $t0, cpu_str
		li $t1, 2
		sw $t1, cpu_pw
		li $t2, 1
		sw $t2, cpu_def
		li $t3, 4
		sw $t3, cpu_spd
		move $s0, $t0
		li $t0, 0
		move $s1, $t1
		li $t1, 0
		move $s2, $t2
		li $t2, 0
		move $s3, $t3
		li $t3, 0
		mul $t8, $s1, 20
		b create_enemy
					
create_m:	li $t0, 1
		sw $t0, cpu_str
		li $t1, 4
		sw $t1, cpu_pw
		li $t2, 3
		sw $t2, cpu_def
		li $t3, 2
		sw $t3, cpu_spd
		move $s0, $t0
		li $t0, 0
		move $s1, $t1
		li $t1, 0
		move $s2, $t2
		li $t2, 0
		move $s3, $t3
		li $t3, 0
		mul $t8, $s1, 20
		b create_enemy

# --------------------------------------- Constructores de la CPU ---------------------------------------	
			
								# switch(randomInt(3))
create_enemy:	li $a1, 3  #Maximo
		li $v0, 42  
		syscall
		beq $a0, 1, create_enemy_w				
		beq $a0, 2, create_enemy_a				
		beq $a0, 3, create_enemy_m				
		
create_enemy_w:	li $v0, 4
		la $a0, yeiw
		syscall
		li $t0, 4
		sw $t0, mc_str
		li $t1, 3
		sw $t1, mc_pw
		li $t2, 2
		sw $t2, mc_def
		li $t3, 1
		sw $t3, mc_spd
		move $s4, $t0
		li $t0, 0
		move $s5, $t1
		li $t1, 0
		move $s6, $t2
		li $t2, 0
		move $s7, $t3
		li $t3, 0
		mul $t9, $s5, 20
		b fight
			
create_enemy_a:	li $v0, 4
		la $a0, yeia
		syscall
		li $t0, 3
		sw $t0, cpu_str
		li $t1, 2
		sw $t1, cpu_pw
		li $t2, 1
		sw $t2, cpu_def
		li $t3, 4
		sw $t3, cpu_spd
		move $s4, $t0
		li $t0, 0
		move $s5, $t1
		li $t1, 0
		move $s6, $t2
		li $t2, 0
		move $s7, $t3
		li $t3, 0
		mul $t9, $s5, 20
		b fight
		
create_enemy_m:	li $v0, 4
		la $a0, yeim
		syscall
		li $t0, 1
		sw $t0, cpu_str
		li $t1, 4
		sw $t1, cpu_pw
		li $t2, 3
		sw $t2, cpu_def
		li $t3, 2
		sw $t3, cpu_spd
		move $s4, $t0
		li $t0, 0
		move $s5, $t1
		li $t1, 0
		move $s6, $t2
		li $t2, 0
		move $s7, $t3
		li $t3, 0
		mul $t9, $s5, 20
		b fight

								# fight() será el bucle principal donde se decide
								# el turno del primer jugador en base a su velocidad
								# y también se controlará que no exista ningún turno
								# donde un luchador haya realizado su movimiento
								# y el otro no.
fight:		blez $t8, player_loose
		blez $t9, cpu_loose
		li $t0, 0
		li $t1, 0
		sw $t0, player_moved
		sw $t1, cpu_moved
		ble $s7, $s3 player_turn
		ble $s3, $s7, cpu_turn
					
								# El jugador tiene dos opciones, atacar o defender
								# en base a la opción tomada, la lucha tomará un rumbo
								# u otro.
player_turn:	li $v0, 4
		la $a0, iyt
		syscall
		li $v0, 4
		la $a0, cya
		syscall
		li $v0, 5
		syscall	
		move $t2, $v0
		li $a1, 10  #Maximo
		li $v0, 42  
		syscall
		beq $t2, 1, player_attack
		beq $t2, 2, player_defend
					
player_defend:	li $t3, 0
		mul $t3, $a0, $s2
		li $v0, 4
		la $a0, pdef_0
		syscall
		li $v0, 1
		la $a0, ($t3)
		syscall
		li $v0, 4
		la $a0, pdef_1
		syscall
		b player_end_turn
		
player_attack:	li $t5, 0
		mul $t5, $a0, $s0
		li $v0, 4
		la $a0, pat_0
		syscall
		li $v0, 1
		la $a0, ($t5)
		syscall
		li $v0, 4
		la $a0, pat_1
		syscall
		b cpu_defending
				
cpu_defending:	beqz $t4, attacking_to_cpu
		beqz $t5, player_end_attack
		addi $t4, $t4, -1
		addi $t5, $t5, -1
		b cpu_defending
					
attacking_to_cpu:	beqz $t9, player_win_attack
			beqz $t5, player_end_attack
			addi $t9, $t9, -1
			addi $t5, $t5, -1
			b attacking_to_cpu
				
player_end_attack:	li $v0, 1
			la $a0, ($t9)
			syscall
			li $v0, 4
			la $a0, pat_2
			syscall
			b player_end_turn

player_win_attack:	li $v0, 1
			la $a0, ($t9)
			syscall
			li $v0, 4
			la $a0, pat_2
			syscall
			b cpu_loose
					
player_end_turn:	li $t0, 1
			sw $t0, player_moved
			lw $t1, cpu_moved
			beqz $t1, cpu_turn
			b fight
				
cpu_turn:	li $v0, 4
		la $a0, ict
		syscall
		li $a1, 2  #Maximo(1)
		li $v0, 42  
		syscall	
		move $t2, $a0
		#addi $t2, $t2, 2
		li $a1, 10  #Maximo(2)
		li $v0, 42  
		syscall
		beq $t2, 1, cpu_attack
		beq $t2, 2, cpu_defend
			
cpu_defend:	li $t4, 0
		mul $t4, $a0, $s6
		li $v0, 4
		la $a0, ewd
		syscall	
		li $v0, 4
		la $a0, cdef_0
		syscall
		li $v0, 1
		la $a0,  ($t4)
		syscall
		li $v0, 4
		la $a0, cdef_1
		syscall
		b cpu_end_turn
		
cpu_attack:	li $t6, 0
		mul $t6, $a0, $s4
		li $v0, 4
		la $a0, ewa
		syscall	
		li $v0, 4
		la $a0, cat_0
		syscall
		li $v0, 1
		la $a0, ($t6)
		syscall
		li $v0, 4
		la $a0, cat_1
		syscall
		b player_defending
					
player_defending:	beqz $t3, attacking_to_player
			beqz $t6, cpu_end_attack
			addi $t3, $t3, -1
			addi $t6, $t6, -1
			b player_defending
					
attacking_to_player:	beqz $t8, cpu_win_attack
			beqz $t6, cpu_end_attack
			addi $t8, $t8, -1
			addi $t6,  $t6, -1
			b attacking_to_player
					
cpu_end_attack:	li $v0, 1
		la $a0, ($t8)
		syscall
		li $v0, 4
		la $a0, cat_2
		syscall
		b cpu_end_turn
		
cpu_win_attack:	li $v0, 1
		la $a0, ($t8)
		syscall
		li $v0, 4
		la $a0, cat_2
		syscall
		b player_loose
				
cpu_end_turn:	li $t1, 1
		sw $t1, cpu_moved
		lw $t0, player_moved
		beqz $t0, player_turn
		b fight

player_loose:	li $v0, 4
		la $a0, ploose
		syscall
		b end_program
			
cpu_loose:	li $v0, 4
		la $a0, pwin
		syscall
		b end_program
					
end_program:	li $v0, 10
		syscall
			 
					
