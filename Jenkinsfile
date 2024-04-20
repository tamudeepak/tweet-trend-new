pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }
    stages {
        stage("build") {
            steps {
                echo "#########Build started#####"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "#########Build completed#####"
            }
        }
        stage("test") {
            steps {
                echo "#########Unit test started#####"
                sh 'mvn surefire-report:report'
                echo "#######Unit test completed#####"
            }
        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'valaxy-Sonar-Scanner'
            }
            steps {
                withSonarQubeEnv('valaxy-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        stage('Dev') {
            steps {
                echo "Deploying to Dev environment..."
                // Add deployment steps for Dev environment
            }
        }
        stage('Prod') {
            steps {
                echo "Deploying to Prod environment..."
                // Add deployment steps for Prod environment
            }
        }
    }
}
