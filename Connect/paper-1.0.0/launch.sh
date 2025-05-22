#!/bin/bash

# Definição de cores e estilos
reset="\e[0m"
bold="\e[1m"
lightblue="\e[94m"
yellow="\e[93m"
green="\e[92m"
purple="\e[95m"

# Configurações padrão (altere aqui se quiser)
ALLOW_PLUGINS=1          # 1 = plugins permitidos e ativados, 0 = plugins desativados (não excluídos)
SERVER_MEMORY=16384      # Memória em MB
SERVER_JARFILE="server.jar"
OPTIMIZE=6               # Otimização selecionada (de 1 a 6)

# Otimizações disponíveis
declare -A OPTIMIZATIONS
OPTIMIZATIONS[1]="1GB RAM / 1 thread / 1 core"
OPTIMIZATIONS[2]="4GB RAM / 2 threads / 2 cores"
OPTIMIZATIONS[3]="6GB RAM / 4 threads / 2 cores"
OPTIMIZATIONS[4]="8GB RAM / 4 threads / 4 cores"
OPTIMIZATIONS[5]="12GB RAM / 6 threads / 4 cores"
OPTIMIZATIONS[6]="16GB RAM / 8 threads / 4 cores"

# Descrição da otimização escolhida
OPTIMIZE_DESC="${OPTIMIZATIONS[$OPTIMIZE]}"

print_interface() {
    clear
    echo -e "${bold}${lightblue}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║                       🚀 INICIALIZANDO SERVIDOR MC 🚀                 ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    # Otimização
    printf "║ Otimização selecionada: ${yellow}%-53s${lightblue} ║\n" "$OPTIMIZE_DESC"
    # Memória
    printf "║ Memória alocada:       ${yellow}%-53s${lightblue} ║\n" "${SERVER_MEMORY} MB"
    # Arquivo do servidor
    printf "║ Arquivo do servidor:   ${yellow}%-53s${lightblue} ║\n" "$SERVER_JARFILE"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Status da API:                                                      ║"
    echo "║   ✅ API detectada                                                    ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Status do Egg:                                                      ║"
    echo "║   ⚠️ Arquivo .version não encontrado.                                                    ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Plugins:                                                           ║"
    if [ "$ALLOW_PLUGINS" = "1" ]; then
        echo -e "║   ${green}Permitidos e ativados${lightblue}                                               ║"
    else
        echo -e "║   ${yellow}Desativados (não serão executados)${lightblue}                                ║"
    fi
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Notificações:                                                      ║"
    echo -e "║ ${green}✔ Nenhuma ação pendente.${lightblue}                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "\n${purple}✨ SlyProductions - Feito por Slyvok ✨${reset}\n"
}

start_server() {
    if [ "$ALLOW_PLUGINS" = "1" ]; then
        echo -e "${green}Iniciando servidor com plugins ativados...${reset}"
    else
        echo -e "${yellow}Iniciando servidor sem executar plugins...${reset}"
    fi

    # Exemplo de comando para iniciar o servidor:
    # java -Xmx${SERVER_MEMORY}M -jar ${SERVER_JARFILE} nogui
}

# Executa
print_interface
start_server
