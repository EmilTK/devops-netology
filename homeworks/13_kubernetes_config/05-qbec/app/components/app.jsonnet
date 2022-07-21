local p = import '../params.libsonnet';
local params = p.components.app;

[
{
   "apiVersion": "apps/v1",
   "kind": "Deployment",
   "metadata": {
      "name": "frontend",
      "labels": {
         "name": "frontend"
      }
   },
   "spec": {
      "replicas": params.replicasFront,
      "selector": {
         "matchLabels": {
            "name": "frontend"
         }
      },
      "template": {
         "metadata": {
            "labels": {
               "name": "frontend"
            }
         },
         "spec": {
            "containers": [
               {
                  "name": "fronend",
                  "image": params.imageFront,
                  "imagePullPolicy": "IfNotPresent",
                  "ports": [
                     {
                        "containerPort": 80
                     }
                  ],
                  "env": [
                     {
                        "name": "BASE_URL",
                        "value": "http://localhost:9000"
                     }
                  ]
               }
            ]
         }
      }
   }
},
{
   "apiVersion": "apps/v1",
   "kind": "Deployment",
   "metadata": {
      "name": "backend",
      "labels": {
         "name": "backend"
      }
   },
   "spec": {
      "replicas": params.replicasBack,
      "selector": {
         "matchLabels": {
            "name": "backend"
         }
      },
      "template": {
         "metadata": {
            "labels": {
               "name": "backend"
            }
         },
         "spec": {
            "containers": [
               {
                  "name": "backend",
                  "image": params.imageBack,
                  "imagePullPolicy": "IfNotPresent",
                  "ports": [
                     {
                        "containerPort": 9000
                     }
                  ],
                  "env": [
                     {
                        "name": "DATABASE_URL",
                        "value": "postgres://postgres:postgres@postgres-service:5432/news"
                     }
                  ]
               }
            ]
         }
      }
   }
},
{
   "apiVersion": "apps/v1",
   "kind": "Deployment",
   "metadata": {
      "name": "postgres",
      "labels": {
         "name": "postgres"
      }
   },
   "spec": {
      "replicas": params.replicasDb,
      "selector": {
         "matchLabels": {
            "name": "postgres"
         }
      },
      "template": {
         "metadata": {
            "labels": {
               "name": "postgres"
            }
         },
         "spec": {
            "containers": [
               {
                  "name": "postgres",
                  "image": params.imageDb,
                  "imagePullPolicy": "IfNotPresent",
                  "ports": [
                     {
                        "containerPort": 5432
                     }
                  ],
                  env: [
                     {
                        "name": "POSTGRES_PASSWORD",
                        "value": "postgres"
                     },
                     {
                        "name": "POSTGRES_USER",
                        "value": "postgres"
                     },
                     {
                        "name": "POSTGRES_DB",
                        "value": "news"
                     }
                  ],
                  "volumeMounts": [
                     {
                        "name": "postgres-volume",
                        "mountPath": "/var/lib/postgresql/data/"
                     }
                  ]
               }
            ],
            "volumes": [
               {
                  "name": "postgres-volume",
                  "emptyDir": {}
               }
            ]
         }
      }
   }
},
]