#!/bin/bash

# Flutter Project Template Setup Script
# Usage: ./setup_template.sh --name "MyApp" --bundle-id "com.mycompany.myapp" --org "MyCompany"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PROJECT_NAME=""
BUNDLE_ID=""
ORG_NAME=""
DESCRIPTION="A new Flutter project"
FLUTTER_VERSION="3.35.7"

# Function to display usage
usage() {
    echo -e "${BLUE}Flutter Project Template Setup${NC}"
    echo ""
    echo "Usage: ./setup_template.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --name             Project name (required, e.g., 'MyAwesomeApp')"
    echo "  --bundle-id        Bundle identifier (required, e.g., 'com.mycompany.myapp')"
    echo "  --org              Organization name (optional, e.g., 'MyCompany')"
    echo "  --description      Project description (optional)"
    echo "  --flutter-version  Flutter SDK version for FVM (optional, default: 3.35.7)"
    echo "  --help             Show this help message"
    echo ""
    echo "Example:"
    echo "  ./setup_template.sh --name \"MyApp\" --bundle-id \"com.mycompany.myapp\" --org \"MyCompany\" --flutter-version \"3.35.7\""
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --flutter-version)
            FLUTTER_VERSION="$2"
            shift 2
            ;;
        --bundle-id)
            BUNDLE_ID="$2"
            shift 2
            ;;
        --org)
            ORG_NAME="$2"
            shift 2
            ;;
        --description)
            DESCRIPTION="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            usage
            ;;
    esac
done

# Validate required parameters
if [ -z "$PROJECT_NAME" ] || [ -z "$BUNDLE_ID" ]; then
    echo -e "${RED}Error: --name and --bundle-id are required${NC}"
    usage
fi

# Convert project name to snake_case for package name (lowercase only)
# Remove spaces and convert to lowercase
PACKAGE_NAME=$(echo "$PROJECT_NAME" | sed -e 's/ /_/g' | tr '[:upper:]' '[:lower:]')

# Extract organization from bundle ID if not provided
if [ -z "$ORG_NAME" ]; then
    ORG_NAME=$(echo "$BUNDLE_ID" | cut -d'.' -f2)
fi

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}Flutter Template Setup${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo -e "${GREEN}Project Name:${NC} $PROJECT_NAME"
echo -e "${GREEN}Package Name:${NC} $PACKAGE_NAME"
echo -e "${GREEN}Bundle ID:${NC} $BUNDLE_ID"
echo -e "${GREEN}Organization:${NC} $ORG_NAME"
echo -e "${GREEN}Description:${NC} $DESCRIPTION"
echo ""
read -p "Continue with this configuration? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Setup cancelled${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Starting setup...${NC}"

# 0. Get current package name BEFORE changing pubspec.yaml
CURRENT_PACKAGE=$(grep "^name:" pubspec.yaml | sed 's/name: *//' | tr -d '\r' | xargs)
echo -e "${BLUE}Current package name: $CURRENT_PACKAGE${NC}"

# 1. Update pubspec.yaml
echo -e "${YELLOW}[1/8] Updating pubspec.yaml...${NC}"
sed -i.bak "s/^name: .*/name: $PACKAGE_NAME/" pubspec.yaml
sed -i.bak "s/^description: .*/description: \"$DESCRIPTION\"/" pubspec.yaml
rm pubspec.yaml.bak

# 2. Update Android package and applicationId
echo -e "${YELLOW}[2/8] Updating Android configuration...${NC}"

# Update build.gradle
if [ -f "android/app/build.gradle.kts" ]; then
    sed -i.bak "s/applicationId = \".*\"/applicationId = \"$BUNDLE_ID\"/" android/app/build.gradle.kts
    sed -i.bak "s/namespace = \".*\"/namespace = \"$BUNDLE_ID\"/" android/app/build.gradle.kts
    rm android/app/build.gradle.kts.bak
elif [ -f "android/app/build.gradle" ]; then
    sed -i.bak "s/applicationId \".*\"/applicationId \"$BUNDLE_ID\"/" android/app/build.gradle
    sed -i.bak "s/namespace \".*\"/namespace \"$BUNDLE_ID\"/" android/app/build.gradle
    rm android/app/build.gradle.bak
fi

# Update AndroidManifest.xml files
find android/app/src -name "AndroidManifest.xml" -type f | while read file; do
    sed -i.bak "s/package=\".*\"/package=\"$BUNDLE_ID\"/" "$file"
    rm "${file}.bak"
done

# Rename package directories and MainActivity.kt
# Find the current MainActivity.kt location
CURRENT_MAIN_ACTIVITY=$(find android/app/src/main/kotlin -name "MainActivity.kt" 2>/dev/null | head -n 1)

if [ ! -z "$CURRENT_MAIN_ACTIVITY" ]; then
    # Get the current package name from MainActivity.kt
    CURRENT_PACKAGE_KOTLIN=$(grep "^package" "$CURRENT_MAIN_ACTIVITY" | sed 's/package *//' | tr -d '\r\n' | xargs)
    echo -e "${BLUE}  Current Android package: $CURRENT_PACKAGE_KOTLIN${NC}"
    
    # Build new package path
    IFS='.' read -ra ADDR <<< "$BUNDLE_ID"
    NEW_PACKAGE_PATH="android/app/src/main/kotlin"
    for i in "${ADDR[@]}"; do
        NEW_PACKAGE_PATH="$NEW_PACKAGE_PATH/$i"
    done
    
    # Only proceed if the package is actually changing
    if [ "$CURRENT_PACKAGE_KOTLIN" != "$BUNDLE_ID" ]; then
        # Create new directory structure
        mkdir -p "$NEW_PACKAGE_PATH"
        
        # Copy MainActivity.kt with updated package name
        sed "s/package $CURRENT_PACKAGE_KOTLIN/package $BUNDLE_ID/" "$CURRENT_MAIN_ACTIVITY" > "$NEW_PACKAGE_PATH/MainActivity.kt"
        
        # Verify the new file was created successfully
        if [ -f "$NEW_PACKAGE_PATH/MainActivity.kt" ]; then
            echo -e "${GREEN}  ✓ MainActivity.kt created at: $NEW_PACKAGE_PATH/${NC}"
            
            # Get the old package directory to remove (e.g., android/app/src/main/kotlin/com/example/gist)
            OLD_PACKAGE_DIR=$(dirname "$CURRENT_MAIN_ACTIVITY")
            
            # Remove old MainActivity.kt
            rm -f "$CURRENT_MAIN_ACTIVITY"
            
            # Clean up empty parent directories
            while [ "$OLD_PACKAGE_DIR" != "android/app/src/main/kotlin" ] && [ -d "$OLD_PACKAGE_DIR" ]; do
                # Only remove if directory is empty
                if [ -z "$(ls -A "$OLD_PACKAGE_DIR")" ]; then
                    rmdir "$OLD_PACKAGE_DIR"
                    OLD_PACKAGE_DIR=$(dirname "$OLD_PACKAGE_DIR")
                else
                    break
                fi
            done
            
            echo -e "${GREEN}  ✓ Old package structure cleaned up${NC}"
        else
            echo -e "${RED}  ✗ Error: Failed to create MainActivity.kt at new location${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}  Package name unchanged, skipping MainActivity.kt relocation${NC}"
    fi
else
    # MainActivity.kt doesn't exist, create it
    echo -e "${YELLOW}  ! MainActivity.kt not found, creating new one...${NC}"
    
    IFS='.' read -ra ADDR <<< "$BUNDLE_ID"
    NEW_PACKAGE_PATH="android/app/src/main/kotlin"
    for i in "${ADDR[@]}"; do
        NEW_PACKAGE_PATH="$NEW_PACKAGE_PATH/$i"
    done
    
    mkdir -p "$NEW_PACKAGE_PATH"
    
    cat > "$NEW_PACKAGE_PATH/MainActivity.kt" << EOF
package $BUNDLE_ID

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
EOF
    
    if [ -f "$NEW_PACKAGE_PATH/MainActivity.kt" ]; then
        echo -e "${GREEN}  ✓ MainActivity.kt created successfully${NC}"
    else
        echo -e "${RED}  ✗ Error: Failed to create MainActivity.kt${NC}"
        exit 1
    fi
fi

# 3. Update iOS Bundle Identifier
echo -e "${YELLOW}[3/8] Updating iOS configuration...${NC}"

# Update Info.plist
if [ -f "ios/Runner/Info.plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID" ios/Runner/Info.plist 2>/dev/null || true
fi

# Update project.pbxproj
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i.bak "s/PRODUCT_BUNDLE_IDENTIFIER = .*;/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID;/" ios/Runner.xcodeproj/project.pbxproj
    rm ios/Runner.xcodeproj/project.pbxproj.bak
fi

# 4. Update app name in Android strings.xml
echo -e "${YELLOW}[4/8] Updating app name...${NC}"
if [ -f "android/app/src/main/res/values/strings.xml" ]; then
    sed -i.bak "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$PROJECT_NAME<\/string>/" android/app/src/main/res/values/strings.xml
    rm android/app/src/main/res/values/strings.xml.bak
fi

# 5. Update iOS app name
if [ -f "ios/Runner/Info.plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleName $PROJECT_NAME" ios/Runner/Info.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $PROJECT_NAME" ios/Runner/Info.plist 2>/dev/null || true
fi

# 6. Update import statements in Dart files
echo -e "${YELLOW}[5/8] Updating Dart imports (from $CURRENT_PACKAGE to $PACKAGE_NAME)...${NC}"
if [ ! -z "$CURRENT_PACKAGE" ] && [ "$CURRENT_PACKAGE" != "$PACKAGE_NAME" ]; then
    # Update all dart files in lib, test, and integration_test
    find lib test integration_test -type f -name "*.dart" 2>/dev/null | while read file; do
        if [ -f "$file" ]; then
            echo "  Updating imports in: $file"
            sed -i.bak "s/package:$CURRENT_PACKAGE\//package:$PACKAGE_NAME\//g" "$file"
            rm "${file}.bak" 2>/dev/null || true
        fi
    done
    echo -e "${GREEN}  ✓ Updated imports from 'package:$CURRENT_PACKAGE/' to 'package:$PACKAGE_NAME/'${NC}"
else
    echo -e "${YELLOW}  Skipping import updates (package name unchanged)${NC}"
fi

# 6. Setup FVM and install Flutter version
echo -e "${YELLOW}[6/9] Setting up FVM and Flutter SDK version...${NC}"
FLUTTER_CMD="flutter"

if command -v fvm &> /dev/null; then
    if [ ! -z "$FLUTTER_VERSION" ]; then
        echo -e "${BLUE}  Installing Flutter $FLUTTER_VERSION with FVM...${NC}"
        fvm install "$FLUTTER_VERSION" || true
        fvm use "$FLUTTER_VERSION" --force || true
        
        # Create .fvm directory if it doesn't exist
        mkdir -p .fvm
        
        # Create fvm_config.json (FVM's config file format)
        cat > .fvm/fvm_config.json << EOF
{
  "flutterSdkVersion": "$FLUTTER_VERSION"
}
EOF
        
        echo -e "${GREEN}  ✓ FVM configured with Flutter $FLUTTER_VERSION${NC}"
        
        # Use fvm flutter for all subsequent commands
        FLUTTER_CMD="fvm flutter"
        echo -e "${BLUE}  All Flutter commands will use FVM (fvm flutter)${NC}"
    else
        echo -e "${YELLOW}  ! No flutter version provided; using system Flutter${NC}"
    fi
else
    echo -e "${YELLOW}  ! FVM not found. Install FVM for version pinning: https://fvm.app/docs/getting_started${NC}"
    if [ ! -z "$FLUTTER_VERSION" ]; then
        # Create .fvm directory and config for when user installs FVM later
        mkdir -p .fvm
        cat > .fvm/fvm_config.json << EOF
{
  "flutterSdkVersion": "$FLUTTER_VERSION"
}
EOF
        echo -e "${YELLOW}  ! Created .fvm/fvm_config.json with version $FLUTTER_VERSION${NC}"
        echo -e "${YELLOW}  ! Using system Flutter for now - install FVM and run 'fvm install && fvm use' to switch${NC}"
    fi
fi

# 7. Clean Flutter
echo -e "${YELLOW}[7/9] Cleaning Flutter project...${NC}"
$FLUTTER_CMD clean

# 8. Get dependencies
echo -e "${YELLOW}[8/9] Getting Flutter dependencies...${NC}"
$FLUTTER_CMD pub get

# 9. Install iOS Pods (Mac only)
echo -e "${YELLOW}[9/9] Setting up iOS dependencies...${NC}"
# Detect operating system
OS_TYPE=$(uname -s)
if [ "$OS_TYPE" = "Darwin" ]; then
    # macOS detected
    echo -e "${BLUE}  macOS detected - Setting up iOS dependencies...${NC}"
    
    # Clean iOS build artifacts
    echo -e "${BLUE}  Cleaning iOS build artifacts...${NC}"
    rm -rf ios/Pods
    rm -rf ios/Podfile.lock
    rm -rf ios/.symlinks
    rm -rf ios/Flutter/Flutter.framework
    rm -rf ios/Flutter/Flutter.podspec
    
    # Precache Flutter iOS artifacts
    echo -e "${BLUE}  Pre-caching Flutter iOS artifacts...${NC}"
    $FLUTTER_CMD precache --ios
    
    if command -v pod &> /dev/null; then
        echo -e "${BLUE}  Installing CocoaPods dependencies...${NC}"
        cd ios
        pod install --repo-update
        cd ..
        echo -e "${GREEN}  ✓ CocoaPods dependencies installed${NC}"
    else
        echo -e "${YELLOW}  ! CocoaPods not found. Install it with: sudo gem install cocoapods${NC}"
        echo -e "${YELLOW}  ! Then run: cd ios && pod install${NC}"
    fi
elif [ "$OS_TYPE" = "Linux" ]; then
    # Linux detected
    echo -e "${BLUE}  Linux detected - Skipping CocoaPods (iOS only)${NC}"
else
    # Windows or other
    echo -e "${BLUE}  Skipping CocoaPods installation (macOS only)${NC}"
fi

# 10. Generate code
echo -e "${YELLOW}Running code generation...${NC}"
$FLUTTER_CMD pub run build_runner build --delete-conflicting-outputs

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Update assets/env/.env.* files with your API keys"
echo "2. Replace app icons in android/app/src/main/res/mipmap-* folders"
echo "3. Replace app icons in ios/Runner/Assets.xcassets/AppIcon.appiconset/"
if [ "$FLUTTER_CMD" = "fvm flutter" ]; then
    echo "4. Run: fvm flutter run"
else
    echo "4. Run: flutter run"
fi
echo ""
echo -e "${GREEN}Project Details:${NC}"
echo "  Package: $PACKAGE_NAME"
echo "  Bundle ID: $BUNDLE_ID"
echo "  Name: $PROJECT_NAME"
if [ "$FLUTTER_CMD" = "fvm flutter" ]; then
    echo "  Flutter Version (FVM): $FLUTTER_VERSION"
fi
echo ""
