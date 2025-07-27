
## Infrastructure Overview

This repository provides multiple approaches for deploying and managing the chessu application. You can choose between **Terraform** for cloud infrastructure provisioning, or **Ansible** and **Docker** for local deployment and automation. These tools are independent—use whichever best fits your workflow.

### Directory Structure

- `terraform/` — Infrastructure as Code for provisioning cloud resources (e.g., servers, databases, networking).
- `ansible/` — Configuration management and automation scripts for local or remote servers.
- `docker/` — Dockerfiles and Compose files for containerized local deployment.

---

## Terraform (Cloud Infrastructure)

The `terraform/` directory contains configuration files to provision cloud resources such as VMs, managed databases, and networking.  
**Note:** Terraform is intended for cloud deployments and is not required for local development.

**Getting Started:**

1. Install [Terraform](https://www.terraform.io/downloads.html).
2. Create S3 buckets for storing infrastructure and database state files if you plan to use remote state.
3. Create `terraform.tfvars` files and fill in your secrets and variables.
4. Initialize and apply:
  ```sh
  cd terraform
  terraform init
  terraform apply
  ```
5. Review outputs for connection details.

**Ignored files:**
- `.terraform/` — Terraform state and cache directory.
- `terraform.tfstate` / `terraform.tfstate.backup` — State files tracking resource deployments.
- `terraform.tfvars` — Contains sensitive variable values (never commit this file).

**Security Note:**  
Never share or commit your `terraform.tfvars` or state files, as they may contain sensitive information.

---

## Ansible (Local or Remote Automation)

The `ansible/` directory contains playbooks and roles for automating the setup and configuration of servers.  
**Note:** Ansible is independent of Terraform and can be used for local deployment or to configure remote servers provisioned by any method.

- Customize inventory files (e.g., `hosts`) for your environment.
- Create secrets and vault files (e.g., `vault.yml`) locally as needed.

**Ignored files:**
- `vault.yml` — Stores encrypted secrets for Ansible Vault.
- `*.retry` — Retry files generated after failed runs.

---

## Docker (Local Deployment)

The `docker/` directory provides Dockerfiles and Compose files for building and running the application locally or in production.  
**Note:** Docker is independent of both Terraform and Ansible, and is recommended for quick local setup.

- Use `docker-compose.yml` for multi-service orchestration.
- Create your own environment files (e.g., `.env`) with appropriate values.

**Ignored files:**
- `.env` — Contains environment variables and secrets for Docker Compose.

---

## Deployment Options

You can reproduce the infrastructure and run chessu using any of the following methods:

1. **Cloud Deployment with Terraform**
  - Provision resources (servers, databases, networking) in your cloud provider.
  - (Optional) Configure remote state storage (e.g., S3 buckets).
  - Use the provided Makefile to automate infrastructure tasks (e.g., `make infrastructure`).

2. **Local or Remote Automation with Ansible**
  - Use Ansible playbooks to configure servers after provisioning (with or without Terraform).
  - Suitable for automating setup on VMs, bare metal, or cloud instances.

3. **Local Deployment with Docker**
  - Build and run containers using Docker Compose for development or testing.
  - No cloud resources required.

Choose the approach that best fits your needs—these tools are not dependent on each other.



<h1 align="center">
  <img src="./assets/chessu.png" alt="chessu" height="128" />
</h1>
<p align="center">
  <a href="https://ches.su">
    <img src="https://img.shields.io/github/deployments/dotnize/chessu/Production?label=deployment&style=for-the-badge&color=blue" alt="ches.su" />
  </a>
  <img src="https://img.shields.io/github/last-commit/dotnize/chessu?style=for-the-badge" alt="Last commit" />
</p>

<p align="center">Yet another Chess web app.

<p align="center">
  <img src="./assets/demo.jpg" alt="chessu" width="640" />
</p>

- play against other users in real-time
- spectate and chat in ongoing games with other users
- _optional_ user accounts for tracking stats and game history
- ~~play solo against Stockfish~~ (wip)
- mobile-friendly
- ... and more ([view roadmap](https://github.com/users/dotnize/projects/2))

Built with Next.js 14, Tailwind CSS + daisyUI, react-chessboard, chess.js, Express.js, socket.io and PostgreSQL.

## Development

> Node.js 20 or newer is recommended.

This project is structured as a monorepo using **pnpm** workspaces, separated into three packages:

- `client` - Next.js application for the front-end, ~~deployed to ches.su via Vercel~~.
- `server` - Node/Express.js application for the back-end, ~~deployed to server.ches.su via Railway~~.
- `types` - Shared type definitions required by the client and server.

### Getting started

1. Install [pnpm](https://pnpm.io/installation).
2. Install the necessary dependencies by running `pnpm install` in the root directory of the project.
3. In the `server` directory, create a `.env` file for your PostgreSQL database. You can try [ElephantSQL](https://www.elephantsql.com/) or [Aiven](https://aiven.io/postgresql) for a free hosted database.
   ```env
   PGHOST=db.example.com
   PGUSER=exampleuser
   PGPASSWORD=examplepassword
   PGDATABASE=chessu
   ```
4. Run the development servers with `pnpm dev`.
   - To run the frontend and backend servers separately, use `pnpm dev:client` and `pnpm dev:server`, respectively.
5. You can now access the frontend at http://localhost:3000 and the backend at http://localhost:3001.

## Running chessu with Docker

To build the project with Docker, you can use the provided `Dockerfile`.
```sh
docker build -t chessu .
```

This command will build the Docker image with the name `chessu`. You can then run the image with the following command:
```sh
docker run -p 3000:3000 -p 3001:3001 chessu
```

Once built, to start the project with POSTGRES, you can use the provided `docker-compose.yml` file.
```sh
docker-compose up
```
Please make sure to modify the values in the `server/.env` file to match the values in the `docker-compose.yml` file or vice versa.

The entrypoint for the Docker image is set to run pnpm.
The Dockerfile's `CMD` instruction is set to run the project in production mode. 
If you want to run the project in development mode, you can override the `CMD` instruction by running the following command:
```sh
docker run -p 3000:3000 -p 3001:3001 chessu dev # runs both client and server in development mode
docker run -p 3000:3000 -p 3001:3001 chessu dev:client # runs only the client in development mode
docker run -p 3000:3000 -p 3001:3001 chessu dev:server # runs only the server in development mode
```
## Contributing

Please read our [Contributing Guidelines](./CONTRIBUTING.md) before starting a pull request.

## License

[MIT](./LICENSE)
