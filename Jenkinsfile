pipeline {
    agent {
        label 'maven'
    }

    parameters {
        booleanParam(defaultValue: true, description: 'Enable SonarQube Scan', name: 'ENABLE_SONAR_SCAN')
        credentials(name: 'SSH_CREDENTIALS', defaultValue: 'deploy-server', description: 'SSH credentials for deployment')
    }

    environment {
        DOCKER_IMAGE = 'haison123/spring-demo'
        CONTAINER_NAME = "spring-demo"
    }

    stages {
        // stage('Test and Scan') {
        //     parallel {
        //         stage('SonarQube Scan') {
        //             when {
        //                 expression {
        //                     params.ENABLE_SONAR_SCAN == true
        //                 }
        //             }
        //             steps {
        //                 sh 'mvn -v'
        //                 echo "============Running Sonar Scan and publish result to Sonar Server============"
        //                 // script {
        //                 //     def scannerHome = tool name: 'Sonar', type 'hudson.plugin.sonar.SonarRunnerInstallation';
        //                 //     withSonarQubeEnv('SonarQube') {
        //                 //         sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectkey=demo -Dsonar.sources=."
        //                 //     }
        //                 // }
        //             }
        //         }

        //         stage('Unit Test') {
        //             steps {
        //                 // Run unit tests
        //                 sh 'mvn test'
        //             }
        //         }
        //     }
        // }

        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'USER_NAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        def commitSHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                        def timestamp = new Date().format("yyyyMMdd")
                        TAG = "develop-${commitSHA}-${timestamp}"
                    }
                    sh "docker login -u $USER_NAME -p $PASSWORD"
                    echo "==========BUILD DOCKER IMAGE============"
                    echo "Image Tag: ${env.DOCKER_IMAGE}:${TAG}"
                    sh "docker build -t ${env.DOCKER_IMAGE}:${TAG} ."
                    sh "docker tag ${env.DOCKER_IMAGE}:${TAG} ${env.DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Push') {
            steps {
                sh "docker push ${env.DOCKER_IMAGE}:${TAG}"
                sh "docker push ${env.DOCKER_IMAGE}:latest"
            }
        }
        
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: params.SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY', usernameVariable: 'USER_NAME')]) {
                    sh "docker ps -a --filter 'name=^${env.CONTAINER_NAME}' --format '{{.ID}}' | xargs -r docker stop || true"
                    sh "docker run -d -p 8080:8080 --name ${env.CONTAINER_NAME} ${DOCKER_IMAGE}:${TAG}"
                }
            }
        }
    }
}
