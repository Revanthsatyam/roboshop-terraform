pipeline {
  agent any

  options {
    ansiColor('xterm')
  }

  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Environment')
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Pick Action')
  }

  stages {

    stage ('Terraform Apply') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        sh 'make-${ENV}'
      }
    }

    stage ('Terraform Destroy') {
      when {
        expression { params.ACTION == 'destroy' }
      }
      steps {
        sh 'make-${ENV}-${ACTION}'
      }
    }

  }

}