mod config;
mod models;
mod routes;

use config::Config;
use routes::create_router;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();

    // init logging
    tracing_subscriber::fmt::init();

    // Load configuration
    let config = Config::from_env();

    let app = create_router();

    tracing::info!(
        "Rust Axum service starting on http://{}",
        config.socket_addr
    );

    // Start server
    let listener = tokio::net::TcpListener::bind(&config.socket_addr)
        .await
        .expect("Failed to bind to address");

    axum::serve(listener, app).await.expect("Server error");
}
