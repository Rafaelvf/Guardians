#!/bin/bash

# Rafael Vieira Falcão - 113110905

touch temp.txt #Arquivo Temporário
cat calgary_access_log | grep 'local - - \|remote - - ' > temp.txt #Eliminação das linhas segundo a questão 4 e colocar retorno no arquivo temporário
cp temp.txt calgary_access_log #Copiar o arquivo temporário no arquivo padrão
rm temp.txt #Remover arquivo temporário

locais=$(grep -n local calgary_access_log | wc -l) #Número de requisições locais
remotas=$(grep -n remote calgary_access_log | wc -l) #Número de requisições remotas
echo "Número de requisições locais: $locais"
echo "Número de requisições remotas: $remotas"

while read line; do #Leitura linha por linha do arquivo padrão
    if [[ "$line" =~ "local" ]] #Se a linha for uma requisição local
    then
        IFS=':' read -r -a array <<< "$line" #Transforma a linha em um array de acordo com o separador ':'
        ((totalHoursLocal += 10#${array[1]})) #Adiciona a hora ao total de horas de requisições locais
    elif [[ "$line" =~ "remote" ]] #Se a linha for uma requsição remota
    then
        IFS=':' read -r -a array <<< "$line" #Transforma a linha em um array de acordo com o separador ':'
        ((totalHoursRemote += 10#${array[1]})) #Adiciona a hora ao totoal de horas de requisições remotas
    fi
done < calgary_access_log

mediaHorasLocal=$(((totalHoursLocal/locais))) #Cálculo da média de requisições locais
mediaHorasRemota=$(((totalHoursRemote/remotas))) #Cálculo da média de requisições remotas

echo "Média de hora em requisições locais são feitas: $mediaHorasLocal"
echo "Média de hora em requisições remotas são feitas: $mediaHorasRemota"

if test $locais -gt $remotas #Confere se o número de requisições locais é maior que o número de requsiçoes remotas
then 
    echo "Foram realizadas mais requisições locais do que remotas"
elif test $locais -lt $remotas #Confere se o número de requisições locais é menor que o número de requsiçoes remotas
then
    echo "Foram realizadas mais requisições remotas do que locais"
else #Caso para se o número de requisições remotas e locais forem o mesmo
    echo "Foram realizadas o mesmo número de requisições (Locais e Remotas)"
fi
