use crate::models::MessageResponse;
use axum::{Json, http::StatusCode, response::IntoResponse};

pub async fn welcome() -> impl IntoResponse {
    let response = MessageResponse {
        message: "Welcome from the Rust Axum service!".to_string(),
    };
    (StatusCode::OK, Json(response))
}
