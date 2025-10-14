# 1. Create project (if new)

cargo new rust-service
cd rust-service

# 2. Add dependencies

cargo add axum
cargo add tokio --features full
cargo add serde --features derive
cargo add tracing
cargo add tracing-subscriber
cargo add dotenvy

# 3. Create module structure manually

mkdir -p src/{models,routes}
touch src/models/mod.rs
touch src/routes/{mod.rs,health.rs,welcome.rs}
touch src/config.rs

# 4. Edit files with your editor

code .  # VS Code 
# or vim, nano, etc.

# 5. Check compilation as you go

cargo check

# 6. Run when ready

cargo run

# 7. Cargo Watch

```bash
cargo install cargo-watch
cargo watch -x run  # Auto-runs on file changes
```

🦀
