pipeline {
    agent {
        label 'maven'
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('BuildApp') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('PackerValidate') {
            steps {
                sh 'packer init .'
                sh 'packer validate packer-config.json'
            }
        }
        
        stage('PackerBuild') {
            steps {
                sh 'packer build packer-config.json 2>&1 | tee output.txt'
                // echo 'UP_STREAM_AMI=$(tail -2 output.txt | head -2 | awk '\''match($0, /ami-.*/) { print substr($0, RSTART, RLENGTH) }'\'')" >> ami.env"
                // echo "==========================================="
                // echo "AMI ID : $(cat ami.env)"
                sh 'cat output.txt'
            }

            // post {
            //     success {
            //         archiveArtifacts artifacts: 'output.txt', reports: [dotenv('output.txt')]
            //     }
            // }
        }        
    }
}
