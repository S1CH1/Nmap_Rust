use tokio::net::TcpStream; // importation de TcpStream pour la gestion des connexions TCP
use std::time::Duration; // importation de Duration pour la gestion des durées
use clap::Parser; // importation de Parser pour la gestion des arguments du terminal

// Arguments du terminal par le User
#[derive(Parser)]
struct Args {
    // adrr Ip 
    ip: String,
}

#[tokio::main] // fonction principale asynchrone
async fn main() {
    let args = Args::parse(); // pour parser les args du terminal
    let ip = args.ip;   // adresse IP à scanner
    let start_port = 1; // Port de départ
    let end_port = 1024; // Port de fin


    print!("Début du scan \n");
    for port in start_port..=end_port {
        if scan_port(&ip, port).await { // Emprunter la String ip
            println!("Port {} is open", port);
        }
    }
    print!("Fin du Scan \n");
}

async fn scan_port(ip: &str, port: u16) -> bool {
    let addr = format!("{}:{}", ip, port);
    match tokio::time::timeout(Duration::from_secs(1), TcpStream::connect(&addr)).await {
        Ok(Ok(_)) => true,
        _ => false,
    }
}


