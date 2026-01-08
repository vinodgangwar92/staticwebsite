pipeline {
    agent any

    environment {
        REGISTRY = "docker.io"                        // Docker registry (DockerHub)
        IMAGE_NAME = "vinodgangwar92/staticwebsite"   // DockerHub repo name
        IMAGE_TAG = "${env.BUILD_NUMBER}"             // Unique tag per build
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/vinodgangwar92/staticwebsite.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',     // Jenkins me store DockerHub credentials
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                       echo "$DOCKER_PASS" | docker login ${REGISTRY} -u "$DOCKER_USER" --password-stdin
                       docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                       docker logout ${REGISTRY}
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                // Example: Stop old container and start new
                sh """
                   docker stop staticweb || true
                   docker rm staticweb || true
                   docker run -d --name staticweb -p 80:80 ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline completed!"
        }
    }
}
