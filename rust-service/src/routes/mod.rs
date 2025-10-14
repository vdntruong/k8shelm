mod health;
mod welcome;

use axum::{Router, routing::get};

pub use health::health_check;
pub use welcome::welcome;

pub fn create_router() -> Router {
    Router::new()
        .route("/", get(welcome))
        .route("/health", get(health_check))
}
