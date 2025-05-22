#!/bin/bash

# Cores para estilo
bold="\e[1m"
lightblue="\e[94m"
yellow="\e[93m"
green="\e[92m"
purple="\e[95m"
reset="\e[0m"

# Variáveis padrão (modifique conforme precisar)
OPTIMIZE="6"              # Escolha entre 1 a 6 para otimizações
SERVER_MEMORY=""          # Será preenchido pela otimização
SERVER_JARFILE="server.jar"
ALLOW_PLUGINS="1"         # 1 = executar plugins, 0 = não executar plugins

# Função que imprime a interface
print_interface() {
    clear
    echo -e "${bold}${lightblue}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║                       🚀 INICIALIZANDO SERVIDOR MC 🚀                 ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Otimização selecionada: ${yellow}${OPTIMIZE_DESC}${lightblue}                                      ║"
    echo "║ Memória alocada:       ${yellow}${SERVER_MEMORY} MB${lightblue}                                ║"
    echo "║ Arquivo do servidor:   ${yellow}${SERVER_JARFILE}${lightblue}                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Status da API:                                                      ║"
    echo "║   $API_STATUS                                                    ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Status do Egg:                                                      ║"
    echo "║   $EGG_STATUS                                                    ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Plugins:                                                           ║"
    if [ "${ALLOW_PLUGINS}" = "1" ]; then
        echo "║   ${green}Permitidos e ativados${lightblue}                                               ║"
    else
        echo "║   ${yellow}Desativados (não serão executados)${lightblue}                                ║"
    fi
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Notificações:                                                      ║"
    echo "║ ${green}✔ Nenhuma ação pendente.${lightblue}                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "\n${purple}✨ SlyProductions - Feito por Slyvok ✨${reset}\n"
}

# Definir as otimizações e parâmetros Java
case "$OPTIMIZE" in
    1)
        OPTIMIZE_DESC="2GB RAM / 2 threads / 1 core"
        JAVA_OPTS="-Xmx2G -Xms2G -XX:+UseG1GC -XX:ParallelGCThreads=2 -XX:ActiveProcessorCount=1"
        SERVER_MEMORY="2048"
        ;;
    2)
        OPTIMIZE_DESC="4GB RAM / 4 threads / 2 cores"
        JAVA_OPTS="-Xmx4G -Xms4G -XX:+UseG1GC -XX:ParallelGCThreads=4 -XX:ActiveProcessorCount=2"
        SERVER_MEMORY="4096"
        ;;
    3)
        OPTIMIZE_DESC="6GB RAM / 6 threads / 3 cores"
        JAVA_OPTS="-Xmx6G -Xms6G -XX:+UseG1GC -XX:ParallelGCThreads=6 -XX:ActiveProcessorCount=3"
        SERVER_MEMORY="6144"
        ;;
    4)
        OPTIMIZE_DESC="7GB RAM / 7 threads / 3 cores"
        JAVA_OPTS="-Xmx7G -Xms7G -XX:+UseG1GC -XX:ParallelGCThreads=7 -XX:ActiveProcessorCount=3"
        SERVER_MEMORY="7168"
        ;;
    5)
        OPTIMIZE_DESC="8GB RAM / 8 threads / 4 cores"
        JAVA_OPTS="-Xmx8G -Xms8G -XX:+UseG1GC -XX:ParallelGCThreads=8 -XX:ActiveProcessorCount=4"
        SERVER_MEMORY="8192"
        ;;
    6)
        OPTIMIZE_DESC="16GB RAM / 8 threads / 4 cores"
        JAVA_OPTS="-Xmx16G -Xms16G -XX:+UseG1GC -XX:ParallelGCThreads=8 -XX:ActiveProcessorCount=4"
        SERVER_MEMORY="16384"
        ;;
    *)
        OPTIMIZE_DESC="Padrão"
        JAVA_OPTS="-Xmx2G -Xms2G"
        SERVER_MEMORY="2048"
        ;;
esac

# Simulação de status (substitua conforme sua lógica real)
API_STATUS="✅ API detectada"
EGG_STATUS="⚠️ Arquivo .version não encontrado."

# Exibe a interface bonitona
print_interface

# Inicia o servidor conforme ativação de plugins
if [ "${ALLOW_PLUGINS}" = "1" ]; then
    echo -e "${green}Iniciando servidor com plugins ativados...${reset}"
    java $JAVA_OPTS -jar "$SERVER_JARFILE" nogui
else
    echo -e "${yellow}Iniciando servidor sem execução de plugins...${reset}"
    # Exemplo genérico para não executar plugins: aqui pode ajustar a forma como o servidor trata isso
    # Muitas vezes não há opção padrão, pode ser renomear pasta plugins, usar flag custom, etc.
    # Aqui só rodamos o servidor normalmente, assumindo que não executa plugins (depende do seu servidor)
    java $JAVA_OPTS -jar "$SERVER_JARFILE" nogui --disable-plugins
fi
