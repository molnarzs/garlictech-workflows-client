  _ = require 'lodash'
webpack = require 'webpack'
path = require 'path'

IsUnitTest = process.env.KARMA_TEST is 'unit'

module.exports = (dirname) ->
  commonConfig = (require './common')(dirname)
  PATHS = commonConfig.paths
  
  (config) ->
    "use strict"

    webpackConf = _.assign {entry: "./client/test/#{process.env.KARMA_TEST}/test.coffee"}, commonConfig.config

    webpackConf.plugins.push new webpack.ProvidePlugin
      test: path.join PATHS.src, 'test', process.env.KARMA_TEST

    config.set
      files: [{pattern: "client/test/#{process.env.KARMA_TEST}/test.coffee"}]
      watched: IsUnitTest
      included: true
      served: true
      singleRun: not IsUnitTest

      preprocessors:
        "client/test/#{process.env.KARMA_TEST}/test.coffee": ['webpack']
      
      webpack: commonConfig.config

      webpackMiddleware:
        stats:
          colors: true

      webpackServer:
        progress: false,
        stats: true,
        debug: true,
        quiet: false

      autoWatch : true
      colors: true
      logLevel: "debug"
      frameworks: ['mocha', 'chai-sinon', 'chai-as-promised', 'sinon']
      browsers : ['Chrome']
      captureTimeout: 60000
      reportSlowerThan: 500

      plugins : [
        'karma-chrome-launcher',
        'karma-mocha',
        'karma-chai-sinon',
        'karma-sinon',
        'karma-mocha-reporter',
        'karma-webpack',
        # 'karma-coverage'
        'karma-chai-plugins',
      ]

      reporters: ['mocha']
      # reporters: ['mocha', 'coverage']