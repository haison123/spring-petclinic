pipeline {
    agent any

    parameters {
        booleanParam(defaultValue: true, description: 'Enable SonarQube Scan', name: 'ENABLE_SONAR_SCAN')
        credentials(name: 'SSH_CREDENTIALS', defaultValue: 'deploy-server', description: 'SSH credentials for deployment')
    }

    environment {
        DOCKER_IMAGE = 'haison123/spring-demo'
        CONTAINER_NAME = "spring-demo"
    }

    stages {
        stage('Prepare') {
            steps {
                script {
                    def commitSHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def timestamp = new Date().format("yyyyMMdd-HHmmss")
                    TAG = "develop-${commitSHA}-${timestamp}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // You can use TAG here
                    echo "TAG: ${TAG}"
                }
            }
        }
        // stage('Test and Scan') {
        //     parallel {
        //         stage('SonarQube Scan') {
        //             when {
        //                 expression {
        //                     params.ENABLE_SONAR_SCAN == true
        //                 }
        //             }
        //             steps {
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

        // stage('Build') {
        //     steps {
        //         sh 'docker build -t ${env.DOCKER_IMAGE}:${env.TAG} .'
        //         sh 'docker tag ${env.DOCKER_IMAGE}:${env.TAG} ${env.DOCKER_IMAGE}:latest'
        //     }
        // }

        
        // stage('Deploy') {
        //     steps {
        //         withCredentials([sshUserPrivateKey(credentialsId: params.SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY', usernameVariable: 'USER_NAME')]) {
        //             sh '''
        //                 docker ps -a --filter "name=^${env.CONTAINER_NAME" --format "{{.ID}}" | xargs -r docker stop || true
        //                 docker start -d -p 8080:8080 --name ${env.CONTAINER_NAME} ${DOCKER_IMAGE}:$env{TAG}
        //             '''
        //         }
        //     }
        // }
    }
}
