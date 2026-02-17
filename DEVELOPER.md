# Developer Documentation

## Script Architecture

This boat trailer script is designed with modularity and extensibility in mind. Here's how it's structured:

### File Structure
```
boattrailer/
├── fxmanifest.lua          # Resource manifest
├── config.lua              # Main configuration file
├── config_examples.lua     # Configuration examples
├── client/
│   └── main.lua           # Client-side logic
├── server/
│   └── main.lua           # Server-side synchronization
├── README.md              # User documentation
├── INSTALL.md             # Installation guide
└── LICENSE                # MIT License
```

## Client-Side (client/main.lua)

### Key Functions

#### `GetClosestVehicle(coords)`
Returns the closest vehicle to the given coordinates (or player position if not provided).

**Returns:**
- `vehicle` (entity): The closest vehicle entity
- `distance` (float): Distance to the vehicle

#### `IsBoat(vehicle)`
Checks if a vehicle is a boat by comparing its model against the configured boat models list and checking its vehicle class.

**Parameters:**
- `vehicle` (entity): The vehicle entity to check

**Returns:**
- `boolean`: True if the vehicle is a boat

#### `IsTrailer(vehicle)`
Checks if a vehicle is a trailer by comparing its model name and vehicle class.

**Parameters:**
- `vehicle` (entity): The vehicle entity to check

**Returns:**
- `boolean`: True if the vehicle is a trailer

#### `AttachTrailer()`
Handles the attachment of a trailer to the player's current vehicle.

**Requirements:**
- Player must be in a vehicle
- Trailer must be within `Config.MaxTowingDistance`
- Vehicle must not already be towing

#### `DetachTrailer()`
Handles the detachment of a trailer from the player's current vehicle.

**Requirements:**
- Player must be in a vehicle
- Vehicle must be towing a trailer

#### `LoadBoat()`
Loads a nearby boat onto a trailer. The boat is positioned on the trailer using configured offsets and frozen in place.

**Requirements:**
- Trailer must be within range
- Boat must be within range
- No boat is currently loaded

#### `UnloadBoat()`
Unloads the currently loaded boat from the trailer.

**Requirements:**
- A boat must be loaded on the trailer

#### `SetupTargetSystem()`
Initializes integration with ox_target or qb-target. Creates interaction zones for trailers with options to attach, detach, load, and unload.

### Network Events

#### `boattrailer:syncBoatLoadClient`
Synchronizes boat loading across all clients.

**Parameters:**
- `trailerNetId` (int): Network ID of the trailer
- `boatNetId` (int): Network ID of the boat

#### `boattrailer:syncBoatUnloadClient`
Synchronizes boat unloading across all clients.

**Parameters:**
- `boatNetId` (int): Network ID of the boat

### Commands

#### `/spawntrailer`
Spawns a trailer in front of the player.

#### `/spawnboat [model]`
Spawns a boat in front of the player. Optional model parameter.

## Server-Side (server/main.lua)

### Global Variables

#### `loadedBoats`
Table tracking which boats are loaded on trailers by player ID.

Structure:
```lua
loadedBoats[playerId] = {
    trailer = trailerNetId,
    boat = boatNetId
}
```

### Network Events

#### `boattrailer:syncBoatLoad`
Server-side handler for boat loading. Broadcasts the event to all clients.

**Parameters:**
- `trailerNetId` (int): Network ID of the trailer
- `boatNetId` (int): Network ID of the boat

#### `boattrailer:syncBoatUnload`
Server-side handler for boat unloading. Broadcasts the event to all clients.

**Parameters:**
- `boatNetId` (int): Network ID of the boat

### Event Handlers

#### `playerDropped`
Cleans up loaded boat data when a player disconnects.

## Configuration (config.lua)

### Framework Options
- `ESX`: For ESX Legacy servers
- `QBCore`: For QBCore servers
- `Standalone`: For servers without a framework

### Target System Options
- `ox_target`: Uses ox_target for interactions
- `qb-target`: Uses qb-target for interactions
- `custom`: Uses fallback key controls

### Key Configuration Options

#### `Config.MaxTowingDistance`
Maximum distance (in meters) for trailer/boat interactions.

**Default:** 10.0

#### `Config.TowingOffset`
Vector3 offset for trailer attachment point.

**Default:** vector3(0.0, -2.5, 0.0)

#### `Config.BoatLoadOffset`
Vector3 offset for boat position on trailer.

**Default:** vector3(0.0, 0.5, 1.0)

## Extending the Script

### Adding Custom Boats

1. Add the boat model to `Config.BoatModels`:
```lua
Config.BoatModels = {
    'dinghy',
    'your_custom_boat',
}
```

2. Ensure the boat model is properly loaded in your server.

### Adding Custom Trailers

1. Change `Config.TrailerModel` to your custom trailer:
```lua
Config.TrailerModel = 'your_custom_trailer'
```

2. Adjust `Config.BoatLoadOffset` if needed for proper boat positioning.

### Adding New Spawn Locations

1. Use `/getcoords` in-game to get coordinates
2. Add to `Config.TrailerSpawns` or `Config.BoatSpawns`:
```lua
{coords = vector4(x, y, z, heading), label = 'Location Name'}
```

### Localization

Modify `Config.Messages` to change notification messages:
```lua
Config.Messages = {
    attach_success = 'Your translated message',
    -- ... more messages
}
```

### Adding New Target System Support

To add support for a new target system:

1. Add a new condition in `SetupTargetSystem()`:
```lua
elseif Config.TargetSystem == 'your_target' then
    -- Your target system integration code
```

2. Follow the pattern used for ox_target or qb-target.

## Performance Considerations

### Optimizations Implemented

1. **Target System**: Uses efficient target systems instead of continuous distance checks
2. **Key Press Handler**: Waits 200ms between checks (reduced from 0ms)
3. **Network Sync**: Only syncs when state changes, not continuously
4. **Entity Pooling**: Uses `GetGamePool()` for efficient vehicle queries

### Best Practices

- Avoid adding continuous threads (while true loops with Wait(0))
- Use target systems when available
- Minimize network events
- Use entity natives efficiently

## Testing

### Test Scenarios

1. **Trailer Attachment**
   - Attach trailer to compatible vehicle
   - Attempt to attach to incompatible vehicle
   - Attach when already towing

2. **Boat Loading**
   - Load boat on trailer
   - Load boat when one is already loaded
   - Load boat when no trailer nearby

3. **Network Sync**
   - Load boat and verify other players see it
   - Detach trailer and verify sync
   - Disconnect while towing

4. **Framework Integration**
   - Test with ESX framework
   - Test with QBCore framework
   - Test standalone mode

## Common Issues and Solutions

### Issue: Trailer won't attach
**Solution:** Check that the vehicle class supports towing. Most trucks and SUVs support it.

### Issue: Boat loads incorrectly
**Solution:** Adjust `Config.BoatLoadOffset` for your specific trailer model.

### Issue: Target system not working
**Solution:** Ensure target resource is started before this script in server.cfg.

### Issue: Performance problems
**Solution:** Verify no continuous loops with Wait(0), check target system is properly configured.

## Contributing

When contributing to this script:

1. Follow the existing code style
2. Add comments for complex logic
3. Test with multiple frameworks
4. Update documentation
5. Ensure backward compatibility

## Support

For bugs or feature requests, please open an issue on GitHub with:
- FiveM server version
- Framework and version
- Target system and version
- Steps to reproduce the issue
- Any error messages from F8 console

## License

This script is released under the MIT License. See LICENSE file for details.
