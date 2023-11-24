#!/bin/bash

LOAD_BALANCER_OCID=$1
FUNCTION_NAME=$2

function check_lb_status {
    LB_STATUS=$(oci lb load-balancer get --load-balancer-id $LOAD_BALANCER_OCID | jq '.data."lifecycle-state"' | cut -d'"' -f2)

    if [ "$LB_STATUS" != "ACTIVE" ]; then
        echo "Load Balancer status: $LB_STATUS"
        exit 2
    else
        echo "Load Balancer status: $LB_STATUS"
        exit 0
    fi
}

function check_backend_health {
    EXIT_CODE=0  # Inicialmente definido como sucesso
    OUTPUT=""  # String para armazenar a saída consolidada

    # Obtendo a lista de todos os Backend Sets
    BACKEND_SETS=$(oci lb backend-set list --load-balancer-id $LOAD_BALANCER_OCID | jq -r '.data[] | .name')

    # Verificando a saúde de cada Backend Set
    for BACKEND_SET_NAME in $BACKEND_SETS; do
        # Listando todos os backends no Backend Set
        BACKENDS_JSON=$(oci lb backend list --load-balancer-id $LOAD_BALANCER_OCID --backend-set-name $BACKEND_SET_NAME)

        # Verifica se há backends no Backend Set
        if [ "$(echo $BACKENDS_JSON | jq '.data | length')" -eq 0 ]; then
            OUTPUT+="Backend Set $BACKEND_SET_NAME: Não contém backends ou não foi possível recuperar informações\n"
            EXIT_CODE=2
            continue
        fi

        BACKENDS=$(echo $BACKENDS_JSON | jq -r '.data[] | .name')

        for BACKEND_NAME in $BACKENDS; do
            # Verificando a saúde do backend
            BACKEND_HEALTH=$(oci lb backend-health get --load-balancer-id $LOAD_BALANCER_OCID --backend-set-name $BACKEND_SET_NAME --backend-name $BACKEND_NAME | jq '.data.status')

            # Verificando o status do backend
            if [ "$BACKEND_HEALTH" != '"OK"' ]; then
                OUTPUT+="Backend Set $BACKEND_SET_NAME, Backend $BACKEND_NAME: Problema detectado (Status: $BACKEND_HEALTH)\n"
                EXIT_CODE=2
            else
                OUTPUT+="Backend Set $BACKEND_SET_NAME, Backend $BACKEND_NAME: Saudável\n"
            fi
        done
    done

    echo -e $OUTPUT
    exit $EXIT_CODE
}

function check_listeners_health {
    EXIT_CODE=0  # Inicialmente definido como sucesso
    OUTPUT=""    # String para armazenar a saída consolidada

    # Obtendo a lista de todos os Listeners
    LISTENERS=$(oci lb listener list --load-balancer-id $LOAD_BALANCER_OCID | jq -r '.data[] | .name')

    # Verifica se há listeners
    if [ -z "$LISTENERS" ]; then
        echo "Não foram encontrados listeners para o Load Balancer."
        exit 2
    fi

    # Verificando a saúde de cada Listener
    for LISTENER_NAME in $LISTENERS; do
        # Para cada Listener, verificar o status (neste exemplo, estamos apenas verificando a existência, ajuste conforme necessário)
        if [ -n "$LISTENER_NAME" ]; then
            OUTPUT+="Listener $LISTENER_NAME: Encontrado\n"
        else
            OUTPUT+="Listener $LISTENER_NAME: Problema detectado\n"
            EXIT_CODE=2
        fi
    done

    echo -e "$OUTPUT"
    exit $EXIT_CODE
}

# Executa a função baseada no segundo argumento
if [ "$FUNCTION_NAME" == "check_lb_status" ]; then
    check_lb_status
elif [ "$FUNCTION_NAME" == "check_backend_health" ]; then
    check_backend_health
elif [ "$FUNCTION_NAME" == "check_listeners_health" ]; then
    check_listeners_health
else
    echo "Função desconhecida: $FUNCTION_NAME"
    exit 1
fi