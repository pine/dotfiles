module.exports = (grunt) ->
  testTasks = []
  
  unless /^win/.test(process.platform)
    Array.prototype.push.apply(testTasks, ['vimlint', 'bashlint'])
  
  if process.env.CI
    testTasks.push('mochacov:coverage')
  else
    testTasks.push('mochacov:test')
  
  # -----------------------------------------------------------------
  
  grunt.initConfig
    concurrent:
      test: testTasks
    
    mochacov:
      options:
        files: ['test/**/*.js']
      
      test:
        options:
          reporter: 'spec'
      
      coverage:
        options:
          coveralls: true
    
    vimlint:
        files: ['_vimrc']
    
    bashlint:
        files: ['**/*.bash']
    
    lualint:
        files: ['_nyagos']
  
  # -----------------------------------------------------------------
  
  grunt.registerTask 'test', 'concurrent:test'
  
  require('load-grunt-tasks')(grunt)
  
