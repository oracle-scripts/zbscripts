# Documentação de Uso dos Scripts: lb_status.sh e waf_status.sh

## Descrição

Este repositório contém duas ferramentas de linha de comando para verificar o estado de saúde de Load Balancers e Web Application Firewalls (WAF) na Oracle Cloud Infrastructure (OCI).

### lb_status.sh

O script `lb_status.sh` é projetado para monitorar Load Balancers, oferecendo duas funcionalidades principais:

1. **Verificar o Estado do Load Balancer (check_lb_status)**: Verifica se o Load Balancer está ativo e funcionando corretamente.
2. **Verificar a Saúde dos Backends (check_backend_health)**: Fornece um relatório detalhado sobre a saúde de cada Backend Set e seus backends.

### waf_status.sh

O script `waf_status.sh` é utilizado para monitorar Web Application Firewalls, com as seguintes funcionalidades:

1. **Verificar o Estado do WAF (check_waf_status)**: Verifica o estado geral do WAF, informando se está ativo e operacional.
2. **Verificar o Estado da Política do WAF (check_waf_policy_lifecycle_state)**: Avalia o estado da política de WAF associada, incluindo seu nome e status.

## Pré-requisitos

- Oracle Cloud Infrastructure Command Line Interface (OCI CLI) instalada e configurada.
- `jq` instalado para processamento de dados JSON.
- Acesso apropriado à OCI para consultar informações sobre Load Balancers e WAFs.

## Como Usar

### Execução dos Scripts

Ambos os scripts podem ser executados a partir da linha de comando. É necessário fornecer o OCID do recurso (Load Balancer ou WAF) e o nome da função desejada.

### Formato do Comando

Para `lb_status.sh`:

```bash
./lb_status.sh <OCID_Load_Balancer> <Nome_da_Função>
```

Para `waf_status.sh`:

```bash
./waf_status.sh <OCID_WAF> <Nome_da_Função>
```

Substitua `<OCID_Load_Balancer>` ou `<OCID_WAF>` pelo OCID apropriado e `<Nome_da_Função>` pela função desejada.

### Exemplos

- **Load Balancer**:

  - Verificar estado: `./lb_status.sh ocid1.loadbalancer.oc1... check_lb_status`
  - Verificar saúde dos backends: `./lb_status.sh ocid1.loadbalancer.oc1... check_backend_health`

- **Web Application Firewall**:
  - Verificar estado do WAF: `./waf_status.sh ocid1.webappfirewall.oc1... check_waf_status`
  - Verificar estado da política do WAF: `./waf_status.sh ocid1.webappfirewall.oc1... check_waf_policy_lifecycle_state`

### Interpretação dos Resultados

- **Load Balancer**:

  - `check_lb_status`: Indica "ACTIVE" se estiver funcionando corretamente.
  - `check_backend_health`: Relatório detalhado da saúde dos backends.

- **Web Application Firewall**:
  - `check_waf_status`: Indica "ACTIVE" se o WAF estiver operacional.
  - `check_waf_policy_lifecycle_state`: Mostra o nome e o estado da política do WAF.

## Conclusão

Os scripts `lb_status.sh` e `waf_status.sh` são ferramentas valiosas para o monitoramento de Load Balancers e Web Application Firewalls na Oracle Cloud Infrastructure, proporcionando uma visão clara sobre o desempenho e a estabilidade destes recursos.
