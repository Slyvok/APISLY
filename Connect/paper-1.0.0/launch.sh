#!/bin/bash
# shellcheck shell=dash

# Limpa a tela e define cores para a interface
clear

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
green=$(echo -en "\e[92m")
yellow=$(echo -en "\e[93m")
red=$(echo -en "\e[91m")
normal=$(echo -en "\e[0m")

# Função para desenhar a interface inicial
print_interface() {
    clear
    echo -e "${bold}${lightblue}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║                                                      ║"
    echo "║             🚀  INICIALIZANDO SERVIDOR MC 🚀        ║"
    echo "║                                                      ║"
    echo "╠══════════════════════════════════════════════════════╣"
    echo "║                                                      ║"
    echo "║  Otimização selecionada: ${yellow}${OPTIMIZE:-"Padrão"}${lightblue}                ║"
    echo "║                                                      ║"
    echo "╠══════════════════════════════════════════════════════╣"
    echo "║                                                      ║"
    echo "║  Status da API:                                      ║"
    echo "║                                                      ║"
    echo "║  $API_STATUS                                         ║"
    echo "║                                                      ║"
    echo "╠══════════════════════════════════════════════════════╣"
    echo "║                                                      ║"
    echo "║  Status do Egg:                                      ║"
    echo "║                                                      ║"
    echo "║  $EGG_STATUS                                         ║"
    echo "║                                                      ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""
}

# Define a variável de start do java conforme otimização
if [ -z "${OPTIMIZE}" ]; then
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
            START="java -Xms3G -Xmx3G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"
            ;;
        "(4) 4+GB RAM")
            START="java -Xms3584M -Xmx4G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -jar ${SERVER_JARFILE}"
            ;;
        "(5) 4GB RAM / 4threads / 4cores")
            START="java -Xms2G -Xmx2G -Xmn384m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UseCompressedOops -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=4 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}"
            ;;
        "(6) 8+GB RAM / 8threads / 4cores")
            START="java -Xms4G -Xmx4G -Xmn512m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}"
            ;;
        "(7) 12+GB RAM")
            START="java -Xms11G -Xmx11G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}"
            ;;
        *)
            # Padrão se não reconhecido
            START="java -Xms128M -Xmx${SERVER_MEMORY}M -jar ${SERVER_JARFILE}"
            ;;
    esac
fi

# Plugins permitidos?
if [ "${ALLOW_PLUGINS}" = "0" ]; then
    if [ -d "plugins" ]; then
        if ls plugins/*.jar 1> /dev/null 2>&1; then
            echo -e "${yellow}⚠️  Aviso: Plugins instalados, mas plugins não permitidos. Removendo...${normal}"
            rm -f plugins/*.jar
        fi
    fi
fi

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
            EGG_STATUS="${yellow}⚠️ Atualização disponível! Versão local: ${LOCAL_VERSION}, remota: ${REMOTE_VERSION}${normal}"
            print_interface
            echo -e "${yellow}⛔ Aviso: Atualização disponível, mas a inicialização continuará.${normal}"
            # NÃO encerra o script
        else
            EGG_STATUS="${green}✅ Você está usando a versão mais recente do Egg: ${LOCAL_VERSION}${normal}"
        fi
    else
        EGG_STATUS="${red}❌ Não foi possível verificar a versão remota do Egg.${normal}"
    fi
else
    EGG_STATUS="${red}⚠️ Arquivo .version não encontrado.${normal}"
    print_interface
    echo -e "${yellow}⚠️ Aviso: Arquivo de versão local não encontrado, inicialização continuará.${normal}"
fi

# Imprime interface final
print_interface

# Inicia o servidor
echo -e "${green}Iniciando servidor com o comando:${normal} ${START}"
exec $START
