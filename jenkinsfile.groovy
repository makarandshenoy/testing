pipeline {
   agent {
       node {
           label 'master'
    }
   }
   stages {
     stage ('git clone') {
       steps {
        sh 'git clone https://github.com/makarandshenoy/testing.git'
      }
     }      
     stages ('terraform init') {
       steps {
        sh 'terraform init'
      }
     }
    }
