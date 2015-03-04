module.exports = (grunt) ->
  grunt.initConfig
    vimlint:
        files: ['_vimrc']
    
    bashlint:
        files: ['**/*.bash']
    
    lualint:
        files: ['_nyagos']
  
  testTasks = []
  
  unless /^win/.test(process.platform)
    Array.prototype.push.apply(testTasks, ['vimlint', 'bashlint'])
    
  grunt.registerTask 'test', testTasks
  
  require('load-grunt-tasks')(grunt)
  
