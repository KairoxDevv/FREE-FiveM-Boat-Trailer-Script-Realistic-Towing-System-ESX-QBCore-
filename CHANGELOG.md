# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-17

### Added
- Initial release of FREE FiveM Boat Trailer Script
- Realistic trailer attachment and detachment system
- Boat loading and unloading functionality
- Support for ESX Legacy framework
- Support for QBCore framework
- Standalone mode (no framework required)
- Integration with ox_target
- Integration with qb-target
- Fallback key controls for servers without target systems
- Network synchronization for multiplayer environments
- Configurable spawn locations for trailers and boats
- Commands for spawning trailers (`/spawntrailer`) and boats (`/spawnboat`)
- Support for all default GTA V boat models
- Customizable configuration options
- Comprehensive documentation (README, INSTALL, DEVELOPER guides)
- Example configurations for different setups
- MIT License

### Features
- Attach/detach trailers to compatible vehicles
- Load/unload boats onto trailers
- Realistic physics using native GTA V trailer system
- Multi-framework support
- Target system integration
- Configurable messages for localization
- Adjustable interaction distances
- Custom boat model support
- Custom trailer model support
- Server-side synchronization
- Automatic cleanup on player disconnect

### Performance
- Optimized key press handling (200ms interval)
- Efficient entity pooling
- Event-driven architecture
- Minimal network traffic
- Target system integration for better performance

### Documentation
- Comprehensive README with features and usage instructions
- Detailed INSTALL guide with troubleshooting
- DEVELOPER documentation for extending the script
- Configuration examples for common setups
- In-code comments for clarity

## [Unreleased]

### Planned Features
- Additional target system support
- More localization options
- Admin commands for server management
- Persistent trailer and boat spawns
- Garage integration
- Job-based restrictions
- Permission system integration
- Advanced physics options
- More boat and trailer models support
- UI improvements

---

## Version History

### Version Numbering
- **MAJOR** version: Incompatible API changes
- **MINOR** version: New features, backward-compatible
- **PATCH** version: Bug fixes, backward-compatible

### How to Update
1. Backup your current `config.lua` settings
2. Replace all files except `config.lua`
3. Compare your config with the new `config.lua` for new options
4. Restart the resource

### Reporting Issues
Please report bugs and request features on GitHub Issues.
