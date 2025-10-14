use serde::Serialize;

#[derive(Serialize)]
pub struct StatusResponse {
    pub status: String,
}

#[derive(Serialize)]
pub struct MessageResponse {
    pub message: String,
}
