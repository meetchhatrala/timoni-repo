package main

values: {
    appName: "nodeapp"

    image: {
        repository: "meetchhatrala789/nodeapp"
        tag: "latest"
    }

    replicas: 2

    containerPort: 80
}