/* import shared library */
@Library('shared-libraries')_

pipeline {
    agent any
    environment {
        AMLYS_DOCKERHUB_PWD = credentials('AMLYS_DOCKERHUB_PWD')
        IMAGE_NAME = "ic-webapp"
        IMAGE_TAG = "v1"
        SOURCES_DIR= "ic-webapp-sources"
        // faudra penser à créer image_name var env
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
                    dir('$SOURCES_DIR') {
                        git url: 'https://github.com/Amlys/full-cicd-project.git', branch: 'main'
                    }
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                dir('$SOURCES_DIR') {
                    sh '''
                    echo === Building...
                    docker build -t $IMAGE_NAME . || exit 1

                    echo === Taging the image
                    docker tag $IMAGE_NAME amlys/$IMAGE_NAME:$IMAGE_TAG

                    echo === Logging to DockerHub
                    echo ${AMLYS_DOCKERHUB_PWD} | docker login -u amlys --password-stdin

                    echo === Pushing the image
                    docker push amlys/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
    }
    post {
        // script" - valid conditions are [always, changed, fixed, regression, aborted, success, unsuccessful, unstable, failure, notBuilt, cleanup]
        cleanup {
            cleanWs()
        }

        always {
            script {
                slackNotifier currentBuild.result
            }           
        }

    }
}
