pipeline {
    agent any
    environment {
        AMLYS_DOCKERHUB_PWD = credentials('AMLYS_DOCKERHUB_PWD')
    }
    parameters {
        booleanParam(name: 'is_release', defaultValue: false, description: 'is release ?')
        string(name: 'image_name', defaultValue: 'ic-webapp', description: 'the docker image name')
    }
    stages {
        stage('Checkout') {
            steps {
                // on utilise script ici car pour cloner dans un folder spécifique on peut pas directement dans steps git url
                script {
                    dir('ic-webapp') {
                        git url: 'https://github.com/Amlys/full-cicd-project.git', branch: 'main'
                    }
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                dir('ic-webapp') {
                    sh '''
                    echo === Building...
                    docker build -t ic-webapp . || exit 1

                    echo === Taging the image
                    docker tag ic-webapp amlys/ic-webapp:v1

                    echo === Logging to DockerHub
                    echo ${AMLYS_DOCKERHUB_PWD} | docker login -u amlys --password-stdin

                    echo === Pushing the image
                    docker push amlys/ic-webapp:v1
                    '''
                }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}