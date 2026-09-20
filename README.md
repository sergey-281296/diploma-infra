# Дипломный проект: Облачная инфраструктура и Kubernetes (K3s)

## Описание
В рамках дипломного проекта была спроектирована и развернута отказоустойчивая облачная инфраструктура в Yandex Cloud. Реализован полный цикл DevOps: от IaC (Terraform) до оркестрации (K3s), мониторинга (Prometheus/Grafana) и автоматизации доставки (CI/CD GitHub Actions).

## Архитектура решения
- **IaC:** Terraform (S3 backend, модульная структура)
- **Orchestration:** K3s (1 Master + 2 Preemptible Workers)
- **Config Management:** Ansible (автоматическая установка кластера)
- **Monitoring:** kube-prometheus-stack (Helm)
- **CI/CD:** GitHub Actions (Build Docker -> Push YCR -> Deploy K8s)
- **Registry:** Yandex Container Registry

## Скриншоты выполнения этапов

### 1. Инфраструктура (Terraform)
| Этап | Скриншот |
|------|----------|
| Bootstrap SA & S3 Bucket | ![01](screenshots/01-bootstrap-sa-and-bucket.png) |
| Создание ВМ и сети | ![02](screenshots/02-main-infra-applied.png) |
| Публичные IP воркеров | ![03](screenshots/03-workers-public-ip.png) |

### 2. Kubernetes Cluster (Ansible + K3s)
| Этап | Скриншот |
|------|----------|
| Установка K3s через Ansible | ![04](screenshots/04-k3s-installation.png) |
| Статус нод (Ready) | ![05](screenshots/05-k8s-cluster-ready.png) |

### 3. Приложение и Мониторинг
| Этап | Скриншот |
|------|----------|
| Сборка Docker образа | ![06](screenshots/06-test-app-build.png) |
| Установка Helm чарта | ![07](screenshots/07-monitoring-installed.png) |
| Статус всех подов | ![08](screenshots/08-all-pods-running.png) |
| Дашборд Grafana | ![09](screenshots/09-grafana-dashboard.png) |
| Веб-интерфейс приложения | ![10](screenshots/10-app-web-interface.png) |

### 4. Автоматизация (CI/CD)
| Этап | Скриншот |
|------|----------|
| Конфигурация Workflow | ![11](screenshots/11-cicd-workflow.png) |
| Секреты репозитория (App) | ![12](screenshots/12-all-secrets-updated.png) |
| Секреты репозитория (Infra) | ![13](screenshots/13-terraform-secrets.png) |
| Успешный пайплайн CI/CD | ![14](screenshots/14-cicd-success.png) |
| Финальный статус Jobs | ![15](screenshots/15-cicd-success.png) |

## Ссылки на связанные репозитории
- ️ [diploma-infra](https://github.com/sergey-281296/diploma-infra) — Terraform код инфраструктуры
- ⚙️ [diploma-k8s-config](https://github.com/sergey-281296/diploma-k8s-config) — Ansible playbooks и Helm values
- 🐳 [diploma-app](https://github.com/sergey-281296/diploma-app) — Dockerfile и исходный код приложения
