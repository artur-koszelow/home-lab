# Home Lab Security & Automation

This monorepo manages the infrastructure and AI agents for a secure home lab environment, utilizing **Ansible** for infrastructure as code and **Docker** for isolated container deployments.

## Project Structure

*   `infrastructure/` - Ansible playbooks, inventory, and network configs.
    *   `ansible/site.yml` - Main Ansible entry point.
    *   `ansible/playbooks/` - Contains specific automation tasks (e.g., `base_setup.yml`, `control_node_setup.yml`).
    *   `ansible/inventory/production/` - Environment variables, host definitions, and `ansible-vault` secrets.
    *   `mikrotik/` - Network router configurations (e.g., `safe-config.rsc`) for reference and security auditing.
    *   `bootstrap/` - Initial setup scripts for the control node.
*   `ai_agents/` - Dockerized AI domain environments following Domain-Driven Design.
    *   Each agent/service runs in its own isolated directory and Docker network.
*   `GEMINI.md` - Core system prompts and architectural/security directives (IRON RULES).

## Getting Started

### 1. Bootstrap Environment
Run the bootstrap script to create a Python virtual environment and install Ansible dependencies:
```bash
./infrastructure/bootstrap/setup_control_node.sh
source venv/bin/activate
```

### 2. Running Playbooks (Manual Workflow)
Playbooks are designed to be run manually. To authenticate for system-level tasks (`become: true`), use the `-K` (or `--ask-become-pass`) flag to provide your sudo password interactively from your password manager:
```bash
cd infrastructure/ansible
ansible-playbook site.yml -K
```
*Note: The `ansible.cfg` is configured to automatically prompt for a vault password (`ask_vault_pass = True`) to decrypt infrastructure secrets.*

## Security Directives (IRON RULES)
1.  **Secrets Management:** Never commit plain text passwords. Use `ansible-vault` for infrastructure and `.env` files for Docker.
2.  **Principle of Least Privilege (PoLP):** No containers or services run as root. The playbook creates a dedicated `appuser` (UID 2000) for running services.
3.  **Domain Isolation:** AI domain containers are isolated. They do not share Docker networks or volumes.
4.  **Network Security:** Default firewall policy is `DROP`. SSH is restricted to key-based auth and trusted subnets only.
