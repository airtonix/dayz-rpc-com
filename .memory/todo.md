# Implementation TODO

## Phase 1: Documentation (Priority: HIGH)
- [ ] Add "Server vs Client Mods" section to docs/mods.md
- [ ] Document --serverMod parameter in docs/config.md
- [ ] Document bundle structure examples in docs/mods.md

## Phase 2: Code Updates (Priority: HIGH)
- [ ] Update enable_mod() to accept --server/--client flags
- [ ] Update create_bundle() to accept --server/--client flags
- [ ] Update add_to_bundle() to require --server/--client flag specification
- [ ] Update remove_from_bundle() to work without type info
- [ ] Update list_bundles() to display server vs client mods separately
- [ ] Update cmd/server to use --serverMod parameter for server array mods only

## Phase 3: Validation (Priority: MEDIUM)
- [ ] Test enable_mod with --server and --client flags
- [ ] Test bundle operations with mixed server/client mods
- [ ] Verify cmd/server loads correct mods from bundle
- [ ] Manual testing with actual server startup

## Current Status
Ready to begin Phase 1: Documentation updates
