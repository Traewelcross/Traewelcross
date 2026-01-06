.PHONY: all help foss play play-apk both

GOOGLE_SERVICES_JSON := android/app/src/play/google-services.json

FLUTTER := flutter

FOSS_ARGS := build apk --flavor foss --dart-define=BUILD_TYPE=foss -t lib/main_foss.dart --split-per-abi
PLAY_APK_ARGS := build apk --flavor play --dart-define=BUILD_TYPE=play -t lib/main_play.dart --split-per-abi
PLAY_BUNDLE_ARGS := build appbundle --flavor play --dart-define=BUILD_TYPE=play -t lib/main_play.dart

# Default target: Guide the user or build FOSS by default.
all:
	@if [ -f "$(GOOGLE_SERVICES_JSON)" ]; then \
		echo "Found '$(GOOGLE_SERVICES_JSON)'."; \
		$(MAKE) help; \
	else \
		@echo "'$(GOOGLE_SERVICES_JSON)' not found." ; \
		@echo "Defaulting to FOSS build." ; \
		$(MAKE) foss; \
	fi

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "	play		- Build the Play Store app bundle."
	@echo "	play-apk	- Build the Play Store APK for testing."
	@echo "	foss		- Build the FOSS APK."
	@echo "	both		- Build both 'play' and 'foss' flavors."
	@echo "	both-apk	- Build both 'play-apk' and 'foss' flavors."

foss:
	@echo ">>> Building FOSS flavor..."
	@$(FLUTTER) $(FOSS_ARGS)
	@echo ">>> FOSS build finished."
play:
	@echo ">>> Building Play flavor (appbundle)..."
	@$(FLUTTER) $(PLAY_BUNDLE_ARGS)
	@echo ">>> Play (appbundle) build finished."

play-apk:
	@echo ">>> Building Play flavor (apk)..."
	@$(FLUTTER) $(PLAY_APK_ARGS)
	@echo ">>> Play (apk) build finished."
both:
	@echo ">>> Building both flavors sequentially..."
	$(MAKE) play-apk
	$(MAKE) foss
	@echo ">>> All builds finished."
both-apk:
	@echo ">>> Building both flavors sequentially..."
	$(MAKE) play-apk
	$(MAKE) foss
	@echo ">>> All builds finished."