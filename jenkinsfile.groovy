pipeline {
   agent {
       node {
           label 'master'
    }
   }
   stage('terraform init') {
      steps {
        sh 'terraform init'
   
     }
    }  