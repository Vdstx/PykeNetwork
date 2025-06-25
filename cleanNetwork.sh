#!/bin/bash

echo "Nettoyage du réseau Docker Pyke..."

# Arrêt propre des conteneurs définis dans docker-compose
docker-compose -f docker-compose.yml -f override-pki.yml down

# Suppression des conteneurs stoppés
docker container prune -f

# Suppression des réseaux inutilisés
docker network prune -f

export COMPOSE_HTTP_TIMEOUT=300


echo "Réseau propre. Redémarrable avec :"
echo "   docker-compose -f docker-compose.yml -f override-OUTIL1.yml override-OUTIL2.yml etc up -d"
