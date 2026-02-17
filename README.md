# 🚤 Boat Trailer Script

## 🇬🇧 English

### Description
A FiveM script that allows players to attach/detach boat trailers to vehicles and load/unload boats onto trailers.

### Compatibility
- **Frameworks:** QBCore & ESX (auto-detected)
- **Target systems:** qb-target & ox_target (auto-detected)
- **Progressbar:** QBCore native or ox_lib (for ESX)

### Features
- Attach / detach a trailer to any vehicle via target interaction
- Load / unload a boat or jetski onto the trailer with [E]
- Progress bar with animation
- Full English & French locale support
- Auto-detection of framework and target — no config needed

### Installation
1. Drop the `bateauremorque` folder into your resources
2. Add `ensure bateauremorque` to your `server.cfg`
3. Restart the server

### Configuration
Edit `config.lua`:
- `Config.Locale` — `'fr'` or `'en'`
- `Config.Framework` — `'auto'`, `'qbcore'` or `'esx'`
- `Config.Target` — `'auto'`, `'qb-target'` or `'ox_target'`

All other settings (distances, offsets, animations) can be adjusted in the same file.

---

## 🇫🇷 Français

### Description
Un script FiveM permettant d'attacher/détacher une remorque à bateau sur un véhicule et de charger/décharger un bateau sur la remorque.

### Compatibilité
- **Frameworks :** QBCore & ESX (détection automatique)
- **Systèmes target :** qb-target & ox_target (détection automatique)
- **Barre de progression :** QBCore natif ou ox_lib (pour ESX)

### Fonctionnalités
- Attacher / détacher une remorque à un véhicule via le target
- Charger / décharger un bateau ou jetski sur la remorque avec [E]
- Barre de progression avec animation
- Locales complètes en anglais et français
- Détection automatique du framework et du target — aucune config nécessaire

### Installation
1. Placez le dossier `bateauremorque` dans vos resources
2. Ajoutez `ensure bateauremorque` dans votre `server.cfg`
3. Redémarrez le serveur

### Configuration
Modifiez `config.lua` :
- `Config.Locale` — `'fr'` ou `'en'`
- `Config.Framework` — `'auto'`, `'qbcore'` ou `'esx'`
- `Config.Target` — `'auto'`, `'qb-target'` ou `'ox_target'`

Tous les autres paramètres (distances, offsets, animations) sont modifiables dans le même fichier.
