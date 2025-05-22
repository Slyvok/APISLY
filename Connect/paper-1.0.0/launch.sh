#!/bin/bash
# shellcheck shell=dash

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
green=$(echo -en "\e[92m")
yellow=$(echo -en "\e[93m")
red=$(echo -en "\e[91m")
normal=$(echo -en "\e[0m")

if [ -z "${OPTIMIZE}" ]; then
    START="java -Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}"
else
    if [ "${OPTIMIZE}" = "(0) Geral" ]; then
        START="java -Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}"

    elif [ "${OPTIMIZE}" = "(1) 1GB RAM" ]; then
        START="java -Xmx1G -Xms1G -Xmn128m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"

    elif [ "${OPTIMIZE}" = "(2) 2GB RAM" ]; then
        START="java -Xms2G -Xmx2G -Xmn384m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"

    elif [ "${OPTIMIZE}" = "(3) 3GB RAM" ]; then
        START="java -Xms3G -Xmx3G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}"

    elif [ "${OPTIMIZE}" = "(4) 4+GB RAM" ]; then
        START="java -Xms3584M -Xmx4G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -jar ${SERVER_JARFILE}"

    elif [ "${OPTIMIZE}" = "(5) 4GB RAM / 4threads / 4cores" ]; then
        START="java -Xms2G -Xmx2G -Xmn384m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UseCompressedOops -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=4 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}"

    elif [ "${OPTIMIZE}" = "(6) 8+GB RAM / 8threads / 4cores" ]; then
        START="java -Xms4G -Xmx4G -Xmn512m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}"

    elif [ "${OPTIMIZE}" = "(7) 12+GB RAM" ]; then
        START="java -Xms11G -Xmx11G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}"
    fi
fi

if [ "${ALLOW_PLUGINS}" = "0" ]; then
    if [ -d "plugins" ]; then
        if ls plugins/*.jar 1> /dev/null 2>&1; then
            echo "⚠️  Aviso: Plugins foram instalados, mas o servidor está configurado para não permitir plugins."
            rm -f plugins/*.jar
        fi
    fi
fi

LOCAL_VERSION_FILE=".version"
REMOTE_EGG_VERSION_URL="https://raw.githubusercontent.com/Slyvok/Slyvok_PteroEggs/main/Paper%20Otimizado%201.0.1/.version"
API_VERSION_URL="http://200.9.155.163:25566/version"

echo -e "${bold}🌐 Verificando versão da API Minecraft...${normal}"
API_RESPONSE=$(curl -s --max-time 5 "$API_VERSION_URL")
if echo "$API_RESPONSE" | grep -q "version"; then
    API_VERSION=$(echo "$API_RESPONSE" | grep -oP '"name"\s*:\s*"\K[^"]+')
    printf "${green}✅ API detectada: ${bold}${API_VERSION}${normal}\n"
else
    printf "${red}❌ Não foi possível obter a versão da API.${normal}\n"
fi

echo -e "${bold}📦 Verificando versão do Egg...${normal}"
if [ -f "$LOCAL_VERSION_FILE" ]; then
    LOCAL_VERSION=$(cat "$LOCAL_VERSION_FILE")
    REMOTE_VERSION=$(curl -s --max-time 5 "$REMOTE_EGG_VERSION_URL")
    if [ -n "$REMOTE_VERSION" ]; then
        printf "${lightblue}🔸 Versão atual: ${bold}${LOCAL_VERSION}${normal}\n"
        printf "${lightblue}🔹 Última versão disponível: ${bold}${REMOTE_VERSION}${normal}\n"
        if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
            echo -e "${yellow}⚠️ ${bold}Atualização disponível!${normal}"
            echo -e "🛠️ Por favor, peça a um administrador do painel para atualizar o Egg para a versão mais recente!"
            echo -e "${red}⛔ A inicialização do servidor foi cancelada até que o Egg seja atualizado.${normal}"
            exit 1
        else
            echo -e "${green}✅ ${bold}Você está usando a versão mais recente do Egg.${normal}"
        fi
    else
        echo -e "${red}❌ Não foi possível verificar a versão mais recente do Egg.${normal}"
    fi
else
    echo -e "${red}⚠️ Arquivo de versão local (.version) não encontrado.${normal}"
fi

echo ""
printf "Executando otimização: ${bold}${lightblue}${OPTIMIZE} ${normal}\nCom os argumentos: ${bold}${lightblue}$START ${normal}\n"
$START
