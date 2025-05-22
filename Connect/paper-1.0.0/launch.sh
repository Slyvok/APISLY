#!/bin/bash
# shellcheck shell=dash
bold=$(echo -en "\e[1m")
lightpurple=$(echo -en "\e[95m")
yellow=$(echo -en "\e[93m")
green=$(echo -en "\e[92m")
red=$(echo -en "\e[91m")
normal=$(echo -en "\e[0m")

# Função para obter versão da API do Egg com validação
get_api_version() {
    local response
    response=$(curl -s --max-time 3 http://200.9.155.163:25566/egg-version)
    if echo "$response" | grep -q '"version"'; then
        echo "$response" | grep -oP '"version"\s*:\s*"\K[^"]+'
    else
        echo "Erro ao obter versão"
    fi
}

# Obter versão da API do Egg
EGG_API_VERSION=$(get_api_version)

# Definir memória disponível, se não definida
if [ -z "${MEMORY_AVAILABLE}" ]; then
    MEMORY_AVAILABLE=$(free -m | awk '/^Mem:/{print $2}')
fi

# Validar variável de otimização e definir comando START
if [ -z "${OPTIMIZE}" ]; then
    OPTIMIZE="(0) Geral"
fi

if [ "${OPTIMIZE}" = "(0) Geral" ]; then
    START="java -Xms128M -Xmx${MEMORY_AVAILABLE}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE:-server.jar}"

elif [ "${OPTIMIZE}" = "(1) 1GB RAM" ]; then
    START="java -Xmx1G -Xms1G -Xmn128m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE:-server.jar}"

elif [ "${OPTIMIZE}" = "(2) 2GB RAM" ]; then
    START="java -Xms2G -Xmx2G -Xmn384m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE:-server.jar}"

elif [ "${OPTIMIZE}" = "(3) 3GB RAM" ]; then
    START="java -Xms3G -Xmx3G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE:-server.jar}"

elif [ "${OPTIMIZE}" = "(4) 4+GB RAM" ]; then
    START="java -Xms3584M -Xmx4G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -jar ${SERVER_JARFILE:-server.jar}"

elif [ "${OPTIMIZE}" = "(5) 4GB RAM / 4threads / 4cores" ]; then
    START="java -Xms2G -Xmx2G -Xmn384m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UseCompressedOops -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=4 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE:-server.jar}"

elif [ "${OPTIMIZE}" = "(6) 8+GB RAM / 8threads / 4cores" ]; then
    START="java -Xms4G -Xmx4G -Xmn512m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE:-server.jar}"

elif [ "${OPTIMIZE}" = "(7) 12+GB RAM" ]; then
    START="java -Xms11G -Xmx11G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE:-server.jar}"
fi
# Exibir informações formatadas
# Interface
clear
echo "${lightpurple}╔════════════════════════════════════════════════════════════════════════════════╗${normal}"
echo "${lightpurple}║${normal}                           ${bold}⚙️  Informações do Servidor  ⚙️${normal}                           ${lightpurple}║${normal}"
echo "${lightpurple}╠════════════════════════════════════════════════════════════════════════════════╣${normal}"

printf "${lightpurple}║${normal}  🕹️  Versão da API Minecraft:  ${green}${bold}%-20s${normal}${lightpurple}                                         ║${normal}\n" "${MC_API_VERSION:-Indefinido}"
printf "${lightpurple}║${normal}  💾 Memória disponível:        ${green}${bold}%-6s MB${normal}${lightpurple}                                                 ║${normal}\n" "$MEMORY_AVAILABLE"
printf "${lightpurple}║${normal}  🥚 Versão da API do Egg:       ${green}${bold}%-20s${normal}${lightpurple}                                         ║${normal}\n" "$EGG_API_VERSION"
printf "${lightpurple}║${normal}  🚀 Otimização escolhida:      ${yellow}${bold}%-30s${normal}${lightpurple}                                   ║${normal}\n" "$OPTIMIZE"

echo "${lightpurple}╠════════════════════════════════════════════════════════════════════════════════╣${normal}"
echo "${lightpurple}║${normal}  📝 Comando de inicialização:${normal}"

echo "$START" | fold -s -w 78 | sed "s/^/${lightpurple}║${normal}  /"

echo "${lightpurple}╠════════════════════════════════════════════════════════════════════════════════╣${normal}"
echo "${lightpurple}║${normal}  © ${red}SlyProductions${normal}                                                             ${lightpurple}║${normal}"
echo "${lightpurple}╚════════════════════════════════════════════════════════════════════════════════╝${normal}"
echo

# Contagem regressiva
echo "${bold}⏳ Servidor iniciando em 5 segundos...${normal}"
for i in 5 4 3 2 1 Iniciando Servidor...; do
    echo "${yellow}${i}...${normal}"
    sleep 1
done

# Iniciar servidor
exec $START
