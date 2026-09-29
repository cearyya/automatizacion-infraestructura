# Automatización de Infraestructura

Proyecto de automatización y despliegue de una infraestructura de servicios utilizando **Terraform, Docker, Ansible, Bash y Git**.

## 1. Descripción

El proyecto implementa una infraestructura basada en contenedores Docker conectados mediante una red privada, cuya creación y configuración se administra principalmente mediante Terraform.

La infraestructura está compuesta por tres servicios:

* **WEB:** servidor Nginx.
* **APP:** servidor Apache HTTP Server.
* **DB:** servidor MariaDB.

Ansible se utiliza para verificar el estado de los contenedores y comprobar la conectividad entre los diferentes servicios.

Los scripts Bash permiten automatizar las operaciones principales de despliegue, verificación y destrucción de la infraestructura.

---

## 2. Arquitectura

```text
                    HOST
                     │
                     │ HTTP :8082
                     ▼
              ┌───────────────┐
              │   infra-web   │
              │    Nginx      │
              │ 10.10.0.10    │
              └───────┬───────┘
                      │
                      │ HTTP
                      ▼
              ┌───────────────┐
              │   infra-app   │
              │    Apache     │
              │ 10.10.0.20    │
              └───────┬───────┘
                      │
                      │ TCP :3306
                      ▼
              ┌───────────────┐
              │    infra-db   │
              │    MariaDB    │
              │ 10.10.0.30    │
              └───────────────┘

             Red Docker: 10.10.0.0/24
             Gateway: 10.10.0.1
```

## 3. Componentes

| Servicio | Contenedor  | Tecnología    | IP           | Puerto    |
| -------- | ----------- | ------------- | ------------ | --------- |
| WEB      | `infra-web` | Nginx Alpine  | `10.10.0.10` | `8082:80` |
| APP      | `infra-app` | Apache Alpine | `10.10.0.20` | `80`      |
| DB       | `infra-db`  | MariaDB 11    | `10.10.0.30` | `3306`    |

### Red

* Nombre: `infra-network`
* Tipo: `bridge`
* Subred: `10.10.0.0/24`
* Gateway: `10.10.0.1`

---

## 4. Tecnologías utilizadas

* Debian Linux
* Docker
* Terraform
* Ansible
* Bash
* Git
* Nginx
* Apache HTTP Server
* MariaDB

---

## 5. Estructura del proyecto

```text
automatizacion-infraestructura/
├── .gitignore
├── README.md
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.ini
│   └── playbooks/
│       ├── estado_infra.yml
│       ├── pruebas_conectividad.yml
│       └── verificar_infra.yml
├── scripts/
│   ├── deploy.sh
│   ├── destroy.sh
│   └── verify.sh
└── terraform/
    ├── .terraform.lock.hcl
    ├── main.tf
    ├── outputs.tf
    └── variables.tf
```

Los archivos de estado de Terraform (`terraform.tfstate` y `terraform.tfstate.backup`) y el archivo `terraform.tfvars` están excluidos mediante `.gitignore`.

---

## 6. Terraform

Terraform administra los recursos principales de la infraestructura:

* Red Docker.
* Contenedor WEB.
* Contenedor APP.
* Contenedor DB.

### Inicializar Terraform

```bash
cd terraform
terraform init
```

### Validar configuración

```bash
terraform validate
```

### Revisar cambios

```bash
terraform plan
```

### Desplegar

```bash
terraform apply
```

Para realizar el despliegue automáticamente:

```bash
terraform apply -auto-approve
```

---

## 7. Scripts de automatización

### Desplegar infraestructura

Desde la raíz del proyecto:

```bash
./scripts/deploy.sh
```

El script realiza:

1. Inicialización de Terraform.
2. Validación de la configuración.
3. Aplicación de la infraestructura.
4. Mostrar los outputs de Terraform.

### Verificar infraestructura

```bash
./scripts/verify.sh
```

Este script verifica:

1. Configuración de Terraform.
2. Estado de los contenedores Docker.
3. Estado e IP de los servicios mediante Ansible.
4. Conectividad entre WEB, APP y DB.

### Destruir infraestructura

```bash
./scripts/destroy.sh
```

Este script ejecuta la validación y posteriormente destruye los recursos administrados por Terraform.

---

## 8. Ansible

Ansible se ejecuta desde el host Debian utilizando conexión local y la colección `community.docker`.

Los playbooks disponibles son:

### `verificar_infra.yml`

Consulta el estado de los contenedores:

* `infra-web`
* `infra-app`
* `infra-db`

### `estado_infra.yml`

Muestra el estado y la dirección IP de cada servicio.

### `pruebas_conectividad.yml`

Comprueba:

```text
WEB → APP   HTTP
WEB → DB    TCP 3306
APP → DB    TCP 3306
```

---

## 9. Verificación realizada

La infraestructura fue desplegada correctamente y posteriormente verificada.

Resultado obtenido:

```text
WEB: running - IP: 10.10.0.10
APP: running - IP: 10.10.0.20
DB: running - IP: 10.10.0.30
```

Pruebas de conectividad:

```text
WEB -> APP: CONECTADO
WEB -> DB: CONECTADO
APP -> DB: CONECTADO
```

La ejecución de Ansible terminó con:

```text
failed=0
unreachable=0
changed=0
```

Terraform también confirmó que la configuración es válida.

---

## 10. Prueba de destrucción y reconstrucción

Como parte de la comprobación de la automatización, la infraestructura fue destruida utilizando Terraform:

```bash
./scripts/destroy.sh
```

Se confirmó que los recursos administrados por el proyecto fueron eliminados.

Posteriormente se ejecutó:

```bash
./scripts/deploy.sh
```

Terraform reconstruyó correctamente los recursos:

```text
Plan: 4 to add, 0 to change, 0 to destroy.
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

Finalmente se ejecutó:

```bash
./scripts/verify.sh
```

y las pruebas de estado y conectividad fueron satisfactorias.

---

## 11. Git

El proyecto utiliza Git para el control de versiones.

El primer commit registrado es:

```text
fc51ab3 feat: implementar automatizacion de infraestructura
```

Los archivos de estado y configuración local de Terraform que no deben versionarse están excluidos mediante `.gitignore`.

---

## 12. Acceso al servicio WEB

El servidor WEB está publicado en el host mediante el puerto `8082`.

Se puede comprobar con:

```bash
curl -I http://localhost:8082
```

La respuesta esperada es un código HTTP exitoso, como:

```text
HTTP/1.1 200 OK
```

---

## 13. Flujo general

El flujo de trabajo del proyecto es:

```text
        Terraform
            │
            ▼
      Red Docker
            │
     ┌──────┴──────┐
     ▼             ▼
    WEB           APP
     │             │
     └──────┬──────┘
            ▼
           DB
            │
            ▼
         Ansible
            │
            ▼
       Verificación
```

Los scripts Bash proporcionan una interfaz sencilla para ejecutar las operaciones principales:

```text
deploy.sh
    │
    ▼
 Despliegue

verify.sh
    │
    ▼
 Verificación

destroy.sh
    │
    ▼
 Destrucción
```

---

## 14. Estado del proyecto

La infraestructura se encuentra implementada y validada mediante Terraform, Docker y Ansible.

Las pruebas realizadas confirman:

* Configuración válida de Terraform.
* Contenedores funcionando.
* Direccionamiento IP correcto.
* Comunicación WEB → APP.
* Comunicación WEB → DB.
* Comunicación APP → DB.
* Destrucción y reconstrucción de la infraestructura.
* Versionamiento mediante Git.

---

## 15. Introducción

La automatización de infraestructura permite crear, configurar, verificar y
eliminar servicios de manera reproducible mediante código. En este proyecto se
aplican principios de infraestructura como código (IaC) y automatización para
administrar una infraestructura basada en contenedores Docker.

## 16. Problema identificado

La configuración manual de servidores y servicios puede generar errores
humanos, inconsistencias y mayor tiempo de despliegue. Además, cuando una
infraestructura necesita ser reconstruida, realizar nuevamente todos los pasos
manualmente resulta poco eficiente.

Este proyecto busca solucionar este problema mediante Terraform, Docker,
Ansible y scripts Bash, permitiendo que la infraestructura pueda desplegarse,
verificarse y destruirse de forma automatizada y reproducible.

## 17. DevOps aplicado

El proyecto integra prácticas de DevOps mediante la automatización de las
diferentes etapas de administración de la infraestructura:

- Terraform para Infraestructura como Código (IaC).
- Docker para la ejecución aislada de los servicios.
- Ansible para la verificación y administración.
- Bash para automatizar las operaciones principales.
- Git para el control de versiones y seguimiento de cambios.

Esta integración permite reducir tareas manuales y mantener una configuración
reproducible.

## 18. Ventajas de la automatización

La automatización implementada proporciona las siguientes ventajas:

- Reducción de errores humanos.
- Despliegues reproducibles.
- Mayor rapidez para crear la infraestructura.
- Facilidad para destruir y reconstruir los servicios.
- Configuración centralizada mediante código.
- Verificación automatizada del estado y conectividad.
- Historial de cambios mediante Git.

La principal ventaja observada durante las pruebas fue la capacidad de
reconstruir la infraestructura utilizando nuevamente los mismos archivos y
comandos, sin configurar manualmente cada servicio.

## 19. Conclusiones

La implementación permitió comprobar que Terraform, Docker, Ansible, Bash y
Git pueden integrarse para automatizar una infraestructura de servicios.

Las pruebas realizadas demostraron que los contenedores WEB, APP y DB pueden
ser desplegados y verificados correctamente, mantienen comunicación dentro de
la red privada y pueden ser destruidos y reconstruidos mediante código.

Por lo tanto, la automatización facilita la administración de la
infraestructura, mejora la reproducibilidad y reduce el esfuerzo necesario
para realizar nuevamente un despliegue.

## 20. Repositorio

El código fuente, documentación y evidencias del proyecto se encuentran
disponibles en:

https://github.com/cearyya/automatizacion-infraestructura
