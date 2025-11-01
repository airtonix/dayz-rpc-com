#!/usr/bin/env bats

setup() {
    TEST_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
    PROJECT_DIR="$(dirname "$TEST_DIR")"
    CMD_DIR="$PROJECT_DIR/cmd"
    
    source "$CMD_DIR/_lib"
    
    TEST_TMP_DIR="${BATS_TEST_TMPDIR:-/tmp}/cmd-mods-test-$$-$$RANDOM"
    mkdir -p "$TEST_TMP_DIR"
}

teardown() {
    if [ -n "$TEST_TMP_DIR" ] && [ -d "$TEST_TMP_DIR" ]; then
        if [ -d "$TEST_TMP_DIR/extracted" ]; then
            docker run --rm -v "$TEST_TMP_DIR:/data" alpine sh -c 'chmod -R 777 /data/extracted 2>/dev/null; rm -rf /data/extracted' 2>/dev/null || true
        fi
        rm -rf "$TEST_TMP_DIR" 2>/dev/null || true
    fi
}

create_test_mod_dir() {
    local input_dir="$1"
    local output_dir="$2"
    
    mkdir -p "$input_dir" "$output_dir"
    
    echo "class CfgPatches { class TestMod { requiredAddons[] = {}; }; };" > "$input_dir/config.cpp"
    echo "TestMod" > "$input_dir/\$PBOPREFIX\$"
}

@test "docker is available" {
    check_docker
    [ $DOCKER_READY -eq 1 ]
}

@test "depbo-tools image is available" {
    check_depbo_tools
    [ $? -eq 0 ]
}

@test "makepbo creates PBO file" {
    local input_dir="$TEST_TMP_DIR/source"
    local output_dir="$TEST_TMP_DIR/output"
    
    create_test_mod_dir "$input_dir" "$output_dir"
    
    (
        cd "$TEST_TMP_DIR"
        docker_makepbo -@="TestMod" source output/TestMod.pbo
    )
    
    [ -f "$output_dir/TestMod.pbo" ]
}

@test "makepbo output is valid PBO" {
    local input_dir="$TEST_TMP_DIR/source"
    local output_dir="$TEST_TMP_DIR/output"
    
    create_test_mod_dir "$input_dir" "$output_dir"
    
    (
        cd "$TEST_TMP_DIR"
        docker_makepbo -@="TestMod" source output/TestMod.pbo > /dev/null
    )
    
    local size=$(stat -f%z "$output_dir/TestMod.pbo" 2>/dev/null || stat -c%s "$output_dir/TestMod.pbo")
    [ "$size" -gt 0 ]
}

@test "extractpbo extracts PBO contents" {
    local input_dir="$TEST_TMP_DIR/source"
    local output_dir="$TEST_TMP_DIR/output"
    local extract_dir="$TEST_TMP_DIR/extracted"
    
    create_test_mod_dir "$input_dir" "$output_dir"
    mkdir -p "$extract_dir"
    
    (
        cd "$TEST_TMP_DIR"
        docker_makepbo -@="TestMod" source output/TestMod.pbo > /dev/null
    )
    
    (
        cd "$TEST_TMP_DIR"
        docker_extractpbo "output/TestMod.pbo" "$(pwd)/extracted" > /dev/null
    )
    
    [ -d "$extract_dir/TestMod" ]
}

@test "extractpbo preserves config.cpp" {
    local input_dir="$TEST_TMP_DIR/source"
    local output_dir="$TEST_TMP_DIR/output"
    local extract_dir="$TEST_TMP_DIR/extracted"
    
    create_test_mod_dir "$input_dir" "$output_dir"
    mkdir -p "$extract_dir"
    
    (
        cd "$TEST_TMP_DIR"
        docker_makepbo -@="TestMod" source output/TestMod.pbo > /dev/null
        docker_extractpbo "output/TestMod.pbo" "$(pwd)/extracted" > /dev/null
    )
    
    [ -f "$extract_dir/TestMod/config.cpp" ]
}

@test "rapify creates binary config" {
    local input_dir="$TEST_TMP_DIR/source"
    
    create_test_mod_dir "$input_dir" "$input_dir"
    
    (
        cd "$input_dir"
        docker_rapify config.cpp config.bin > /dev/null
    )
    
    [ -f "$input_dir/config.bin" ]
}

@test "rapify output is valid binary" {
    local input_dir="$TEST_TMP_DIR/source"
    
    create_test_mod_dir "$input_dir" "$input_dir"
    
    (
        cd "$input_dir"
        docker_rapify config.cpp config.bin > /dev/null
    )
    
    local size=$(stat -f%z "$input_dir/config.bin" 2>/dev/null || stat -c%s "$input_dir/config.bin")
    [ "$size" -gt 0 ]
}

@test "cmd/mods build command exists" {
    [ -f "$CMD_DIR/mods" ]
    bash "$CMD_DIR/mods" build 2>&1 | grep -q "Usage"
}

@test "docker_makepbo with absolute paths" {
    local input_dir="$TEST_TMP_DIR/abs/source"
    local output_dir="$TEST_TMP_DIR/abs/output"
    
    create_test_mod_dir "$input_dir" "$output_dir"
    
    (
        cd "$TEST_TMP_DIR/abs"
        docker_makepbo -@="TestMod" source output/TestMod.pbo > /dev/null
    )
    
    [ -f "$output_dir/TestMod.pbo" ]
}

@test "docker_extractpbo with absolute output path" {
    local input_dir="$TEST_TMP_DIR/abs2/source"
    local output_dir="$TEST_TMP_DIR/abs2/output"
    local extract_dir="$TEST_TMP_DIR/abs2/extracted"
    
    create_test_mod_dir "$input_dir" "$output_dir"
    mkdir -p "$extract_dir"
    
    (
        cd "$TEST_TMP_DIR/abs2"
        docker_makepbo -@="TestMod" source output/TestMod.pbo > /dev/null
        docker_extractpbo "output/TestMod.pbo" "$(pwd)/extracted" > /dev/null
    )
    
    [ -d "$extract_dir/TestMod" ]
    [ -f "$extract_dir/TestMod/config.cpp" ]
}

@test "calculate_mod_version returns valid version" {
    local mod_dir="$TEST_TMP_DIR/version-test"
    mkdir -p "$mod_dir"
    
    local version=$(calculate_mod_version "$mod_dir")
    
    [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]] || [ "$version" = "0.0.0-local" ]
}

@test "calculate_mod_version falls back to local" {
    local mod_dir="$TEST_TMP_DIR/no-version"
    mkdir -p "$mod_dir"
    
    local version=$(calculate_mod_version "$mod_dir")
    
    [ "$version" = "0.0.0-local" ]
}

@test "calculate_mod_version reads from version file" {
    local mod_dir="$TEST_TMP_DIR/file-version"
    mkdir -p "$mod_dir"
    echo "1.2.3" > "$mod_dir/version"
    
    local version=$(calculate_mod_version "$mod_dir")
    
    [ "$version" = "1.2.3" ]
}

@test "calculate_mod_version reads from package.json" {
    local mod_dir="$TEST_TMP_DIR/json-version"
    mkdir -p "$mod_dir"
    echo '{"version":"2.0.0"}' > "$mod_dir/package.json"
    
    local version=$(calculate_mod_version "$mod_dir")
    
    [ "$version" = "2.0.0" ]
}

@test "get_git_commit_hash returns short hash or unknown" {
    local commit=$(get_git_commit_hash)
    
    [ -n "$commit" ]
}

@test "get_build_timestamp returns ISO format" {
    local timestamp=$(get_build_timestamp)
    
    [[ "$timestamp" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

@test "generate_version_metadata creates valid JSON" {
    local output_dir="$TEST_TMP_DIR/metadata"
    mkdir -p "$output_dir"
    
    generate_version_metadata "1.0.0" "$output_dir"
    
    [ -f "$output_dir/version.txt" ]
    grep -q '"version"' "$output_dir/version.txt"
    grep -q '"commit"' "$output_dir/version.txt"
    grep -q '"buildtime"' "$output_dir/version.txt"
}

@test "ensure_mod_cpp creates mod.cpp when missing" {
    local mod_dir="$TEST_TMP_DIR/no-mod-cpp"
    local output_dir="$TEST_TMP_DIR/mod-cpp-out"
    mkdir -p "$mod_dir" "$output_dir"
    
    ensure_mod_cpp "$mod_dir" "TestMod" "1.0.0" "$output_dir"
    
    [ -f "$output_dir/mod.cpp" ]
    grep -q '"TestMod"' "$output_dir/mod.cpp"
}

@test "ensure_mod_cpp copies existing mod.cpp" {
    local mod_dir="$TEST_TMP_DIR/with-mod-cpp"
    local output_dir="$TEST_TMP_DIR/mod-cpp-copy"
    mkdir -p "$mod_dir" "$output_dir"
    echo "name = \"Original\";" > "$mod_dir/mod.cpp"
    
    ensure_mod_cpp "$mod_dir" "TestMod" "1.0.0" "$output_dir"
    
    [ -f "$output_dir/mod.cpp" ]
    grep -q "Original" "$output_dir/mod.cpp"
}

@test "create_mod_symlink creates symlink in mods directory" {
    local build_dir="$TEST_TMP_DIR/build/@TestMod"
    local mods_dir="$TEST_TMP_DIR/mods"
    mkdir -p "$build_dir"
    
    create_mod_symlink "TestMod" "$build_dir" "$mods_dir"
    
    [ -L "$mods_dir/@TestMod" ]
}

@test "versioned PBO filename includes version" {
    local input_dir="$TEST_TMP_DIR/versioned/source"
    local output_dir="$TEST_TMP_DIR/versioned/output"
    
    create_test_mod_dir "$input_dir" "$output_dir"
    echo "1.5.0" > "$input_dir/../version"
    
    mkdir -p "$TEST_TMP_DIR/versioned"
    echo "1.5.0" > "$TEST_TMP_DIR/versioned/version"
    
    (
        cd "$TEST_TMP_DIR/versioned"
        local version=$(calculate_mod_version ".")
        docker_makepbo -@="TestMod" source output/TestMod-${version}.pbo > /dev/null
    )
    
    [ -f "$output_dir/TestMod-1.5.0.pbo" ]
}
