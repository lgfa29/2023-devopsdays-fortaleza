# DevOpsDays Fortaleza 2023

## Estratégias de deploy com HashiCorp Nomad

### Rodando Nomad em modo dev

Baixe a instale a versão mais recente do Nomad disponível em
https://developer.hashicorp.com/nomad/downloads.

Inicie um agente em modo dev.

```console
$ nomad agent -dev
==> No configuration files loaded
==> Starting Nomad agent...
==> Nomad agent configuration:

       Advertise Addrs: HTTP: 127.0.0.1:4646; RPC: 127.0.0.1:4647; Serf: 127.0.0.1:4648
            Bind Addrs: HTTP: [127.0.0.1:4646]; RPC: 127.0.0.1:4647; Serf: 127.0.0.1:4648
                Client: true
             Log Level: DEBUG
               Node Id: ead47e39-66a5-6d13-619d-dc6379ca21fe
                Region: global (DC: dc1)
                Server: true
               Version: 1.6.1

==> Nomad agent started! Log data will stream in below:
```

Acesse a UI do Nomad no URL http://localhost:4646.

## Rodando jobs com estratégias de deploy diferentes

Para cada job disponível nessa pasta, rode a primeira versão no cluster Nomad.

```console
$ nomad run recreate.nomad.hcl
==> 2023-09-01T18:01:39-03:00: Monitoring evaluation "95e16058"
    2023-09-01T18:01:39-03:00: Evaluation triggered by job "recreate"
    2023-09-01T18:01:39-03:00: Allocation "0f99be29" created: node "4d1d9e93", group "server"
    2023-09-01T18:01:39-03:00: Allocation "fe23d813" created: node "4d1d9e93", group "server"
    2023-09-01T18:01:39-03:00: Allocation "ff742eba" created: node "4d1d9e93", group "server"
    2023-09-01T18:01:40-03:00: Evaluation within deployment: "2d491e92"
    2023-09-01T18:01:40-03:00: Allocation "0f99be29" status changed: "pending" -> "running" (Tasks are running)
    2023-09-01T18:01:40-03:00: Allocation "fe23d813" status changed: "pending" -> "running" (Tasks are running)
    2023-09-01T18:01:40-03:00: Allocation "ff742eba" status changed: "pending" -> "running" (Tasks are running)
    2023-09-01T18:01:40-03:00: Evaluation status changed: "pending" -> "complete"
==> 2023-09-01T18:01:40-03:00: Evaluation "95e16058" finished with status "complete"
==> 2023-09-01T18:01:40-03:00: Monitoring deployment "2d491e92"
  ⠹ Deployment "2d491e92" in progress...

    2023-09-01T18:01:40-03:00
    ID          = 2d491e92
    Job ID      = recreate
    Job Version = 0
    Status      = running
    Description = Deployment is running

    Deployed
    Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
    server      3        3       0        0          2023-09-01T18:11:39-03:00
```

Acesse a página do job na UI do Nomad
http://localhost:4646/ui/jobs/recreate@default.

Modifique o arquivo do job para rodar a aplicação com nome de `v2`.

```diff
env {
  WHOAMI_PORT_NUMBER = NOMAD_PORT_http
- WHOAMI_NAME        = "v1"
+ WHOAMI_NAME        = "v2"
}
```

Roda o job novamente para atualizar a versão.

```console
$ nomad run recreate.nomad.hcl
==> 2023-09-01T18:03:58-03:00: Monitoring evaluation "ec800320"
    2023-09-01T18:03:58-03:00: Evaluation triggered by job "recreate"
    2023-09-01T18:03:59-03:00: Evaluation within deployment: "ecf4ba25"
    2023-09-01T18:03:59-03:00: Allocation "9b5fb4dc" created: node "4d1d9e93", group "server"
    2023-09-01T18:03:59-03:00: Allocation "be990a03" created: node "4d1d9e93", group "server"
    2023-09-01T18:03:59-03:00: Allocation "f981144d" created: node "4d1d9e93", group "server"
    2023-09-01T18:03:59-03:00: Evaluation status changed: "pending" -> "complete"
==> 2023-09-01T18:03:59-03:00: Evaluation "ec800320" finished with status "complete"
==> 2023-09-01T18:03:59-03:00: Monitoring deployment "ecf4ba25"
  ✓ Deployment "ecf4ba25" successful

    2023-09-01T18:04:10-03:00
    ID          = ecf4ba25
    Job ID      = recreate
    Job Version = 1
    Status      = successful
    Description = Deployment completed successfully

    Deployed
    Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
    server      3        3       3        0          2023-09-01T18:14:09-03:00
```
