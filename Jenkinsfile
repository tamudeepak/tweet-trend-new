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
            when {
                expression {
                    currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo "Deploying to Dev environment..."
                // Add deployment steps for Dev environment
            }
        }
        stage('Prod') {
            when {
                expression {
                    currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                script {
                    def userInput = input(
                        id: 'deployProd',
                        message: 'Deploy to Prod? (yes/no)',
                        parameters: [
                            [$class: 'ChoiceParameter', choiceType: 'string', name: 'Confirmation', choices: 'yes\nno']
                        ]
                    )
                    if (userInput == 'yes') {
                        echo "Deploying to Prod environment..."
                        // Add deployment steps for Prod environment
                    } else {
                        echo "Skipping deployment to Prod environment."
                    }
                }
            }
        }
    }
}

