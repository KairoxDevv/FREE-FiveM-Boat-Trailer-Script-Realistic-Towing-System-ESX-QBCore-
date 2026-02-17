# FiveM Boat Trailer Script - Installation Guide

## Quick Start

1. **Extract the resource** to your server's `resources` folder
2. **Rename the folder** to `boattrailer` (optional, but recommended)
3. **Configure the script** by editing `config.lua`
4. **Add to server.cfg**: `ensure boattrailer`
5. **Restart your server**

## Configuration Examples

### For ESX Servers with ox_target
```lua
Config.Framework = 'ESX'
Config.TargetSystem = 'ox_target'
Config.UseOxLib = false
```

### For QBCore Servers with qb-target
```lua
Config.Framework = 'QBCore'
Config.TargetSystem = 'qb-target'
Config.UseOxLib = false
```

### For Standalone Servers (no framework)
```lua
Config.Framework = 'Standalone'
Config.TargetSystem = 'ox_target'
Config.UseOxLib = true
```

### Custom Key Bindings
If you want to change the default keys for attaching/detaching trailers:
```lua
Config.AttachKey = 38  -- Default: E key
Config.DetachKey = 47  -- Default: G key
```

Common key codes:
- E = 38
- G = 47
- H = 74
- X = 73

## Adding Custom Boats

To add support for custom boat models:

```lua
Config.BoatModels = {
    -- Default boats
    'dinghy',
    'jetmax',
    'speeder',
    
    -- Add your custom boats here
    'myCustomBoat',
    'anotherCustomBoat',
}
```

## Adding Custom Spawn Locations

### Trailer Spawns
```lua
Config.TrailerSpawns = {
    {coords = vector4(x, y, z, heading), label = 'Location Name'},
    -- Add more locations...
}
```

### Boat Spawns (on water)
```lua
Config.BoatSpawns = {
    {coords = vector4(x, y, z, heading), label = 'Location Name'},
    -- Add more locations...
}
```

## Troubleshooting

### Script not loading
- Check that OneSync is enabled in your server.cfg: `set onesync on`
- Verify the resource is properly named and in the resources folder
- Check server console for error messages

### Trailer won't attach
- Make sure you're in a vehicle that can tow trailers (trucks, SUVs)
- Ensure the trailer is within the configured distance (default: 10 meters)
- Try using the fallback key controls (E key by default)

### Target system not working
- Verify your target resource (ox_target or qb-target) is started before this script
- Check that the Config.TargetSystem value matches your installed target resource
- Restart both the target resource and this script

### Boats won't load
- Ensure the boat is close to the trailer
- Check that the boat model is listed in Config.BoatModels
- Verify the boat is not being used by another player

## Commands

### Spawn Trailer
```
/spawntrailer
```
Spawns a boat trailer in front of you.

### Spawn Boat
```
/spawnboat [model]
```
Spawns a boat in front of you. Optional model parameter (e.g., `/spawnboat dinghy`).

## Performance Tips

- The script is optimized for minimal performance impact
- Uses native GTA V trailer attachment system
- Network sync is handled efficiently on the server side
- No continuous loops checking for trailers (uses target system or key press events)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the configuration options
3. Check server console for error messages
4. Open an issue on GitHub with details about your setup

## Credits

Script created by KairoxDev
Free and open source - feel free to modify for your server!
