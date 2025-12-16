#!/bin/bash

# Define the path to the google-services.json file
GOOGLE_SERVICES_JSON="android/app/src/play/google-services.json"

build_foss() {
    echo ">>> Building FOSS flavor..."
    if flutter build apk --flavor foss --dart-define=BUILD_TYPE=foss -t lib/main_foss.dart --no-pub $*; then
        echo ">>> FOSS build successful."
    else
        echo ">>> FOSS build failed."
        exit 1
    fi
}

build_play() {
    echo ">>> Building Play flavor..."
    if flutter build appbundle --flavor play --dart-define=BUILD_TYPE=play -t lib/main_play.dart --no-pub $*; then
        echo ">>> Play build successful."
    else
        echo ">>> Play build failed."
        exit 1
    fi
}

build_play_apk() {
    echo ">>> Building Play flavor..."
    if flutter build apk --flavor play --dart-define=BUILD_TYPE=play -t lib/main_play.dart --no-pub $*; then
        echo ">>> Play build successful."
    else
        echo ">>> Play build failed."
        exit 1
    fi
}

# Check if the google-services.json file exists
if [ -f "$GOOGLE_SERVICES_JSON" ]; then
    echo "Found '$GOOGLE_SERVICES_JSON'."
    echo "Which flavor would you like to build?"
    
    select choice in "play" "play (apk)" "foss" "both" "cancel"; do
        case $choice in
            play)
                build_play
                break
                ;;
            foss)
                build_foss
                break
                ;;
            both)
                echo ">>> Building both flavors sequentially..."
                build_play
                build_foss
                break
                ;;
            cancel)
                echo "Build canceled."
                break
                ;;
            play\ \(apk\))
                build_play_apk
                break
                ;;
            *)
                # Handle invalid input
                echo "Invalid option. Please choose a number from the list."
                ;;
        esac
    done
else
    echo "'$GOOGLE_SERVICES_JSON' not found."
    echo "Defaulting to FOSS build."
    build_foss
fi

echo ">>> Build process finished."

