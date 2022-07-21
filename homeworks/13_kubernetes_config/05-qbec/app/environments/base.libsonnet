{
  components: {
    app: {
       replicasFront: 1,
       replicasBack: 1,
       replicasDb: 1,
       imageFront: "emiltk/kubernetes-config_frontend:latest",
       imageBack: "emiltk/kubernetes-config_backend:latest",
       imageDb: "postgres:13-alpine",
    },
  },
}