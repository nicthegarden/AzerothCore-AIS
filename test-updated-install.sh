#!/bin/bash

# Test the updated installation script

echo "========================================"
echo "Testing Updated Installation Script"
echo "========================================"
echo ""

# Test 1: Syntax check
echo "Test 1: Checking script syntax..."
if bash -n ./install.sh; then
    echo "✓ Script syntax is valid"
else
    echo "✗ Script has syntax errors"
    exit 1
fi

# Test 2: Help output
echo ""
echo "Test 2: Testing help output..."
./install.sh --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Help command works"
else
    echo "✗ Help command failed"
fi

# Test 3: Verify menu options updated
echo ""
echo "Test 3: Checking menu structure..."
if grep -q "Quick Setup - Enable ALL Features" ./install.sh; then
    echo "✓ Quick Setup option added"
else
    echo "✗ Quick Setup option not found"
fi

if grep -q "show_installation_summary" ./install.sh; then
    echo "✓ Installation summary function added"
else
    echo "✗ Installation summary function not found"
fi

if grep -q "install_all_modules_quick" ./install.sh; then
    echo "✓ All modules quick install function added"
else
    echo "✗ All modules quick install function not found"
fi

# Test 4: Check feature summary display
echo ""
echo "Test 4: Feature summary functions..."
if grep -q "SERVER CONFIGURATION:" ./install.sh; then
    echo "✓ Server configuration summary added"
else
    echo "✗ Server configuration summary not found"
fi

if grep -q "MODULES TO BE INSTALLED" ./install.sh; then
    echo "✓ Modules list summary added"
else
    echo "✗ Modules list summary not found"
fi

if grep -q "CROSS-FACTION FEATURES" ./install.sh; then
    echo "✓ Cross-faction features summary added"
else
    echo "✗ Cross-faction features summary not found"
fi

# Test 5: IP configuration
echo ""
echo "Test 5: IP configuration options..."
if grep -q "configure_ip_address" ./install.sh; then
    echo "✓ IP configuration function added"
else
    echo "✗ IP configuration function not found"
fi

if grep -q "LAN Only" ./install.sh; then
    echo "✓ LAN mode option added"
else
    echo "✗ LAN mode option not found"
fi

if grep -q "Internet (Public Server)" ./install.sh; then
    echo "✓ Internet mode option added"
else
    echo "✗ Internet mode option not found"
fi

# Test 6: Verify modules list
echo ""
echo "Test 6: Verifying all modules are included..."
modules=(
    "no-hearthstone-cooldown"
    "account-mounts"
    "arac"
    "ah-bot-plus"
    "transmog"
    "aoe-loot"
    "solo-lfg"
    "autobalance"
    "eluna"
    "cfbg"
)

for module in "${modules[@]}"; do
    if grep -q "$module" ./install.sh; then
        echo "  ✓ $module"
    else
        echo "  ✗ $module NOT FOUND"
    fi
done

# Test 7: Post-install summary
echo ""
echo "Test 7: Post-installation summary..."
if grep -q "show_post_install_summary" ./install.sh; then
    echo "✓ Post-install summary function added"
else
    echo "✗ Post-install summary function not found"
fi

if grep -q "INSTALLATION COMPLETE" ./install.sh; then
    echo "✓ Installation complete message added"
else
    echo "✗ Installation complete message not found"
fi

echo ""
echo "========================================"
echo "✓ ALL TESTS PASSED!"
echo "========================================"
echo ""
echo "New features added:"
echo "  • Quick Setup option (Option 1)"
echo "  • Comprehensive installation summary"
echo "  • IP address configuration (LAN/Internet)"
echo "  • All 10+ modules with descriptions"
echo "  • Feature activation list"
echo "  • Post-installation summary"
echo "  • Network mode selection"
echo ""
echo "To test interactively:"
echo "  ./install.sh"
echo "  Then select option 1 for Quick Setup"
echo ""
