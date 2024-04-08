pipeline {
    agent {
        docker {
            // Use an image with Maven installed
            image 'maven:latest'
            // Set up a volume to mount the Maven repository to avoid downloading dependencies on each build
            args '-v $HOME/.m2:/root/.m2'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Determine the branch being built
                    def branchName = env.BRANCH_NAME

                    // Set the default branch to 'master' if BRANCH_NAME is null or empty
                    if (!branchName) {
                        branchName = 'develop'
                    }

                    // Clone the repository with the corresponding branch
                    git branch: branchName, url: 'https://github.com/yourusername/your-spring-boot-project.git'
                    echo " Branch ${env.BRANCH_NAME} is cloned"
                }
            }
        }

        stage('Build') {
            steps {
                // Build the Maven project
                sh 'mvn clean package'
            }
        }

        stage('Unit Test') {
            steps {
                // Run unit tests
                sh 'mvn test'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // SCP the .jar file to the server
                    sshagent(credentials: ['deploy-server']) {
                        sh "scp -o StrictHostKeyChecking=no target/*.jar ubuntu@http://ec2-35-173-171-21.compute-1.amazonaws.com/:/home/ubuntu"

                        // SSH into the server and run the .jar file using nohup
                        sshCommand remote: [
                            host: 'http://ec2-35-173-171-21.compute-1.amazonaws.com/',
                            user: 'ubuntu',
                            credentialsId: 'deploy-server'
                        ], command: """
                            export APP_PID=$(ps -ef | grep 'java -jar /home/ubuntu/spring-petclinic' | awk '{print $2}' | head -n 1)
                            if [ -z "$APP_PID" ]; then echo "[INFO] APPLICATION IS STARTING..."; else echo "[INFO] APPLICATION IS RUNNING WITH PID IS: $APP_PID"; echo "[INFO] STOPPING THE OLD VERSION..."; kill -9 $APP_PID; fi
                            echo "[INFO] STARTING THE NEW VERSION OF APPLICATION..."
                            nohup java -jar /home/ubuntu/spring-petclinic-*.jar &
                            export APP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health)
                            if [ "$APP_STATUS" == "200" ]; then echo "[INFO] APPLICATION STARTED SUCCESSFULLY..."; else echo "[ERROR] UNKNOWN ERROR"; fi
                          """, interpreter: '/bin/sh'
                    }
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
            echo 'pipeline failed!'
        }
    }
}
