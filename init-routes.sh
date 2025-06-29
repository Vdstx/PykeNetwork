#!/bin/sh

echo "===================="
echo "[PYKE +] Activation de l'IP forwarding"
echo "===================="

docker exec routeur-rc sysctl -w net.ipv4.ip_forward=1
docker exec routeur-rh sysctl -w net.ipv4.ip_forward=1
docker exec routeur-com sysctl -w net.ipv4.ip_forward=1
docker exec routeur-outils sysctl -w net.ipv4.ip_forward=1
docker exec routeur-ri sysctl -w net.ipv4.ip_forward=1

echo ""
echo "===================="
echo "[PYKE +] Configuration des routes par défaut sur les PCs"
echo "===================="

docker exec pc1 ip route replace default via 172.30.2.253   # routeur-rh
docker exec pc2 ip route replace default via 172.30.3.253   # routeur-com

echo ""
echo "===================="
echo "[PYKE +] Routes sur routeur-rh"
echo "===================="

docker exec routeur-rh ip route add 172.30.100.0/24 via 172.30.2.2   # vers réseau central
docker exec routeur-rh ip route add 172.30.4.0/24 via 172.30.2.2     # vers outils
docker exec routeur-rh ip route add 172.30.3.0/24 via 172.30.2.2     # vers COM

echo ""
echo "===================="
echo "[PYKE +] Routes sur routeur-com"
echo "===================="

docker exec routeur-com ip route add 172.30.100.0/24 via 172.30.3.2
docker exec routeur-com ip route add 172.30.4.0/24 via 172.30.3.2
docker exec routeur-com ip route add 172.30.2.0/24 via 172.30.3.2

echo ""
echo "===================="
echo "[PYKE +] Routes sur routeur-outils"
echo "===================="

docker exec routeur-outils ip route add 172.30.100.0/24 via 172.30.4.2
docker exec routeur-outils ip route add 172.30.2.0/24 via 172.30.4.2
docker exec routeur-outils ip route add 172.30.3.0/24 via 172.30.4.2

echo ""
echo "===================="
echo "[PYKE +] Routes sur routeur-rc (vers Internet via RI)"
echo "===================="

docker exec routeur-rc ip route add 172.31.0.0/24 via 172.30.100.254

echo ""
echo "===================="
echo "[PYKE +] Routes sur routeur-ri (routes de retour)"
echo "===================="

docker exec routeur-ri ip route add 172.30.4.0/24 via 172.30.100.2
docker exec routeur-ri ip route add 172.30.3.0/24 via 172.30.100.2
docker exec routeur-ri ip route add 172.30.2.0/24 via 172.30.100.2

echo ""
echo "[PYKE ✓] Routage complet effectué avec succès."
