<div align="center">
  <img src="https://img.shields.io/badge/FiveM-Script-orange?style=for-the-badge&logo=fivem&logoColor=white" />
  <img src="https://img.shields.io/badge/Framework-ESX-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Author-BloodLeak-purple?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-All%20Rights%20Reserved-red?style=for-the-badge" />
  
  <h1>💈 BloodAppearance (bl_appearance)</h1>
  <p><i>Créateur d'apparence, morphologie et garde-robe ultra-détaillé pour votre serveur FiveM</i></p>
</div>

---

## 📖 À propos

**BloodAppearance** est un créateur d'apparence complet et moderne reprenant l'intégralité des fonctionnalités de personnalisation native de GTA V (Hérédité, Micro-morphs du visage, Maquillage, Cheveux, Vêtements et Accessoires). Conçu avec l'identité visuelle BloodLeak Red (`#E50914`) et une interface ergonomique sans flou sombre encombrant, il offre aux joueurs une personnalisation millimétrée avec contrôle dynamique des caméras et de la rotation.

---

## ✨ Fonctionnalités Clés

- 🧬 **Génétique & Hérédité :** Choix des visages des parents (Père & Mère), mélange des traits et de la couleur de peau en temps réel avec aperçu immédiat.
- 📐 **19 Micro-Morphs Faciaux :** Réglages précis de chaque élément du visage (Nez, Pommettes, Mâchoire, Menton, Lèvres, Yeux, Cou).
- 💄 **Cosmétiques & Détails de Peau :** Barbe, Sourcils, Maquillage, Rouge à lèvres, Blush, Taches de rousseur, Rides, Teint, Dommages solaires et Couleur des yeux.
- 👔 **Garde-Robe Complète :** Sélection par steppers et numéros de toutes les pièces vestimentaires (Hauts, T-shirts, Bras, Pantalons, Chaussures, Gilets, Sacs, Masques, Chapeaux, Lunettes, Montres).
- 👗 **Zéro Bug Féminin :** Tenue et morphologie de base optimisées pour le ped féminin (`mp_f_freemode_01`), supprimant tout membre invisible ou glitch de texture à la création.
- 🎥 **Caméras Dynamiques & Rotation :** Raccourcis de caméra par zones (Tête, Torse, Jambes, Corps entier) et boutons de rotation 360° fluide du ped.
- 🔌 **Compatibilité Universelle :** Émule et remplace nativement `esx_skin`, `skinchanger`, `fivem-appearance` et `illenium-appearance` via des callbacks rétrocompatibles.

---

## 📋 Prérequis

Pour fonctionner de manière optimale, le script nécessite :
- [**es_extended**](https://github.com/esx-framework/esx-legacy) (Legacy ou versions antérieures)
- [**oxmysql**](https://github.com/overextended/oxmysql) (ou mysql-async)

---

## 🚀 Installation & Utilisation

1. **Ressource :** Placez le dossier `bl_appearance` dans le répertoire `resources/` de votre serveur.
2. **Démarrage :** Ajoutez la ligne suivante dans votre fichier `server.cfg` (en remplacement de `skinchanger` / `esx_skin`) :
   ```cfg
   ensure bl_appearance
   ```

---

## 🎮 Commandes & Exports

- **`/skin` (Admin / Staff) :** Ouvre l'interface complète de personnalisation d'apparence pour le joueur.
- **Exports Client :**
  ```lua
  -- Ouvrir le menu d'apparence
  exports['bl_appearance']:OpenMenu(function()
      print('Skin sauvegardé !')
  end)
  ```
- **Événements ESX Rétrocompatibles :**
  - `TriggerEvent('esx_skin:openSaveableMenu')`
  - `TriggerEvent('skinchanger:loadSkin', skin)`

---

<div align="center">
  <p><i>Développé avec passion par <b>BloodLeak</b>. Des designs haut de gamme et des performances optimisées pour votre communauté FiveM.</i></p>
</div>
