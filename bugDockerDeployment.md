# Réseau Pyke – README réseau Docker

##  Problème rencontré : "Cannot start service [...] Address already in use"

Lors du déploiement d’un réseau Docker avec des conteneurs utilisant des adresses IP fixes, certaines erreurs bloquantes peuvent apparaître :

Cannot start service routeurX: Address already in use

yaml
Copy
Edit

---

##  Pourquoi ce problème arrive ?

Docker utilise des **réseaux "bridge" internes** pour connecter les conteneurs. Lorsqu’on crée un réseau `subnet: 172.20.X.0/24`, **Docker assigne automatiquement l’IP `.1`** de ce sous-réseau à l’interface virtuelle du bridge (ex: `br-xxxxxx`).

Donc si tu veux utiliser **l’IP `.1` pour un de tes conteneurs**, il y a **conflit** :

- IP `.1` → déjà utilisée par le bridge Docker
- Ton conteneur ne peut pas démarrer → `Address already in use`

---

##  Solution simple : **ne pas utiliser `.1`**

Dans tous les réseaux Docker définis avec un `subnet`, évite d’utiliser :

- `xxx.xxx.xxx.1`
- ou `xxx.xxx.xxx.254` (parfois aussi réservée automatiquement, selon les versions)

### Recommandations :
| Ce qu’il faut faire          | Exemple d’IP sûre  |
|------------------------------|---------------------|
| Commencer à `.10`, `.100`    | `172.20.1.10`       |
| Pour les routeurs : `.254`   | `172.20.1.254`      |
| Éviter `.1`, `.0`, `.255`    | (réservés réseau/broadcast/Docker) |

---

##  Et si ça ne suffit pas ?

Docker peut conserver :
- des **conteneurs "fantômes"** à l’état `Created`
- des **interfaces bridge** même après `docker-compose down`

### Étapes de nettoyage radical :

```bash
docker-compose down
docker rm -f $(docker ps -aq)           # supprime tous les conteneurs
docker network prune -f                 # supprime tous les réseaux inutilisés
sudo ip link delete br-XXXXXXX          # (si nécessaire) supprime les interfaces fantômes
sudo systemctl restart docker           # redémarre Docker proprement
