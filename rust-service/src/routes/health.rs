use crate::models::StatusResponse;
use axum::{Json, http::StatusCode, response::IntoResponse};

pub async fn health_check() -> impl IntoResponse {
    let response = StatusResponse {
        status: "ok".to_string(),
    };
    (StatusCode::OK, Json(response))
}
