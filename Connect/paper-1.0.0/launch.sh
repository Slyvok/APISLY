#!/bin/bash
# shellcheck shell=dash

clear

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
green=$(echo -en "\e[92m")
yellow=$(echo -en "\e[93m")
red=$(echo -en "\e[91m")
cyan=$(echo -en "\e[96m")
normal=$(echo -en "\e[0m")

# Função para imprimir uma barra de loading animada
loading_animation() {
    local duration=$1
    local interval=0.2
    local iterations=$((duration / interval))
    local i=0
    local spinner='|/-\'

    echo -ne "${cyan}Carregando "
    while [ $i -lt $iterations ]; do
        local spin_char=${spinner:i%4:1}
        echo -ne "$spin_char"
        sleep $interval
        echo -ne "\b"
        i=$((i + 1))
    done
    echo -e "${normal}"
}

# Função para imprimir a interface mais detalhada
print_interface() {
    clear
    echo -e "${bold}${lightblue}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║                       🚀 INICIALIZANDO SERVIDOR MC 🚀                 ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Otimização selecionada: ${yellow}${OPTIMIZE:-"Padrão"}${lightblue}                                        ║"
    echo "║ Memória alocada:       ${yellow}${SERVER_MEMORY:-"Indefinida"} MB${lightblue}                                  ║"
    echo "║ Arquivo do servidor:   ${yellow}${SERVER_JARFILE:-"Indefinido"}${lightblue}                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Status da API:                                                      ║"
    echo "║   $API_STATUS                                                    ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Status do Egg:                                                      ║"
    echo "║   $EGG_STATUS                                                    ║"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Plugins:                                                           ║"
    if [ "${ALLOW_PLUGINS}" = "1" ]; then
        echo "║   ${green}Permitidos e ativados${lightblue}                                                   ║"
    else
        echo "║   ${red}Desativados (serão removidos se existirem)${lightblue}                              ║"
    fi
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo "║ Notificações:                                                      ║"
    # Exemplo de notificações, você pode ajustar conforme necessidade
    if [ "${ALLOW_PLUGINS}" = "0" ] && [ -d "plugins" ] && ls plugins/*.jar 1> /dev/null 2>&1; then
        echo "║ ${yellow}⚠️ Plugins encontrados mas não permitidos, removidos.${lightblue}                    ║"
    else
        echo "║ ${green}✔ Nenhuma ação pendente.${lightblue}                                                  ║"
    fi
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Variáveis e URLs para as versões
LOCAL_VERSION_FILE=".version"
REMOTE_EGG_VERSION_URL="https://raw.githubusercontent.com/Slyvok/Slyvok_PteroEggs/main/Paper%20Otimizado%201.0.1/.version"
API_VERSION_URL="http://200.9.155.163:25566/version"

# Verifica API
API_RESPONSE=$(curl -s --max-time 5 "$API_VERSION_URL")
if echo "$API_RESPONSE" | grep -q "version"; then
    API_VERSION=$(echo "$API_RESPONSE" | grep -oP '"name"\s*:\s*"\K[^"]+')
    API_STATUS="${green}✅ API detectada: ${bold}${API_VERSION}${normal}${lightblue}"
else
    API_STATUS="${red}❌ Não foi possível obter a versão da API.${normal}${lightblue}"
fi

# Verifica Egg
if [ -f "$LOCAL_VERSION_FILE" ]; then
    LOCAL_VERSION=$(cat "$LOCAL_VERSION_FILE")
    REMOTE_VERSION=$(curl -s --max-time 5 "$REMOTE_EGG_VERSION_URL")
    if [ -n "$REMOTE_VERSION" ]; then
        if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
            EGG_STATUS="${yellow}⚠️ Atualização disponível! Local: ${LOCAL_VERSION}, Remoto: ${REMOTE_VERSION}${normal}"
        else
            EGG_STATUS="${green}✅ Versão do Egg atualizada: ${LOCAL_VERSION}${normal}"
        fi
    else
        EGG_STATUS="${red}❌ Falha ao obter versão remota do Egg.${normal}"
    fi
else
    EGG_STATUS="${red}⚠️ Arquivo .version não encontrado.${normal}"
fi

# Plugins permitidos?
if [ "${ALLOW_PLUGINS}" = "0" ]; then
    if [ -d "plugins" ]; then
        if ls plugins/*.jar 1> /dev/null 2>&1; then
            echo -e "${yellow}⚠️ Plugins encontrados mas plugins não permitidos. Removendo...${normal}"
            rm -f plugins/*.jar
        fi
    fi
fi

# Define o comando START conforme otimização
if [ -z "${OPTIMIZE}" ]; then
    # Padrão, caso OPTIMIZE não esteja definido
    START="java -Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}"
else
    case "${OPTIMIZE}" in
        "(0) Geral")
            START="java -Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}"
            ;;
        "(1) 1GB RAM")
            START="java -Xmx1G -Xms1G -Xmn128m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"
            ;;
        "(2) 2GB RAM")
            START="java -Xms2G -Xmx2G -Xmn384m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"
            ;;
        "(3) 3GB RAM")
            START="java -Xms3G -Xmx3G -Xmn512m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"
            ;;
        "(4) 4GB RAM")
            START="java -Xms4G -Xmx4G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"
            ;;
        *)
            # Caso não reconheça, usa padrão
            START="java -Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}"
            ;;
    esac
fi

print_interface
loading_animation 5

echo -e "${green}Iniciando servidor...${normal}"
echo ""

# Execução do comando para iniciar o servidor
eval "$START"

