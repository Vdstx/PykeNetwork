## Topologie réseau (LAN simulés)

Le réseau se compose de **3 sous-réseaux**, reliés par **3 routeurs**, et **2 clients** pour les tests :

### Réseaux Docker créés

| Nom réseau           | CIDR            | Description                    |
|----------------------|-----------------|--------------------------------|
| `entreprise-a`       | `172.20.1.0/24` | Réseau client A                |
| `entreprise-b`       | `172.20.2.0/24` | Réseau client B                |
| `infra-secu`         | `172.20.3.0/24` | Réseau des outils de sécurité |
| `routeur-a-b`        | `172.21.0.0/29` | Lien point-à-point A ↔ B       |
| `routeur-b-c`        | `172.21.1.0/29` | Lien point-à-point B ↔ C       |

---

### Conteneurs définis

| Nom          | Type         | IP(s) attribuées                          | Réseaux connectés                  |
|--------------|--------------|-------------------------------------------|------------------------------------|
| `clientA1`   | Client A      | `172.20.1.10`                             | `entreprise-a`                     |
| `clientB1`   | Client B      | `172.20.2.10`                             | `entreprise-b`                     |
| `routeurA`   | Routeur A     | `172.20.1.254`, `172.21.0.2`              | `entreprise-a`, `routeur-a-b`      |
| `routeurB`   | Routeur central | `172.20.2.254`, `172.21.0.3`, `172.21.1.2`| `entreprise-b`, `routeur-a-b`, `routeur-b-c` |
| `routeurC`   | Routeur C     | `172.20.3.254`, `172.21.1.3`              | `infra-secu`, `routeur-b-c`        |

---

##  Lancer le projet

###  1. Se placer dans le dossier

```bash
cd ~/Bureau/pyke-network
```

### 2. Lancer le réseau

```
docker-compose up -d
```

### Tester la connectivité

```
docker exec -it clientA1 sh
ping 172.20.1.254  # Routeur A


docker exec -it clientB1 sh
ping 172.20.2.254  # Routeur B
```

### Arrêter le réseau

```
docker-compose down
```
