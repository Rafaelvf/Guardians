#!/bin/bash

# Rafael Vieira Falcão - 113110905

NUMEX=$1 # Número do exercício especificado pelo usuário
ALUNO=$2 # Nome do aluno especificado pelo usuário

ALUNO=$(echo $ALUNO | sed "s, ,_,g") # Transforma todo espaço no nome do aluno em underline *Funcionalidade extra*
ALUNO="${ALUNO^^}" # Deixa o nome do aluno todo em maiúsculo deixando finalmente no formato correto *Funcionalidade extra*

if [ -z "$NUMEX" ] && [ -z "$ALUNO" ]; then # Caso o nome do aluno e o número do exercício não seja informado pelo usuário
	
	> temp.txt # Criação de arquivo temporário para salvar todos os arquivos do diretório
	> temp2.txt # Criação de arquivo temporário para salvar todas as entradas a serem executadas pelos exercícios dos alunos
	> temp3.txt # Criação de arquivo temporário para salvar todos os exercícios do usuário
	> saida.txt # Criação de arquivo temporário para salvar as saídas resultantes das entradas executadas nos exercícios dos alunos

	ls >> temp.txt # Passagem do nome de todos os arquivos do diretório para o file temp.txt
	grep '[0123456789]_[0123456789].in$' temp.txt >> temp2.txt # Passagem de todos os arquivos de teste de entrada para o file temp2.txt
	grep '.sh$' temp.txt >> temp3.txt # Passagem de todos os exercicios dos alunos para o arquivo temp3.txt

	while read line1; do # Passar por cada exercício de cada aluno
		
		DELIMITADOR="_[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"
		NOMEALUNO=$(echo $line1 | grep -o "$DELIMITADOR.*" | cut -d'.' -f1) # Salvar o nome do aluno em uma variável
		EXNUM=$(echo $line1 | cut -d'_' -f2) # Salvar o número do exercício em uma variável
		echo "EXERCICIO_"$EXNUM$NOMEALUNO

		while read line2; do # Passar por cada entrada a ser executada em cada exercício

			NUMEROEXERCICIO=$(cut -d'_' -f2 <<< $line2)
			NUMTEST=$(cut -d'_' -f3 <<< $line2 | cut -d'.' -f1)


			if [ "$EXNUM" = "$NUMEROEXERCICIO" ]; then # Verifica se a entrada a ser executada é do mesmo exercício a ser testado no momento

				while read line3 ; do # Passagem por cada linha de entrada
				
				bash "EXERCICIO_"$EXNUM$NOMEALUNO".sh" $line3 >> saida.txt # Salva cada execução no file saida.txt

				done < $line2

				echo "- SAIDA PARA A ENTRADA" $NUMTEST

				while read line4; do # Passa por cada linha da saída

					echo $line4

				done < saida.txt

				echo "- DIFERENCA PARA A SAIDA ESPERADA:"

				diff saida.txt EXERCICIO_"$EXNUM"_"$NUMTEST".out # Realiza um diff entre a saída resultante da execução de uma entrada e a saída esperada.

				> saida.txt # Zera arquivo de saída
			fi

		done < temp2.txt

	done < temp3.txt

	rm temp.txt # Remoção de arquivo temporário
	rm temp2.txt # Remoção de arquivo temporário
	rm temp3.txt # Remoção de arquivo temporário
	rm saida.txt # Remoção de arquivo temporário
fi
if [[ ! -z "$NUMEX" ]] && [ -z "$ALUNO" ]; then # Verifica se apenas o número do exercício foi informado pelo usuário

	> temp.txt # Criação de arquivo temporário para salvar todos os arquivos do diretório
	> temp2.txt # Criação de arquivo temporário para salvar todas as entradas a serem executadas pelos exercícios dos alunos
	> temp3.txt # Criação de arquivo temporário para salvar todos os exercícios do usuário
	> saida.txt # Criação de arquivo temporário para salvar as saídas resultantes das entradas executadas nos exercícios dos alunos

	ls >> temp.txt # Passagem do nome de todos os arquivos do diretório para o file temp.txt

	grep $NUMEX'_[0123456789].in$' temp.txt >> temp2.txt # Passagem de todos os arquivos de teste de entrada a serem executados para o file temp2.txt
	grep '.sh$' temp.txt >> temp3.txt # Passagem de todos os exercicios dos alunos para o arquivo temp3.txt

	while read line1; do # Passar por cada exercício

		DELIMITADOR="_[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"
		NOMEALUNO=$(echo $line1 | grep -o "$DELIMITADOR.*" | cut -d'.' -f1) # Salvar o nome do aluno em uma variável
		echo "EXERCICIO_"$NUMEX$NOMEALUNO

		while read line2; do # Passar por cada arquivo com entradas a serem executadas

			NUMTEST=$(cut -d'_' -f3 <<< $line2 | cut -d'.' -f1) # Salvar o número do teste em uma variável.

			while read line3; do # Passagem por cada linha de entrada

    			bash "EXERCICIO_"$NUMEX$NOMEALUNO".sh" $line3 >> saida.txt # Salva cada execução no file saida.txt

    		done < "EXERCICIO_"$NUMEX"_"$NUMTEST".in"

			echo "- SAIDA PARA A ENTRADA" $NUMTEST

			while read line4; do # Passa por cada linha da saída

				echo $line4

			done < saida.txt

			echo "- DIFERENCA PARA A SAIDA ESPERADA:"

    		diff saida.txt EXERCICIO_"$NUMEX"_"$NUMTEST".out # Realiza um diff entre a saída resultante da execução de uma entrada e a saída esperada.

			> saida.txt # Zera arquivo de saída

		done < temp2.txt

	done < temp3.txt

	rm temp.txt # Remoção de arquivo temporário
	rm temp2.txt # Remoção de arquivo temporário
	rm temp3.txt # Remoção de arquivo temporário
	rm saida.txt # Remoção de arquivo temporário
fi

if [[ ! -z "$NUMEX" ]] && [[ ! -z "$ALUNO" ]]; then # Verifica se o usuário informou ambos número de exercício e nome do aluno

	echo "EXERCICIO_"$NUMEX"_"$ALUNO":"

    > temp.txt # Criação de arquivo temporário para salvar todos os arquivos do diretório
    > temp2.txt # Criação de arquivo temporário para salvar todas as entradas a serem executadas pelos exercícios dos alunos
    > saida.txt # Criação de arquivo temporário para salvar as saídas resultantes das entradas executadas nos exercícios dos alunos

    ls >> temp.txt # Passagem do nome de todos os arquivos do diretório para o file temp.txt

    grep $NUMEX'_[0123456789].in$' temp.txt >> temp2.txt # Passagem de todos os arquivos de teste de entrada a serem executados para o file temp2.txt

    while read line1; do # Passar por cada exercício

    	NUMTEST=$(cut -d'_' -f3 <<< $line1 | cut -d'.' -f1) # Salva o numero do teste em execução em uma variável
    	
    	while read line2; do # Passar por cada arquivo com entradas a serem executadas

    		bash "EXERCICIO_"$NUMEX"_"$ALUNO".sh" $line2 >> saida.txt # Salva cada execução no file saida.txt

    	done < "EXERCICIO_"$NUMEX"_"$NUMTEST".in"

    	echo "- SAIDA PARA A ENTRADA" $NUMTEST

    	while read line3; do # Passa por cada linha da saída

    		echo $line3

    	done < saida.txt

    	echo "- DIFERENCA PARA A SAIDA ESPERADA:"

    	diff saida.txt EXERCICIO_"$NUMEX"_"$NUMTEST".out # Realiza um diff entre a saída resultante da execução de uma entrada e a saída esperada.

    	> saida.txt

    done < temp2.txt

    rm temp.txt # Remoção de arquivo temporário
	rm temp2.txt # Remoção de arquivo temporário
	rm saida.txt # Remoção de arquivo temporário
fi
