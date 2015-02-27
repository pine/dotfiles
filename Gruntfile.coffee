module.exports = (grunt) ->
  grunt.initConfig
    vimlint:
     files: ['_vimrc']
  
  testTasks = []
  
  unless /^win/.test(process.platform)
    testTasks.push('vimlint')
    
  grunt.registerTask 'test', testTasks
  
  require('load-grunt-tasks')(grunt)
  