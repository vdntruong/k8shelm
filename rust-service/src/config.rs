use std::env;
use std::net::SocketAddr;

pub struct Config {
    pub socket_addr: SocketAddr,
}

impl Config {
    pub fn from_env() -> Self {
        let port = env::var("PORT").unwrap_or_else(|_| "8080".to_string());
        let addr = format!("0.0.0.0:{}", port);
        let socket_addr: SocketAddr = addr.parse().expect("Failed to parse listen address");

        Self { socket_addr }
    }
}
