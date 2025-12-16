const buildType = String.fromEnvironment("BUILD_TYPE", defaultValue: "foss");

bool get isPlay => buildType == "play";
bool get isFoss => buildType == "foss";
