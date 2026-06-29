# Android-Based Virtual Server Resource Monitoring Application

<img src="Andi%20Rifqial%20Nur%20-%20Poster.jpg" alt="Application architecture poster for Android-based virtual server resource monitoring" width="100%" />

This project is a Flutter mobile application for monitoring virtual server resources from a Proxmox environment. The application focuses on CPU, RAM, and disk usage for Proxmox nodes, virtual machines, and LXC containers. A Flask backend acts as the bridge between the mobile application, MySQL/MariaDB storage, the Proxmox API, and SSH-based resource management commands.

## Architecture Overview

The system is built around four main parts:

- **Flutter mobile app**: provides the administrator interface for authentication, host management, monitoring, and resource control.
- **Flask backend API**: handles admin registration/login, stores Proxmox host records, proxies Proxmox API requests, and exposes endpoints consumed by the mobile app.
- **MySQL/MariaDB database**: stores administrator accounts and registered Proxmox host credentials.
- **Proxmox + SSH layer**: provides live node, VM, and container data through the Proxmox API, while resource edits are executed through SSH commands using Paramiko.

The resource data for nodes, virtual machines, and containers is fetched directly from Proxmox when the app is used. The database is mainly used for administrator and host data.

## Key Features

- **Administrator authentication**
  - Register a new administrator account.
  - Login with email and password.
  - View basic profile information and logout from the profile page.

- **Proxmox host management**
  - Register a Proxmox host using IP address, port, username, and password.
  - Save host data in the database.
  - Update registered host connection data.
  - Login to a selected host before opening the monitoring pages.

- **Node monitoring**
  - Display the list of Proxmox nodes.
  - Open node details with live CPU, RAM, disk, and status information.
  - Poll node data periodically so the displayed values stay updated.

- **Virtual machine monitoring**
  - Display virtual machines from the selected Proxmox node.
  - Sort VM data by name and VM ID.
  - Open VM details with CPU, RAM, disk usage, status indicator, and resource cards.
  - Poll VM list and VM detail data periodically.

- **Container monitoring**
  - Display LXC containers from the selected Proxmox node.
  - Sort container data by name and container ID.
  - Open container details with CPU, RAM, disk usage, status indicator, and resource cards.
  - Poll container list and container detail data periodically.

- **Manual resource editing**
  - Edit VM CPU core allocation.
  - Edit VM memory allocation.
  - Resize VM disk capacity.
  - Edit container CPU core allocation.
  - Edit container memory allocation.
  - Resize container disk capacity.

- **Automatic memory adjustment**
  - Start or stop automatic memory adjustment for a VM.
  - Start or stop automatic memory adjustment for a container.
  - The backend monitors memory usage in a background loop and increases configured memory when usage passes the automation threshold.

- **Research-oriented response logging**
  - Backend endpoints measure and print response time, which supports API latency testing and quality-of-service analysis.

## Application Flow

1. The app opens with a splash screen.
2. The administrator signs in or creates a new account.
3. After authentication, the administrator enters the main dashboard.
4. The administrator opens the host page from the center floating action button.
5. If no host exists, the administrator registers a Proxmox host.
6. If hosts already exist, the administrator selects one host and logs in with Proxmox credentials.
7. After host login, the app shows host information and the Proxmox username used by the session.
8. The administrator opens the node list.
9. From a node detail page, the administrator can open either:
   - the virtual machine list, or
   - the container list.
10. From a VM or container detail page, the administrator can monitor resources, edit CPU/RAM/disk allocation, or enable automatic memory adjustment.

## Backend API Summary

| Area | Endpoint | Purpose |
| --- | --- | --- |
| Admin | `POST /registerAdmin` | Create an administrator account. |
| Admin | `POST /loginAdmin` | Authenticate an administrator. |
| Host | `POST /registerHosts` | Register and validate a Proxmox host. |
| Host | `POST /loginHosts` | Login to a registered Proxmox host and store the active Proxmox session. |
| Host | `GET /getHosts` | Fetch registered hosts. |
| Host | `GET /hosts/<id>` | Fetch one registered host by ID. |
| Host | `PUT /updateHosts/<id>` | Update registered host connection data. |
| Node | `GET /getNode` | Fetch Proxmox node list. |
| Node | `GET /getNodeByIndex/<index>` | Fetch a selected node and set it as the active node. |
| VM | `GET /vm` | Fetch virtual machines from the active node. |
| VM | `GET /virtualmachines/<id>` | Fetch VM detail data. |
| VM | `POST /editcpuvm` | Update VM CPU cores through SSH. |
| VM | `POST /editmemvm` | Update VM memory through SSH. |
| VM | `POST /editdiskvm` | Resize VM disk through SSH. |
| VM | `POST /memoryautovm` | Start or stop automatic VM memory adjustment. |
| Container | `GET /container` | Fetch LXC containers from the active node. |
| Container | `GET /containerview/<id>` | Fetch container detail data. |
| Container | `POST /editcpucontainer` | Update container CPU cores through SSH. |
| Container | `POST /editmemcontainer` | Update container memory through SSH. |
| Container | `POST /editdiskcontainer` | Resize container disk through SSH. |
| Container | `POST /memoryautocon` | Start or stop automatic container memory adjustment. |

## Tech Stack

- Flutter
- Provider state management
- HTTP client package
- Shared Preferences
- Flask
- MySQL/MariaDB
- Proxmox API
- Paramiko SSH
- Nginx and uWSGI Emperor for server deployment

## Project Structure

```text
lib/
  main.dart                    Application entry point and route registration
  pages/                       Flutter screens for auth, dashboard, host, node, VM, and container flows
  providers/                   Provider classes for app state and polling
  services/                    HTTP service classes that call the Flask backend
  model/                       Data models used by providers and screens
  widgets/                     Reusable UI widgets and resource edit dialogs

api_server.py                  Flask backend API for admin, host, Proxmox, and SSH operations
db_test.sql                    Database dump for admin, token, host, VM, and container-related tables
assets/                        Mobile app icons and UI images
```

## Getting Started

### 1. Prepare the backend database

Create a MySQL/MariaDB database named `db_test`, then import the provided SQL dump:

```bash
mysql -u root -p -e "CREATE DATABASE db_test"
mysql -u root -p db_test < db_test.sql
```

The current backend database connection is configured in `api_server.py`:

```python
host="localhost"
user="root"
password="123"
database="db_test"
```

Update those values if your database credentials are different.

### 2. Install backend dependencies

```bash
pip install flask requests paramiko mysql-connector-python
```

Run the Flask API:

```bash
python api_server.py
```

For production deployment, this backend can be served behind Nginx using uWSGI Emperor.

### 3. Configure the mobile app API URL

The Flutter service classes currently use this backend URL:

```dart
static String baseUrl = 'http://192.168.100.80';
```

Update the `baseUrl` value in `lib/services/*.dart` so the mobile app can reach your Flask backend.

### 4. Run the Flutter app

```bash
flutter pub get
flutter run
```

## Proxmox Requirements

The selected Proxmox host must be reachable from the backend server. The Proxmox user should have enough permission to:

- request API tickets,
- read node, VM, and LXC container status,
- execute VM commands such as `qm set`, `qm resize`, `qm stop`, and `qm start`,
- execute container commands such as `pct set` and `pct resize`.

## Notes

- VM and container monitoring data is retrieved from Proxmox in real time after a host and node are selected.
- The mobile app uses periodic polling for list and detail screens.
- Host credentials are currently stored in the database; production usage should move sensitive values to a safer credential management strategy.
- The poster image must be committed together with this README so GitHub can render it correctly.
