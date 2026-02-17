# 🚤 FREE FiveM Boat Trailer Script | Realistic Towing System

A comprehensive and realistic boat trailer towing system for FiveM servers that supports both **ESX** and **QBCore** frameworks. This script allows players to attach/detach trailers to their vehicles and load/unload boats onto trailers using target systems.

## ✨ Features

- 🎣 **Realistic Trailer System**: Attach and detach trailers to compatible vehicles
- ⚓ **Boat Loading**: Load and unload boats onto trailers with realistic physics
- 🔧 **Multi-Framework Support**: Works with ESX, QBCore, or Standalone
- 🎯 **Target System Integration**: Compatible with ox_target and qb-target
- 🌊 **Multiple Boat Support**: Supports all GTA V boats and custom boats
- 📍 **Configurable Spawns**: Pre-configured spawn locations for trailers and boats
- 🔄 **Network Sync**: Server-side synchronization for multiplayer
- 📝 **Customizable**: Easy-to-configure settings and messages
- 🎨 **User-Friendly**: Intuitive interaction system with notifications

## 📋 Requirements

- **FiveM Server** (latest recommended)
- **OneSync Enabled** (required for network synchronization)
- **Framework** (choose one):
  - ESX Legacy (1.9.0+)
  - QBCore (latest)
  - Or run Standalone
- **Target System** (recommended):
  - ox_target (recommended)
  - qb-target
  - Or use fallback key controls

## 🔧 Installation

1. **Download the script** and extract it to your resources folder
2. **Rename** the folder to `boattrailer` (or your preferred name)
3. **Configure** the `config.lua` file:
   - Set your framework (`ESX`, `QBCore`, or `Standalone`)
   - Set your target system (`ox_target`, `qb-target`, or `custom`)
   - Adjust spawn locations, messages, and other settings
4. **Add to server.cfg**:
   ```
   ensure boattrailer
   ```
5. **Restart** your server

## ⚙️ Configuration

Open `config.lua` and customize the settings:

### Framework Selection
```lua
Config.Framework = 'ESX' -- Options: 'ESX', 'QBCore', 'Standalone'
Config.TargetSystem = 'ox_target' -- Options: 'ox_target', 'qb-target', 'custom'
```

### Trailer & Boat Settings
```lua
Config.TrailerModel = 'boattrailer' -- Trailer model name
Config.MaxTowingDistance = 10.0 -- Maximum interaction distance in meters
Config.BoatModels = { 'dinghy', 'jetmax', 'speeder', ... } -- Supported boats
```

### Spawn Locations
Configure spawn locations for trailers and boats in the `Config.TrailerSpawns` and `Config.BoatSpawns` tables.

### Key Bindings (Fallback)
```lua
Config.AttachKey = 38 -- E key
Config.DetachKey = 47 -- G key
```

## 🎮 Usage

### With Target System (Recommended)

1. **Attach Trailer**:
   - Get in a vehicle
   - Approach a trailer
   - Use your target system (default: look at trailer and press third eye)
   - Select "Attach Trailer"

2. **Detach Trailer**:
   - While towing a trailer
   - Use your target system on the trailer
   - Select "Detach Trailer"

3. **Load Boat**:
   - Approach a trailer with a boat nearby
   - Use your target system on the trailer
   - Select "Load Boat"

4. **Unload Boat**:
   - Approach a trailer with a loaded boat
   - Use your target system on the trailer
   - Select "Unload Boat"

### Without Target System

Use the configured keybinds (default: E to attach, G to detach)

### Commands

- `/spawntrailer` - Spawns a trailer near you
- `/spawnboat [model]` - Spawns a boat near you (optional model name)

## 🎯 Supported Vehicles

### Trailers
- Default GTA V boat trailer (`boattrailer`)
- Any vehicle with the utility class
- Custom trailers (configurable)

### Boats
The script supports all GTA V boats by default:
- Dinghy (all variants)
- Jetmax
- Marquis
- Seashark (all variants)
- Speeder
- Squalo
- Suntrap
- Toro
- Tropic
- And more...

You can add custom boats in the `Config.BoatModels` table.

## 🌍 Default Spawn Locations

### Trailer Spawns
1. Paleto Bay Marina
2. Del Perro Beach
3. Vespucci Beach
4. Sandy Shores Airfield

### Boat Spawns
1. Paleto Bay Marina (water)
2. Del Perro Beach (water)
3. Vespucci Beach (water)
4. Sandy Shores Airfield (water)

## 🔄 Network Synchronization

The script includes server-side synchronization to ensure:
- Boat loading/unloading is visible to all players
- Trailer attachments are properly synced
- Player disconnections are handled gracefully

## 🐛 Troubleshooting

### Trailers won't attach
- Ensure you're in a vehicle that can tow trailers
- Check that OneSync is enabled on your server
- Verify the trailer model exists in your game

### Target system not working
- Verify your target resource is started before this script
- Check that `Config.TargetSystem` matches your installed target resource
- Try using the fallback key controls

### Boats not loading
- Ensure the boat is close enough to the trailer (within `Config.MaxTowingDistance`)
- Verify the boat model is in `Config.BoatModels` or is a default GTA V boat
- Check server console for any errors

## 📝 License

This script is **FREE** and open source. Feel free to modify and use it on your server.

## 💡 Credits

Created by **KairoxDev**

## 🤝 Support

For issues, suggestions, or contributions, please open an issue on GitHub.

## 📜 Changelog

### Version 1.0.0
- Initial release
- ESX & QBCore framework support
- ox_target & qb-target integration
- Realistic trailer attachment system
- Boat loading/unloading system
- Network synchronization
- Configurable spawn locations
- Command system for spawning trailers and boats
