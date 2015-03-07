module.exports = (grunt) ->
  grunt.initConfig
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
  
  testTasks = []
  
  unless /^win/.test(process.platform)
    Array.prototype.push.apply(testTasks, ['vimlint', 'bashlint'])
  
  infraTestTasks = ['mochacov:test']
  if process.env.CI
    infraTestTasks.push('mochacov:coverage')
  
  grunt.registerTask 'test', testTasks.concat(infraTestTasks)
  
  require('load-grunt-tasks')(grunt)
  
