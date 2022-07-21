local base = import './base.libsonnet';

base {
  components +: {
    app +: {
       replicasFront: 3,
       replicasBack: 3,
       replicasDb: 3,
       imageFront: "emiltk/kubernetes-config_frontend:latest",
       imageBack: "emiltk/kubernetes-config_backend:latest",
       imageDb: "postgres:13-alpine",
    },
  }
}