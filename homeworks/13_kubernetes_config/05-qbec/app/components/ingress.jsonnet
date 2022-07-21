[
{
   "apiVersion": "networking.k8s.io/v1",
   "kind": "Ingress",
   "metadata": {
      "name": "ingress-hosts"
   },
   "spec": {
      "rules": [
         {
            "host": "netelogy.devops12.ru.",
            "http": {
               "paths": [
                  {
                     "path": "/",
                     "pathType": "Prefix",
                     "backend": {
                        "service": {
                           "name": "frontend-service",
                           "port": {
                              "number": 80
                           }
                        }
                     }
                  }
               ]
            }
         }
      ]
   }
},
]