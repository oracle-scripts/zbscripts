#!/bin/bash

WAF_OCID=$1
FUNCTION_NAME=$2

function check_waf_status {
    # Obtendo o status do WAF
    WAF_STATUS=$(oci waf web-app-firewall get --web-app-firewall-id $WAF_OCID | jq '.data."lifecycle-state"' | cut -d'"' -f2)

    # Verifica se o WAF está ativo
    if [ "$WAF_STATUS" != "ACTIVE" ]; then
        echo "WAF status: $WAF_STATUS"
        exit 2
    else
        echo "WAF status: $WAF_STATUS"
        exit 0
    fi
}

function check_waf_policy_lifecycle_state {
    # Obtendo detalhes do WAF
    WAF_DETAILS=$(oci waf web-app-firewall get --web-app-firewall-id $WAF_OCID)
    WAF_POLICY_ID=$(echo $WAF_DETAILS | jq -r '.data."web-app-firewall-policy-id"')

    if [ -z "$WAF_POLICY_ID" ]; then
        echo "Não foi possível obter o ID da política de WAF."
        exit 2
    fi

    # Obtendo detalhes da política de WAF
    WAF_POLICY_DETAILS=$(oci waf web-app-firewall-policy get --web-app-firewall-policy-id $WAF_POLICY_ID)
    POLICY_LIFECYCLE_STATE=$(echo $WAF_POLICY_DETAILS | jq -r '.data."lifecycle-state"')
    POLICY_NAME=$(echo $WAF_POLICY_DETAILS | jq -r '.data."display-name"')

    # Verificando o lifecycle-state
    if [ "$POLICY_LIFECYCLE_STATE" != "ACTIVE" ]; then
        echo "Política de WAF \"$POLICY_NAME\" $POLICY_LIFECYCLE_STATE"
        exit 2
    else
        echo "Política de WAF \"$POLICY_NAME\" $POLICY_LIFECYCLE_STATE"
        exit 0
    fi
}

# Executa a função baseada no segundo argumento
if [ "$FUNCTION_NAME" == "check_waf_status" ]; then
    check_waf_status
elif [ "$FUNCTION_NAME" == "check_waf_policy_lifecycle_state" ]; then
    check_waf_policy_lifecycle_state
else
    echo "Função desconhecida: $FUNCTION_NAME"
    exit 1
fi