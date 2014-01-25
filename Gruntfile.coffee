module.exports = (grunt) ->

  grunt.initConfig

    # Read the main package
    pkg: grunt.file.readJSON('package.json')

    # Set Banner
    banner: '/**\n' +
      '<%= pkg.title %> - <%= pkg.version %>\n' +
      '<%= pkg.homepage %>\n' +
      'Copyright (c) <%= grunt.template.today("yyyy") %>' +
      '<%= pkg.author.name %>\n' +
      'License: <%= pkg.license %>\n' +
      '*/\n',

    # Set the directory defaults
    dir:
      js: 'js'
      coffee: 'js/coffee'
      css: 'css'
      sass: 'css/scss'
      img: 'img'

    # Distribution
    dist:
      root: 'dist'
      js: 'dist/js'
      css: 'dist/css'
      img: 'dist/img'

    # Concatenate files
    # https://github.com/gruntjs/grunt-contrib-concat
    concat:
      dist:
        src: [
          '<%= dir.js %>/*.js'
        ]
        dest: '<%= dist.js %>/scripts.js'

    # Validate files with JSHint.
    # https://github.com/gruntjs/grunt-contrib-jshint
    jshint:
      all: [
        '<%= dir.js %>/*.js'
      ]

    # Uglify
    # Minify files with UglifyJS
    # https://github.com/gruntjs/grunt-contrib-uglify
    uglify:
      build:
        src: [
          '<%= dist.js %>/scripts.js'
        ]
        dest: '<%= dist.js %>/scripts.min.js'

    # Image Min
    # Minify PNG and JPEG images
    # https://github.com/gruntjs/grunt-contrib-imagemin
    imagemin:
      compress:
        options:
          optimizationLevel: 3
        files: [
          expand: true
          cwd: '<%= dir.img %>/'
          src:  '{,*/}*.{png,jpg,jpeg}'
          dest: '<%= dist.img %>'
        ]

    # Minify SVG
    # https://github.com/sindresorhus/grunt-svgmin
    svgmin:
      options:
        plugins: [
          removeViewBox: false
          removeUselessStrokeAndFill: false
        ]
      dist:
        files: [
          expand: true
          cwd: '<%= dir.img %>/'
          src: ['**/*.svg']
          dest: '<%= dist.img %>/'
        ]

    # Compile Sass SCSS to CSS
    # https://github.com/sindresorhus/grunt-sass
    sass:
      dev:
        options:
          style: 'expanded'
        files: [
          '<%= dir.css %>/styles.css' : '<%= dir.sass %>/styles.scss'
        ]
      dist:
        options:
          style: 'compressed'
        files: [
          '<%= dist.css %>/styles.css' : '<%= dir.sass %>/styles.scss'
        ]

    # Compile CoffeeScript files to JavaScript.
    # https://github.com/gruntjs/grunt-contrib-coffee
    coffee:
      compile:
        files: [
          '<%= dir.js %>/scripts.js' : '<%= dir.coffee %>/scripts.coffee'
        ]

    # CoffeeLint
    # https://github.com/vojtajina/grunt-coffeelint
    coffeelint:
      app: [
        '<%= dir.coffee %>/*.coffee'
        'gruntfile.coffee'
      ]
      options:
        'no_trailing_whitespace':
          'level': 'error'

    # Notify
    # Automatic Notifications when Grunt tasks fail.
    # https://github.com/dylang/grunt-notify
    notify_hooks:
      options:
        enabled: true
        max_jshint_notifications: 5

    # Copy files and folders
    # https://github.com/gruntjs/grunt-contrib-copy
    copy:
      main:
        files: [
          {
            expand: true
            src: '.htaccess'
            dest: '<%= dist.root %>'
          },{
            expand: true
            src: 'robots.txt'
            dest: '<%= dist.root %>'
          }
        ]

    # Minify HTML
    # https://github.com/gruntjs/grunt-contrib-htmlmin
    htmlmin:
      dist:
        options:
          removeComments: true
          collapseWhitespace: true
        files:
          '<%= dist.root %>/index.html' : 'index.html'

    # Clear files and folders
    # https://github.com/gruntjs/grunt-contrib-clean
    clean:
      root: [
        '<%= dist.root %>'
      ]
      scripts: [
        '<%= dist.js %>/scripts.js'
      ]

    rename:
      scripts:
        src: '<%= dist.js %>/scripts.min.js'
        dest: '<%= dist.js %>/scripts.js'

    # Run tasks whenever watched files change.
    # https://github.com/gruntjs/grunt-contrib-watch
    watch:
      options:
        livereload: true
      scripts:
        files: [
          '<%= dir.js %>/*.js'
          '<%= dir.coffee %>/*.coffee'
          '<%= uglify.build.src %>'
        ]
        tasks: [
          'coffee'
          'coffeelint'
          'jshint'
        ]
        options:
          spawn: false
      css:
        files: [
          '<%= dir.sass %>/*.scss'
        ]
        tasks: 'sass:dev'
        options:
          spawn: false
      scaffold:
        files: [
          '**/*.{html,php}',
          '<%= dir.img %>/**/*.{png,jpg,jpeg,gif,svg}'
        ]

  # Load Tasks
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-imagemin')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-notify')
  grunt.loadNpmTasks('grunt-contrib-jshint')
  grunt.loadNpmTasks('grunt-svgmin')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-htmlmin')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-rename')

  # Run Notify
  grunt.task.run('notify_hooks')

  # Run with 'grunt'
  grunt.registerTask('default', [
    'sass:dev'
    'coffee'
    'coffeelint'
    'jshint'
  ])

  # Run with 'grunt production'
  grunt.registerTask('production', [
    'clean:root'
    'coffee'
    'coffeelint'
    'sass:dist'
    'concat'
    'uglify'
    'jshint'
    'copy'
    'svgmin'
    'imagemin'
    'htmlmin'
    'clean:scripts'
    'rename:scripts'
  ])