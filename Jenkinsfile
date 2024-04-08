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

                    // Set the default branch to 'develop' if BRANCH_NAME is null or empty
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
                    // Publish jar file and deploy.sh
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'deploy-server',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'target/*.jar',
                                    removePrefix: 'target/',
                                    remoteDirectory: '/home/ubuntu'
                                ),
                                sshTransfer(
                                    sourceFiles: 'deploy.sh',
                                    remoteDirectory: '/home/ubuntu'
                                )
                            ]
                        )
                    ])
                    
                    // Execute commands
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'deploy-server',
                            transfers: [
                                sshTransfer(
                                    execCommand: 'chmod +x /home/ubuntu/deploy.sh'
                                ),
                                sshTransfer(
                                    execCommand: '/home/ubuntu/deploy.sh'
                                )
                            ]
                        )
                    ])
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
