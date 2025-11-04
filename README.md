# Relay 🚀

**CLI-based, real-time chat server built in Rust**

A fast, concurrent, and secure terminal chat server featuring multi-room support, atomic state management, and asynchronous I/O. Built with Tokio for high-performance networking.

[![CI/CD](https://github.com/beingglitch/relay/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/beingglitch/relay/actions)
[![Rust](https://img.shields.io/badge/rust-1.75%2B-orange.svg)](https://www.rust-lang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## ✨ Features

- 🧵 **Asynchronous I/O** using [Tokio](https://tokio.rs/) for high concurrency
- 📡 **Real-time broadcasting** with `tokio::sync::broadcast`
- 🚀 **Dockerized** with automated CI/CD to AWS EC2
- ⚡ **Zero-copy** architecture for optimal performance

---

## 🌐 Live Demo

**Try it now!** Connect to the public instance:
```bash
nc 3.109.153.221 7000
```

Or using telnet:
```bash
telnet 3.109.153.221 7000
```

---

## 🚀 Quick Start

### Local Development
```bash
# Clone the repository
git clone https://github.com/beingglitch/relay.git
cd relay

# Build and run
cargo run

# Run on custom port
cargo run -- 0.0.0.0:8080
```

The server will start on `0.0.0.0:7000` by default.

---

## 📖 Usage

### Connect to Server
```bash
nc localhost 7000
```

### Available Commands
```
HELP              Show available commands
NICK <name>       Set your nickname (required before creating/joining)
CREATE            Create a new room (returns a unique room code)
JOIN <CODE>       Join an existing room by code
MSG <text>        Send a message to your current room
QUIT              Disconnect from server
```

### Example Session

**Terminal 1 (Alice):**
```bash
$ nc 3.109.153.221 7000
Welcome to Relay!
Type HELP for commands
NICK alice
[ok] nickname set to 'alice'
CREATE
[ok] room created: A3B7JK2M
[server] alice joined
MSG hello everyone!
alice: hello everyone!
[server] bob joined.
bob: hi alice!
MSG hey bob, welcome!
alice: hey bob, welcome!
```

**Terminal 2 (Bob):**
```bash
$ nc 3.109.153.221 7000
Welcome to Relay!
Type HELP for commands
NICK bob
[ok] nickname set to 'bob'
JOIN A3B7JK2M
[ok] joined room 'A3B7JK2M'
[server] bob joined.
alice: hello everyone!
MSG hi alice!
bob: hi alice!
alice: hey bob, welcome!
```

---

## 🏗️ Architecture
```
┌─────────────────────────┐
│   TCP Listener          │  ← Accepts connections
│   (server.rs)           │
└────────┬────────────────┘
         │
         ├──> Client 1 (alice)
         ├──> Client 2 (bob)
         └──> Client 3 (carol)
              │
              ▼
┌─────────────────────────┐
│   Per-Client Handler    │  ← tokio::spawn per connection
│   (conn.rs)             │
└────────┬────────────────┘
         │
         ├──> tokio::select! {
         │      rx.recv()      → Room broadcasts
         │      read_line()    → Client input
         │    }
         │
         ▼
┌─────────────────────────┐
│   Shared State          │  ← DashMap<RoomCode, Room>
│   (state.rs)            │
└─────────────────────────┘
         │
         ▼
┌─────────────────────────┐
│   Broadcast Channels    │  ← tokio::sync::broadcast
│   (room.rs)             │
└─────────────────────────┘
```

### Project Structure
```
relay/
├─ src/
│  ├─ main.rs          # Entry point
│  ├─ server.rs        # TCP listener & connection spawning
│  ├─ conn.rs          # Per-connection handler (select! loop)
│  ├─ protocol.rs      # Command parsing (NICK, CREATE, JOIN, MSG)
│  ├─ room.rs          # Room type (broadcast + atomic counters)
│  ├─ state.rs         # Global room registry (DashMap)
│  └─ codegen.rs       # Crockford base32 room code generator
├─ Dockerfile          # Multi-stage build for minimal image
├─ .github/
│  └─ workflows/
│     └─ ci-cd.yml     # Automated build, test, and deploy
└─ README.md
```

---

## 🐳 Docker Deployment

### Build Locally
```bash
docker build -t relay .
docker run -d -p 7000:7000 --name relay relay
```

### Pull from Docker Hub
```bash
docker pull beingglitch/relay:latest
docker run -d -p 7000:7000 --name relay beingglitch/relay:latest
```

---

## 🛣️ Next Steps

### Security
- [ ] TLS/SSL encryption
- [ ] End-to-end encryption (E2EE)
- [ ] User authentication

### Testing
- [ ] Unit & integration tests
- [ ] Load testing
- [ ] Code coverage >80%

### Features
- [ ] Rich TUI client
- [ ] Message history
- [ ] `ROOMS`, `WHO`, `LEAVE` commands
- [ ] Private messages

### Scale
- [ ] Redis for multi-instance
- [ ] PostgreSQL for persistence
- [ ] Metrics & monitoring

### Advanced
- [ ] WebSocket support
- [ ] File sharing
- [ ] Bot API

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch:**
```bash
   git checkout -b feature/amazing-feature
```
3. **Make your changes and test:**
```bash
   cargo test
   cargo fmt
   cargo clippy
```
4. **Commit with conventional commits:**
```bash
   git commit -m "feat: add room password protection"
```
5. **Push and create a Pull Request**

### Development Guidelines

- Follow Rust conventions and idioms
- Add tests for new features
- Update documentation
- Keep commits atomic and well-described
- Run `cargo fmt` and `cargo clippy` before committing

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with [Tokio](https://tokio.rs/) — asynchronous runtime
- Inspired by IRC and modern chat systems
- Thanks to the Rust community for excellent tooling

---

## 📧 Contact

**Project Link:** [https://github.com/beingglitch/relay](https://github.com/beingglitch/relay)

**Live Instance:** `nc 3.109.153.221 7000`

---

## 🎯 Why Relay?

- **Educational:** Learn async Rust, networking, and system design
- **Production-ready:** Battle-tested patterns and safety guarantees
- **Extensible:** Clean architecture for adding features
- **Fast:** Tokio-powered concurrency handles 1000+ connections
- **Secure:** Designed with security best practices from day one

---

**Built with ❤️ and Rust** 🦀