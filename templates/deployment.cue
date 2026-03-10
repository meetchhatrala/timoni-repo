{% comment %} package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	#config:    #Config
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata:   #config.metadata
	spec: appsv1.#DeploymentSpec & {
		replicas: #config.replicas
		selector: matchLabels: #config.selector.labels
		template: {
			metadata: {
				labels: #config.selector.labels
				if #config.pod.annotations != _|_ {
					annotations: #config.pod.annotations
				}
			}
			spec: corev1.#PodSpec & {
				containers: [
					{
						name:            #config.metadata.name
						image:           #config.image.reference
						imagePullPolicy: #config.image.pullPolicy
						ports: [
							{
								name:          "http"
								containerPort: 80
								protocol:      "TCP"
							},
						]
						readinessProbe: {
							httpGet: {
								path: "/"
								port: "http"
							}
							initialDelaySeconds: 5
							periodSeconds:       10
						}
						livenessProbe: {
							tcpSocket: {
								port: "http"
							}
							initialDelaySeconds: 5
							periodSeconds:       5
						}
						if #config.resources != _|_ {
							resources: #config.resources
						}
						if #config.securityContext != _|_ {
							securityContext: #config.securityContext
						}
					},
				]
				if #config.pod.affinity != _|_ {
					affinity: #config.pod.affinity
				}
				if #config.pod.imagePullSecrets != _|_ {
					imagePullSecrets: #config.pod.imagePullSecrets
				}
			}
		}
	}
} {% endcomment %}



package main

import "cue"

deployment: {
    apiVersion: "apps/v1"
    kind: "Deployment"

    metadata: {
        name: values.appName
        labels: {
            app: values.appName
        }
    }

    spec: {
        replicas: values.replicas

        selector: {
            matchLabels: {
                app: values.appName
            }
        }

        template: {
            metadata: {
                labels: {
                    app: values.appName
                }
            }

            spec: {
                containers: [{
                    name: values.appName
                    image: "\(values.image.repository):\(values.image.tag)"

                    ports: [{
                        containerPort: values.containerPort
                    }]
                }]
            }
        }
    }
}