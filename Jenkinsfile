def registry = 'https://neejyodee.jfrog.io/'
def imageName = 'neejyodee.jfrog.io/niku-docker-local/niku'
def version   = '2.1.2'
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
        stage("Build") {
            steps {
                echo "######### Build started #####"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "######### Build completed #####"
            }
        }
        stage("Test") {
            steps {
                echo "######### Unit test started #####"
                sh 'mvn surefire-report:report'
                echo "####### Unit test completed #####"
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
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url: registry + "/artifactory", credentialsId: "Jfrog-artifacts-Jenkins-creds"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "maven-libs-release-local/{1}",
                                "flat": "false",
                                "props" : "${properties}",
                                "exclusions": [ "*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Jar Publish Ended --------------->'              
                }
            }   
        }
        stage(" Docker Build ") {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build(imageName+":"+version)
                    echo '<--------------- Docker Build Ends --------------->'
                }
            }
        }
        stage (" Docker Publish on JFrog"){
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'Jfrog-artifacts-Jenkins-creds'){
                        app.push()
                    }    
                    echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }

        stage ("Deploy"){
            steps{
                script{
                    sh './deploy.sh'
                }
            }
        }
    }
}
