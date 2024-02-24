pipeline {
  agent any

  options {
    ansicolor('xterm')
  }

  parameters {
    string(name: 'ENV', defaultValue: 'prod', description: 'Environment')
  }

  stages {

    stage('Terraform Apply') {
      steps {
        sh 'make ${ENV}'
      }
    }

  }
}