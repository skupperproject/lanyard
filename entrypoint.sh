#!/bin/sh

# Se nenhum argumento for fornecido, iniciar um shell interativo
if [ "$#" -eq 0 ]; then
    exec /bin/sh
else
    # Executar o comando fornecido
    exec "$@"
fi

