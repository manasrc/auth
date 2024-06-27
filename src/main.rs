use axum::{response::IntoResponse, routing::get, Json, Router};
use serde_json::json;
use std::net::SocketAddr;

const VERSION: &str = env!("CARGO_PKG_VERSION");
const SERVICE: &str = env!("CARGO_PKG_NAME");

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(version));

    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));
    println!("listening on {}", addr);

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn version() -> impl IntoResponse {
    return Json(json!({
        "service": String::from(SERVICE),
        "version": String::from(VERSION)
    }));
}
