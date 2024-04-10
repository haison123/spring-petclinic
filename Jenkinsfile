pipeline {
    agent {
                docker {
                    image 'haison123/maven-ssh:1.0.0'
                    args '-u root'
                    // args '-v $HOME/.m2:/root/.m2'
                }
            }

    stages {
        stage('Build') {
            steps {
                // Build the Maven project
                sh 'mvn clean compile -DskipTests'
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
                // Build the Maven project
                sh 'mvn package'
            }
        }

        
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'deploy-server', keyFileVariable: 'SSH_KEY', usernameVariable: 'USER_NAME')]) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $USER_NAME@35.173.171.21 << EOF
                        export APP_PID=$(ps -ef | grep 'java -jar /home/ubuntu/spring-petclinic' | awk '{print $2}' | head -n 1)
                        if [ -z "$APP_PID" ]; then echo "[INFO] APPLICATION IS STARTING ..."; else echo "[INFO] APPLICATION IS RUNNING WITH PID IS: $APP_PID"; echo "[INFO] STOPPING THE OLD VERSION..."; kill -9 $APP_PID; fi
                        echo "[INFO] STARTING THE NEW VERSION OF APPLICATION..."
                        nohup java -jar /home/ubuntu/spring-petclinic-*.jar &
                        echo "[INFO] WAITING FOR READY
                        sleep 10
                        export APP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health)
                        if [ "$APP_STATUS" == "200" ]; then echo "[INFO] APPLICATION STARTED SUCCESSFULLY..."; else echo "[ERROR] UNKNOWN ERROR"; fi
                    '''
                }
            }
        }
    }

    post {
        success {
            stash includes: 'target/*.jar', name: 'my-artifact'
            echo 'Pipeline successful! Artifact saved in /target folder.'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
