# Home Lab Infrastructure

## 1. OVERVIEW
This monorepo manages the infrastructure and AI agents for a secure, highly-available home lab environment. Driven by Infrastructure as Code (IaC) using Ansible, the primary goals of this project are automated zero-touch provisioning, robust network segmentation, and stringent security policies following the Principle of Least Privilege.

## 2. ARCHITECTURE & TOPOLOGY
The infrastructure is composed of the following managed hardware:
- **Mikrotik Router** acting as the core firewall, DHCP server, DNS resolver, and WireGuard VPN endpoint.
- **Raspberry Pi Node(s)** (`rpi_server`) hosting isolated, Dockerized AI domains.

### L2/L3 Network Topology
The network is strictly segmented into purpose-driven VLANs:
- **Trusted**: High-privilege admin devices.
- **Work**: Corporate devices and telecommuting.
- **IoT**: Untrusted smart home devices without internet access.
- **Guests**: Isolated internet-only access for visitors.
- **Servers**: Raspberry Pi nodes and application containers.
- **Media**: Smart TVs and streaming devices.
- **Failsafe**: Emergency fallback management subnet.
- **VPN**: WireGuard VPN clients.

### Core Services
- **WireGuard VPN**: Encrypted remote access tunnel.
- **DHCP & DNS**: Local DNS resolution, NTP client, and IP address management handled centrally on the router.
- **Log Archival**: Automated daily log conservation system script.

## 3. DESIGN PRINCIPLES
- **Two-Tier Vault Mapping**: Secrets are encrypted in `vault.yml` and explicitly mapped to plaintext variables in `vars.yml` to prevent abstraction leaks. Domain files (e.g., templates, playbooks) never reference `vault_` variables directly.
- **Domain Segregation**: Logic is split into isolated domain files within `group_vars` (e.g., `interfaces.yml`, `firewall.yml`, `dhcp.yml`, `wireguard.yml`, `services.yml`). This ensures clean Domain-Driven Design (DDD).
- **Physical/Logical Separation**: There is a strict separation between `host_vars` (which define physical hardware traits, serial numbers, and management IPs) and `group_vars` (which define the overarching business logic and domain policies).

## 4. MANUAL PREREQUISITES
Before running any automated pipelines, the following manual steps MUST be completed on the control node and managed hardware:

1. **Generate SSH Keys**:
   On your Ansible control node, generate a strong SSH keypair:
   ```bash
   ssh-keygen -t ed25519 -C "ansible-control-node"
   ```

2. **Create Service Accounts & Import Keys**:
   A dedicated service account (e.g., `svc_ansible`) must be created on all managed targets (Mikrotik, Raspberry Pi).
   - **On Mikrotik**:
     Import the public key via WinBox or terminal, create the user, assign the `full` group, and attach the SSH key to the user.
   - **On Raspberry Pi**:
     Create the user and add the public key to `/home/<user>/.ssh/authorized_keys`. Ensure the user has passwordless `sudo` privileges for Ansible `become` operations.

## 5. DEPLOYMENT WORKFLOW (Usage Pipeline)

### Phase 1 - Bootstrap
Instructions for initializing the control node environment by setting up the Python virtual environment and installing all required Ansible dependencies.
```bash
./infrastructure/bootstrap/setup_control_node.sh
source venv/bin/activate
```

### Phase 2 - Dry Run (Validation)
Safely simulate the deployment without making changes to verify template rendering and configurations.
```bash
cd infrastructure/ansible
# Render Mikrotik templates locally for visual inspection:
ansible-playbook playbooks/test-mikrotik-render.yml --ask-vault-pass

# Run a check-mode diff on the router:
ansible-playbook playbooks/deploy-mikrotik.yml --ask-vault-pass --check --diff
```

### Phase 3 - Production Deployment
Instructions for applying the actual configuration to the infrastructure.
```bash
cd infrastructure/ansible
# Deploy base setup and hardening to servers:
ansible-playbook site.yml -K

# Deploy the Mikrotik network configuration:
ansible-playbook playbooks/deploy-mikrotik.yml --ask-vault-pass
```

## 6. SECURITY & CI/CD
- **Automated Hook Checks**: The project utilizes standard pre-commit hooks such as `ansible-lint` and `yamllint` to enforce syntax formatting and catch common errors before code is pushed.
- **AI Agent Pre-Commit Audit**: A custom `pre-commit-audit` AI skill is actively used to perform logical error checking, redundancy cleanup, architecture rule enforcement, and documentation synchronization before merging changes.
- **Secret Scanning**: A local custom pre-commit hook (`check-ansible-vault`) strictly verifies that all `vault.yml` files contain valid `$ANSIBLE_VAULT` signatures before any commit is allowed.
