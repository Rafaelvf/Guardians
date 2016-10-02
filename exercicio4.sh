#!/bin/bash

# Rafael Vieira Falcão - 113110905

strace -T $1 > outfile 2>&1 # Passa todo resultado de Strace para um file chamado outfile

> chamadasMaisRealizadas.txt # Criação de um file para salvar as chamadas mais realizadas

TIMES=() #Criação de um array para salvar todos os tempos gastos em cada chamada do sistema

while read line; do # Passa por cada linha do file outfile
	IFS='<' read -r -a TEMPOCHAMADA <<< "$line" # Formataçao do tempo
	TIME=$(echo ${TEMPOCHAMADA[1]} | sed "s,>,,g") # Formataçao do tempo
	TIMES+=("$TIME") # Adicionar tempo 'TIME' ao array 'TIMES'
done < outfile

TIMESSORTED=( $(for el in "${TIMES[@]}" 
do
	echo "$el"
done | sort -r) ) # Ordenar de forma descrescente os tempos e coloca-los do array 'TIMESSORTED'

echo Chamadas:

egrep ${TIMESSORTED[0]} outfile >> chamadasMaisRealizadas.txt # Passar a informação das chamadas que o tempo de duração igual a TIMESSORTED[0]
egrep ${TIMESSORTED[1]} outfile >> chamadasMaisRealizadas.txt # Passar a informação das chamadas que o tempo de duração igual a TIMESSORTED[1]
egrep ${TIMESSORTED[2]} outfile >> chamadasMaisRealizadas.txt # Passar a informação das chamadas que o tempo de duração igual a TIMESSORTED[2]

counter=0 # Contador
while read line2; do # Passa por cada linha do file chamadasMaisRealizadas.txt
	if [ $counter -eq 3 ] # Se a variável 'counter' for igual a três, já foram listadas as três maiores chamadas do sistema
	then
		break
	fi
	echo $line2
	counter=$((counter+1));
done < chamadasMaisRealizadas.txt

NUMCHAMADASERRO=0
while read line3; do # Passa por cada linha do file 'outfile'
	SAIDA=$(echo $line3 | cut -d')' -f2 | cut -d'=' -f2 | cut -d' ' -f2) # Retira o inteiro que representa a saída da chamada
	if [[ "$SAIDA" =~ ^[-+]?([1-9][[:digit:]]*|0)$ && "$SAIDA" -le -1 ]] # Confere se o número retirado é um inteiro válido menor ou igual a -1
	then
		NUMCHAMADASERRO=$((NUMCHAMADASERRO+1))
	fi
done < outfile

echo Numero de syscall com erro: $NUMCHAMADASERRO

rm chamadasMaisRealizadas.txt # Remove file temporário
rm outfile # Remove file temporário
