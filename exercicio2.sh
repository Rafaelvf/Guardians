#!/bin/bash

# Rafael Vieira Falcão - 113110905

function infoProcesses() {
    N=$1 # Numero de observações
    S=$2 # Intervalo de tempo
    P_USER=$3 # Começo do nome de um usuário
    
    if  [ -z "$N" ] || [ -z "$S" ] || [ -z "$P_USER" ] || [ "$N" -le 0 ] || [ "$S" -le 0 ]; then # Verifica se alguma das entradas é vazia ou se o valor de N ou S é menor ou igual a zero.
        exit 1 # Caso a verificação dê o resultado 'true', o programa sai com a saída 1
    fi
    
    > temp1.txt; # Criação do arquivo temp1.txt
    > temp2.txt; # Criação do arquivo temp2.txt
    counter=0 # Inicialização do contador
    while test $counter -ne $N; do # Repete o loop N vezes
    
        ps -eo user,pid,pcpu,pmem > temp1.txt # Seleciona as seguintes informações e joga no arquivo temp1.txt: Nome do usuário, ID do processo, A utilização da CPU e a utilização da memória
        cat temp1.txt | grep ^"$P_USER" >> temp2.txt # Filtra os processos em processos executados apenas pelo usuário iniciado pela string P_USER e joga tais processos no arquivo temp2.txt
        sleep $S; # Pausa o programa em S segundos
        echo "" 
        counter=$((counter+1)); # Incrementação do contador
        
        if [ `cat temp2.txt | wc -l` -eq 0 ]  # Verifica se nenhum processo foi listado
        then
            rm temp1.txt # Remove arquivo temp1.txt
            rm temp2.txt # Remove arquivo temp2.txt
            exit 2 # Encerra programa com a saída 2
        else 
        
            echo "-----Execution " $((counter)) "-----" 
            echo "USER - PID - %CPU - %MEM" 
        
            totalCPU=0 # Inicialização da variável de porcentagem total de utilização da CPU
            totalMEM=0 # Inicialização da variável de porcentagem total de utilização da memória
            maiorCPU=0.0 # Inicialização da variável de maior valor de porcentagem de CPU encontrado
            menorCPU=100.0 # Inicialização da variável de menor valor de porcentagem de CPU encontrado
            maiorMEM=0.0 # Inicialização da variável de maior valor de porcentagem de memória encontrado
            menorMEM=100.0 # Inicialização da variável de menor valor de porcentagem de memória encontrado
            numProcesses=0 # Inicialização da variável de número total de processos

            while read line; do # Ler cada linha do arquivo temp2.txt
                IFS=' ' read -r -a array <<< "$line" # Transforma a linha em um array utilizando o separador ' '
                
                if [ "$(echo $maiorCPU '<' ${array[2]} | bc -l)" -eq 1 ]; # Verifica se foi achado um valor de porcentagem de CPU maior
                then
                    maiorCPU=${array[2]} # Maior valor de porcentagem de CPU atualizado
                    idMaiorCPU=${array[1]} # Variável guarda ID do processo de maior utilização de CPU.
                fi
                
                if [ "$(echo $menorCPU '>' ${array[2]} | bc -l)" -eq 1 ]; # Verifica se foi achado um valor de porcentagem de CPU menor
                then
                    menorCPU=${array[2]} # Menor valor de porcentagem de CPU atualizado
                    idMenorCPU=${array[1]} # Variável guarda ID do processo de menor utilização de CPU.
                fi
                
                if [ "$(echo $maiorMEM '<' ${array[3]} | bc -l)" -eq 1 ]; # Verifica se foi achado um valor de porcentagem de memória maior
                then
                    maiorMEM=${array[3]} # Maior valor de porcentagem de memória atualizado
                    idMaiorMEM=${array[1]} # Variável guarda ID do processo de maior utilização de memória.
                fi
                
                if [ "$(echo $menorMEM '>' ${array[3]} | bc -l)" -eq 1 ]; # Verifica se foi achado um valor de porcentagem de memória menor
                then
                    menorMEM=${array[3]} # Menor valor de porcentagem de memória atualizado
                    idMenorMEM=${array[1]} # Variável guarda ID do processo de menor utilização de memória.
                fi                
                
                totalCPU=$(echo "$totalCPU + ${array[2]}" | bc) # Variável de porcentagem total de utilização da CPU atualizada
                totalMEM=$(echo "$totalMEM + ${array[3]}" | bc) # Variável de porcentagem total de utilização da memória atualizada
                echo ${array[0]} ${array[1]} ${array[2]} ${array[3]} # Informações a cerca do processo printados para o usuário
                
                numProcesses=$((numProcesses+1)); # Variável de número total de processos incrementada
        done < temp2.txt
        fi
        
        mediaCPU=$(echo $totalCPU/$numProcesses | bc -l) # Variável que realiza a média da porcentagem de CPU utilizada
        mediaMEM=$(echo $totalMEM/$numProcesses | bc -l) # Variável que realiza a média da porcentagem de memória utilizada
        
        echo "" 
        echo "Numero total de processos analisados: " $numProcesses # Número 
        echo ""
        echo "Total %CPU: " $totalCPU 
        echo "ID do processo com maior %CPU, %CPU do processo: " $idMaiorCPU "," $maiorCPU 
        echo "ID do processo com menor %CPU, %CPU do processo: " $idMenorCPU "," $menorCPU
        echo "Media %CPU: " $mediaCPU
        echo "" 
        echo "Total %MEM: " $totalMEM
        echo "Media %MEM: " $mediaMEM
        echo "ID do processo com maior %MEM, %MEM do processo: " $idMaiorMEM "," $maiorMEM 
        echo "ID do processo com menor %MEM, %MEM do processo: " $idMenorMEM "," $menorMEM
        > temp1.txt; # Arquivo temp1.txt zerado
        > temp2.txt; # Arquivo temp2.txt zerado
    done
    
    rm temp1.txt # Remove arquivo temp1.txt
    rm temp2.txt # Remove arquivo temp2.txt
}

echo Digite o número de observações a serem feitas:
read N;
echo Digite um intervalo de tempo em segundos:
read S;
echo Digite o começo de nome de um usuário:
read P_USER

infoProcesses $N $S $P_USER
