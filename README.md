# 🛡️ Security Scanner for Kubernetes Clusters

A modular security scanning stack for Kubernetes clusters that integrates **Popeye**, **Kubescape**, and **Trivy**. This project wraps these tools in a containerized workflow, with automation via Kubernetes CronJobs and Azure Blob Storage integration for report storage.

---

## 📦 Tools Included

- **[Popeye](https://github.com/derailed/popeye)** – scans for misconfigurations and hygiene issues in K8s resources.
- **[Kubescape](https://github.com/kubescape/kubescape)** – performs compliance and security scanning.
- **[Trivy](https://github.com/aquasecurity/trivy)** – container vulnerability scanner with HTML reports.
- Azure CLI and `kubectl` preinstalled for cloud-native integration.

---

## 🚀 Getting Started

### 🔧 Prerequisites

- Kubernetes cluster with access to deploy CronJobs.
- Azure Blob Storage account with container access and credentials.
- A Kubernetes secret (`azure-storage-secret`) for the following:
  - `STORAGE_ACCOUNT`
  - `AZURE_STORAGE_KEY`
  - `CONTAINER_NAME`
- Docker and `kubectl` installed locally (for image builds and testing).

---

## 🐳 Build Docker Image

```bash
docker build -t yourregistry/security-scanner:latest .

```
---

## 🐳 Push it to your registry (e.g., Azure Container Registry):

```bash
docker push yourregistry/security-scanner:latest
```
---

## ☁️ Deploy CronJobs to Kubernetes
### 🛠 Setup Service Account & Permissions
Apply the following manifests before deploying the scanners:

```bash
kubectl apply -f security-scanner-sa.yaml
kubectl apply -f security-scanner-role.yaml
kubectl apply -f security-scanner-rolebinding.yaml
```
---

## 📅 Deploy Scanners as CronJobs
```bash
kubectl apply -f cronjob.yaml
```
This will schedule the three tools to run daily at 07:00 UTC.

---

## 📜 How It Works
Each scan runs in an isolated CronJob pod:

***popeye-script.sh:*** runs popeye, generates HTML, uploads to Azure.

***kubescape.sh:*** performs compliance scans (DevOpsBest + CIS), uploads HTML reports.

***trivy.sh:*** scans images from all deployments, produces Trivy HTML reports.

***All reports are uploaded under:***

```bash
<container>/security-scan/<date>/[tool]-report.html
```
---

## 📁 Project Structure
```pgsql
├── Dockerfile
├── cronjob.yaml
├── popeye-script.sh
├── kubescape.sh
├── trivy.sh
├── security-scanner-sa.yaml
├── security-scanner-role.yaml
├── security-scanner-rolebinding.yaml
```

---
## 🤝 Contributing
Contributions, feature requests, and feedback are welcome! To contribute:

1. Fork the repo

2. Create a feature branch (git checkout -b feat/my-feature)

3. Commit your changes

4. Open a pull request

---

## 📄 License
This project is licensed under the MIT License. See the LICENSE file for details.

```sql
MIT License

Copyright (c) 2025 Subin Sabu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
---

## 👤 Maintainer

***Subin Sabu***

***GitHub: @subinsabu390***

---
