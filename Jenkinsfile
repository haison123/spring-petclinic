pipeline {
    agent {
        docker {
            // Use an image with Maven installed
            image 'maven:latest'
            // Set up a volume to mount the Maven repository to avoid downloading dependencies on each build
            args '-u root'
            // args '-v $HOME/.m2:/root/.m2'
        }
    }
    environment {
        DEPLOY_CRES=credentials('deploy-server')
    }

    stages {
        stage('Deploy') {
            steps {
                echo "hello"
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
