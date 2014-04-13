module.exports = (grunt) ->

  grunt.initConfig

    # Read the main package
    pkg: grunt.file.readJSON('package.json')

    # Set the directory defaults
    dir:
      app: 'app'
      js: 'app/js'
      coffee: 'app/js/coffee'
      css: 'app/css'
      sass: 'app/css/scss'
      img: 'app/img'

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
      vendor:
        src: [
          '<%= dir.js %>/vendors/*.js'
        ]
        dest: '<%= dir.js %>/plugins.js'

    # Validate files with JSHint.
    # https://github.com/gruntjs/grunt-contrib-jshint
    jshint:
      all: [
        '<%= dir.js %>/*.js'
        '!<%= dir.js %>/plugins.js'
      ]

    # Uglify
    # Minify files with UglifyJS
    # https://github.com/gruntjs/grunt-contrib-uglify
    uglify:
      build:
        src: [
          '<%= dist.js %>/plugins.js'
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
    # https://github.com/gruntjs/grunt-contrib-sass
    sass:
      dev:
        options:
          style: 'expanded'
          require: [
            'bourbon'
            'neat'
          ]
          sourcemap: true
        files: [
          '<%= dir.css %>/styles.css' : '<%= dir.sass %>/main.scss'
        ]
      dist:
        options:
          style: 'compressed'
          require: [
            'bourbon'
            'neat'
          ]
        files: [
          '<%= dist.css %>/styles.css' : '<%= dir.sass %>/main.scss'
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

    # Autoprefixer
    # Parse CSS and add vendor-prefixed CSS properties
    # using the Can I Use database. Based on Autoprefixer
    autoprefixer:
      single_file:
        options:
          browsers: ['last 15 version', 'ie 8', 'ie 9']
        src: '<%= dir.css %>/styles.css'
        dest: '<%= dir.css %>/styles.css'

    # Minify HTML
    # https://github.com/gruntjs/grunt-contrib-htmlmin
    htmlmin:
      dist:
        options:
          removeComments: true
          collapseWhitespace: true
        files:
          '<%= dist.root %>/index.html' : '<%= dir.app %>/index.html'

    # Clear files and folders
    # https://github.com/gruntjs/grunt-contrib-clean
    clean:
      root: [
        '<%= dist.root %>'
      ]
      scripts: [
        '<%= dist.js %>/scripts.js'
      ]
      images: [
        '<%= dir.img %>/sprt.png'
      ]

    rename:
      scripts:
        src: '<%= dist.js %>/scripts.min.js'
        dest: '<%= dist.js %>/scripts.js'

    connect:
      options:
        port: 9000
        livereload: 35729
        hostname: 'localhost'
      livereload:
        options:
          open: true
          base: './<%= dir.app %>'

    # Run grunt tasks concurrently
    # https://github.com/sindresorhus/grunt-concurrent
    concurrent:
      server:
        'sass'

    # Grunt task for converting a set of images into a spritesheet and corresponding CSS variables
    # https://github.com/Ensighten/grunt-spritesmith
    sprite:
      all:
        src: '<%= dir.img %>/*.png'
        destImg: '<%= dir.img %>/sprt.png'
        destCSS: '<%= dir.sass %>/modules/_sprite.scss'
        cssFormat: 'scss'

    # Run tasks whenever watched files change.
    # https://github.com/gruntjs/grunt-contrib-watch
    watch:
      options:
        livereload: true

      images:
        files: [
          '<%= dir.img %>/*.png}'
        ]
        tasks: [
          'clean:image',
          'sprite'
        ]

      scripts:
        files: [
          '<%= dir.js %>/**/*.js'
          '<%= dir.coffee %>/**/*.coffee'
          '<%= uglify.build.src %>'
        ]
        tasks: [
          'concat:vendor'
          'coffee'
          'coffeelint'
          'jshint'
        ]
        options:
          spawn: false

      sass:
        files: [
          '<%= dir.sass %>/**/*.scss'
        ]
        tasks: [
          'sass:dev'
          'autoprefixer'
        ]
        options:
          spawn: false

      scaffold:
        files: [
          '**/*.{html,php}',
          '<%= dir.img %>/**/*.{png,jpg,jpeg,gif,svg}'
        ]

  # Load Tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Run Notify
  grunt.task.run('notify_hooks')

  # Run with 'grunt'
  grunt.registerTask 'default', [
    'sass:dev'
    'coffee'
    'coffeelint'
    'concat:vendor'
    'jshint'
  ]

  # Run with 'grunt production'
  grunt.registerTask 'production', [
    'clean:root'
    'coffee'
    'coffeelint'
    'sass:dist'
    'autoprefixer'
    'concat'
    'uglify'
    'jshint'
    'copy'
    'svgmin'
    'imagemin'
    'htmlmin'
    'clean:scripts'
    'rename:scripts'
  ]

  grunt.registerTask 'serve', (target) ->
    if target == 'dist'
      return grunt.task.run(['build', 'connect:dist:keepalive'])

    grunt.task.run(
      'autoprefixer'
      'connect:livereload'
      'watch'
    )