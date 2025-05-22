#!/bin/ash
# shellcheck shell=dash
# Script de instalação do Paper
# feito por slyvok
# Arquivos do servidor: /mnt/server

if [ -f "${SERVER_JARFILE}" ]; then
    # Se o arquivo .jar já existir, executa o script de inicialização
    bash <(curl -s https://raw.githubusercontent.com/Slyvok/APISLY/main/Connect/paper-1.0.0/launch.sh)
else
    PROJECT=paper

    if [ -n "${DL_PATH}" ]; then
        echo "Usando a URL de download fornecida: ${DL_PATH}"
        DOWNLOAD_URL=$(eval echo $(echo ${DL_PATH} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
    else
        # Verifica se a versão do Minecraft informada é válida
        VER_EXISTS=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep -m1 true)
        LATEST_VERSION=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]')

        if [ "${VER_EXISTS}" = "true" ]; then
            echo "Versão válida. Usando a versão ${MINECRAFT_VERSION}"
        else
            echo "Versão especificada não encontrada. Usando a versão mais recente do ${PROJECT}"
            MINECRAFT_VERSION=${LATEST_VERSION}
        fi

        # Verifica se o número de build informado é válido
        BUILD_EXISTS=$(curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds[] | tostring | contains($BUILD)' | grep -m1 true)
        LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]')

        if [ "${BUILD_EXISTS}" = "true" ]; then
            echo "Build válida para a versão ${MINECRAFT_VERSION}. Usando o build ${BUILD_NUMBER}"
        else
            echo "Usando o build mais recente do ${PROJECT} para a versão ${MINECRAFT_VERSION}"
            BUILD_NUMBER=${LATEST_BUILD}
        fi

        JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar
        echo "Iniciando o download da versão:"
        echo "Versão do Minecraft: ${MINECRAFT_VERSION}"
        echo "Build: ${BUILD_NUMBER}"
        echo "Nome do arquivo JAR: ${JAR_NAME}"

        DOWNLOAD_URL=https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}
    fi

    cd /mnt/server || exit
    mkdir -p logs

    echo "Executando download com curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL}"

    if [ -f "${SERVER_JARFILE}" ]; then
        mv "${SERVER_JARFILE}" "${SERVER_JARFILE}.old"
    fi

    curl -o "${SERVER_JARFILE}" "${DOWNLOAD_URL}"

    # Baixa os arquivos de configuração se não existirem
    if [ ! -f server.properties ]; then
        echo "Baixando arquivo server.properties do Minecraft"
        curl -o server.properties https://raw.githubusercontent.com/Slyvok/APISLY/refs/heads/main/Connect/paper-1.0.0/config/server.properties
        curl -o spigot.yml https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Paper%20Optimized/config/spigot.yml
        curl -o bukkit.yml https://raw.githubusercontent.com/Slyvok/APISLY/refs/heads/main/Connect/paper-1.0.0/config/spigot.yml

        mkdir -p config
        (
            cd config || exit
            curl -o paper-world-defaults.yml https://raw.githubusercontent.com/Slyvok/APISLY/refs/heads/main/Connect/paper-1.0.0/config/paper-world-defaults.yml
        )
    fi
fi
