pipeline {

    agent {node {label '<lable name>'} } (or) any
    stages { 

        stage('Cloning our Git') { 

            steps { 

                git 'https://github.com/HarikaVanapalli/palindrome.git'
            }

        } 
        
         stage("java compile") {
            steps {
                sh '''
                 cd palindrome
                 javac *.java
                '''
            }
        }
         stage('Java pacakge') {
         
         steps {
          sh 'jar cfe Palindrome.jar Palindrome *.class'
         }
	   }
	   
        stage('Docker image build') {
          
		  steps {
            script { 
                    dockerImage = docker.build reg + ":$BUILD_NUMBER" 
                }
		    }
         }
		 
		 stage('Deploy our image') { 

            steps { 

                script { 

                    docker.withRegistry( '', registryCredential ) { 

                        dockerImage.push() 
                    }

                } 

            }