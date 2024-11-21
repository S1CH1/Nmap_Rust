use tokio::net::TcpStream;
use std::time::Duration;
use clap::Parser;

/// Structure pour les arguments de la ligne de commande
#[derive(Parser)]
struct Args {
    /// Adresse IP à scanner
    ip: String,
}

#[tokio::main]
async fn main() {
    let args = Args::parse(); // Parse les arguments de la ligne de commande
    let ip = args.ip; // Adresse IP à scanner
    let start_port = 1; // Port de départ
    let end_port = 1024; // Port de fin

    let mut tasks = vec![];

    for port in start_port..=end_port {
        let ip = ip.clone(); // Clone l'adresse IP pour chaque tâche
        let task = tokio::spawn(async move {
            if scan_port(&ip, port).await {
                println!("Port {} is open", port);
            }
        });
        tasks.push(task);
    }

    // Attendre que toutes les tâches soient terminées
    for task in tasks {
        let _ = task.await;
    }
}

async fn scan_port(ip: &str, port: u16) -> bool {
    let addr = format!("{}:{}", ip, port);
    match tokio::time::timeout(Duration::from_secs(1), TcpStream::connect(&addr)).await {
        Ok(Ok(_)) => true,
        _ => false,
    }
}