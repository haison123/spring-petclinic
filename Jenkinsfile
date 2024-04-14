pipeline {
    agent {
        docker {
            image 'haison123/maven-ssh:1.0.0'
            args '-u root'
        }
    }

    parameters {
        booleanParam(defaultValue: true, description: 'Enable SonarQube Scan', name: 'ENABLE_SONAR_SCAN')
        credentials(name: 'SSH_CREDENTIALS', defaultValue: 'deploy-server', description: 'SSH credentials for deployment')
    }

    stages {
        stage('Build') {
            steps {
                // Build the Maven project
                sh 'mvn clean compile -DskipTests'
            }
        }

        stage('SonarQube Scan') {
            when {
                expression {
                    params.ENABLE_SONAR_SCAN == true
                }
            }
            steps {
                echo "============Running Sonar Scan and publish result to Sonar Server============"
                // script {
                //     def scannerHome = tool name: 'Sonar', type 'hudson.plugin.sonar.SonarRunnerInstallation';
                //     withSonarQubeEnv('SonarQube') {
                //         sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectkey=demo -Dsonar.sources=."
                //     }
                // }
            }
        }

        stage('Unit Test') {
            steps {
                // Run unit tests
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                // Package
                sh 'mvn package'
            }
        }

        
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: params.SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY', usernameVariable: 'USER_NAME')]) {
                    sh '''
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY deploy.sh $USER_NAME@35.173.171.21:/home/ubuntu
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY target/*.jar $USER_NAME@35.173.171.21:/home/ubuntu
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $USER_NAME@35.173.171.21 chmod +x /home/ubuntu/deploy.sh
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $USER_NAME@35.173.171.21 sudo /home/ubuntu/deploy.sh
                    '''
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            echo 'Pipeline successful! Artifact saved in /target folder.'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
