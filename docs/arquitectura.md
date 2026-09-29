# Arquitectura de la infraestructura

La infraestructura utiliza una red privada Docker con el segmento:

`10.10.0.0/24`

## Servicios

- WEB: Nginx — `10.10.0.10`
- APP: Apache HTTP Server — `10.10.0.20`
- DB: MariaDB — `10.10.0.30`

## Arquitectura

```text
                 infra-network
                  10.10.0.0/24
                       |
          +------------+------------+
          |            |            |
       WEB          APP           DB
   10.10.0.10   10.10.0.20   10.10.0.30
     Nginx        Apache       MariaDB
