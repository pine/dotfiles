module.exports = (grunt) ->
  grunt.initConfig
    vimlint:
      files: ['_vimrc']
    
    lualint:
      files: ['_nyagos']
  
  testTasks = []
  
  unless /^win/.test(process.platform)
    testTasks.push('vimlint')
    
  grunt.registerTask 'test', testTasks
  
  require('load-grunt-tasks')(grunt)
  