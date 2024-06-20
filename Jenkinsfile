pipeline {
  agent any

  options {
    ansiColor('xterm')
  }

  parameters {
    choice(name: 'ENV', choices: ['prod', 'dev'], description: 'Environment')
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Pick Action')
  }

  stages {

    stage ('Apply') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        sh 'make ${ENV}'
      }
    }

    stage ('Destroy') {
      when {
        expression { params.ACTION == 'destroy' }
      }
      steps {
        sh 'make ${ENV}-${ACTION}'
      }
    }

  }

}