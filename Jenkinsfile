def registry = 'https://neejyodee.jfrog.io/'
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
        stage("build"){
            steps {
                echo "#########Build started#####"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "#########Build completed#####"
            }
        }
        stage("test"){
            steps{
                echo "#########Unit test started#####"
                sh 'mvn surefire-report:report'
                echo "#######Unit test completed#####"
            }
        }
    
    stage('SonarQube analysis') {
    environment {
      scannerHome = tool 'valaxy-Sonar-Scanner'
    }
    steps{  
    withSonarQubeEnv('valaxy-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
      sh "${scannerHome}/bin/sonar-scanner"
    }
    }
  }
        
  }

        stage("Jar Publish") {
       steps {
           script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"Jfrog-artifacts-Jenkins-creds"
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
}

