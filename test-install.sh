#!/bin/bash

# Quick Test Script for AzerothCore Installation
# This demonstrates how the installation script works with different options

echo "========================================"
echo "AzerothCore Installation Test Suite"
echo "========================================"
echo ""

# Test 1: Check script exists and is executable
echo "Test 1: Checking installation script..."
if [ -x "./install.sh" ]; then
    echo "✓ install.sh exists and is executable"
else
    echo "✗ install.sh not found or not executable"
    exit 1
fi

# Test 2: Check help output
echo ""
echo "Test 2: Testing help output..."
./install.sh --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Help command works"
else
    echo "✗ Help command failed"
fi

# Test 3: Check Docker files exist
echo ""
echo "Test 3: Checking Docker setup..."
if [ -f "./docker/Dockerfile" ] && [ -f "./docker/docker-compose.yml" ]; then
    echo "✓ Docker files present"
else
    echo "✗ Docker files missing"
fi

# Test 4: Check Docker entrypoint
echo ""
echo "Test 4: Checking Docker entrypoint..."
if [ -x "./docker/docker-entrypoint.sh" ]; then
    echo "✓ Docker entrypoint is executable"
else
    echo "✗ Docker entrypoint not executable"
fi

# Test 5: Syntax check
echo ""
echo "Test 5: Checking script syntax..."
bash -n ./install.sh
if [ $? -eq 0 ]; then
    echo "✓ Script syntax is valid"
else
    echo "✗ Script has syntax errors"
    exit 1
fi

# Display features
echo ""
echo "========================================"
echo "Installation Script Features"
echo "========================================"
echo ""
echo "Available Installation Modes:"
echo "  1. Native Linux Installation (Full)"
echo "  2. Docker Installation (Testing)"
echo "  3. Update Existing Installation"
echo "  4. Install/Update Modules Only"
echo "  5. Configure Server Settings"
echo "  6. Start/Stop Server"
echo ""
echo "Available Modules:"
echo "  • mod-no-hearthstone-cooldown"
echo "  • mod-account-mounts"
echo "  • mod-arac (All Races All Classes)"
echo "  • mod-ah-bot-plus"
echo "  • mod-transmog"
echo "  • mod-aoe-loot"
echo "  • mod-solo-lfg"
echo "  • mod-autobalance"
echo "  • mod-eluna"
echo "  • mod-cfbg"
echo "  • mod-playerbots (built-in)"
echo ""
echo "Build Configuration Options:"
echo "  • Server Type: PvE, PvP, RP, RP-PvP"
echo "  • Bot Count: Min/Max (default 400-500)"
echo "  • Cross-Faction: Group, Guild, Chat, AH"
echo "  • QoL Features: Instant logout, Quest tracker"
echo ""
echo "Management Aliases (created after install):"
echo "  • start   - Start auth and world servers"
echo "  • stop    - Stop all servers"
echo "  • wow     - Attach to world server"
echo "  • auth    - Attach to auth server"
echo "  • build   - Incremental build"
echo "  • compile - Full recompile"
echo "  • update  - Update core and playerbots"
echo "  • updatemods - Update all modules"
echo "  • pb      - Edit playerbots config"
echo "  • world   - Edit worldserver config"
echo "  • ah      - Edit AH bot config"
echo ""

# Docker test example
echo "========================================"
echo "Docker Testing Example"
echo "========================================"
echo ""
echo "To test the installation with Docker:"
echo ""
echo "1. Build the Docker image:"
echo "   cd docker && docker-compose build"
echo ""
echo "2. Start the container:"
echo "   docker-compose up -d"
echo ""
echo "3. Run installation inside container:"
echo "   docker-compose exec azerothcore /docker-entrypoint.sh install"
echo ""
echo "4. Or run interactive menu:"
echo "   docker-compose exec azerothcore install-azerothcore"
echo ""
echo "5. Start servers:"
echo "   docker-compose exec azerothcore /docker-entrypoint.sh start"
echo ""
echo "6. View logs:"
echo "   docker-compose logs -f"
echo ""

echo "========================================"
echo "All tests completed!"
echo "========================================"
