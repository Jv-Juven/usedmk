
module.exports = (grunt)->
	
	stringify = require 'stringify'
	coffeeify = require 'coffeeify'

	# 项目配置
	grunt.initConfig {
		pkg: grunt.file.readJSON("package.json"),

		# 压缩文件
		uglify: {
			options: {
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
			},
			build: {
				src: "src/<%= pkg.name %>.js",
				dest: "build/<%= pkg.name %>.min.js"
			},
			index: {
				src: "src/**/index.js",
				dest: "dist/index.min.js"
			}
		},

		# coffee文件编译成js文件
		coffee:{
			example: {
				options: {
					#separator: linefeed # Concatenated files will be joined on this string.
					#bare: true # Compile the JavaScript without the top-level function safety wrapper.
					#join: false # When compiling multiple .coffee files into a single .js file, concatenate first.
					#sourceMap: false # Compile JavaScript and create a .map file linking it to the CoffeeScript source. When compiling multiple .coffee files to a single .js file, concatenation occurs as though the 'join' option is enabled
					#sourceMapDir:  (same path as your compiled js files) # Generated source map files will be created here.
					#joinExt: '.src.coffee' # Resulting extension when joining multiple CoffeeScript files.#
				},
				files: {
					"dist/js/index.js": ["src/index/index.coffee", "src/index/home.coffee"]
				}
			},
			yiyuan: {
				options: {
					bare: true
				},
				files: {
					# "dist/js/login.js": ["src/login/login.coffee"],
					"dist/js/layout.js": ["src/common/layout.coffee"]
				}
			}
			# glob_to_multiple: {
			#     expand: true,
			#     flatten: true,
			#     cwd: 'path/to',
			#     src: ['*.coffee'],
			#     dest: 'path/to/dest/',
			#     ext: '.js'
			# }
		}

		browserify: {
			common:
                options:
                  preBundleCB: (b)->
                    b.transform(coffeeify)
                    b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
                expand: true
                flatten: true
                files: {
                    'dist/js/common.js': ['src/common/layout.coffee','src/common/config.coffee'],
                    'dist/js/components.js': ['src/components/*.coffee'],
                }
            dist: {
                files: {
                  "dist/js/layout.js": ["src/common/layout.coffee"]
                  'dist/js/components.js': ['src/components/*.coffee']
                  "dist/js/register.js": ["src/pages/register.coffee"]
                  "dist/js/login.js": ["src/pages/login.coffee"]
                  "dist/js/home.js": ["src/pages/home.coffee"]
                  "dist/js/issue.js": ["src/pages/issue.coffee"]
                },
                options: {
                  transform: ['coffeeify']
                }
              }
		}

		# 清除文件
		clean: {
			build: {
				src: ["dist"]
			}
		}

		# stylus文件编译成css文件
		stylus: {
			compile: {
				option: {
					# 参数列表 详见：https://www.npmjs.com/package/grunt-contrib-stylus
				},
				files: {
					"dist/css/index.css": ["src/stylus/index.styl", "src/stylus/home.styl"]
					"dist/css/dev.css": "src/stylus/index.styl"
				}
			},
			usedmk: {
				options: {
					compress: false
					},
				files: {
					"dist/css/common.css": ["src/common/layout.styl", "src/common/common.styl"]
					"dist/css/components.css": ["src/components/*.styl"]
					"dist/css/login.css": ["src/pages/login.styl"]
					"dist/css/home.css": ["src/pages/home.styl"]
					"dist/css/search.css": ["src/pages/search.styl"]
					"dist/css/issue.css": ["src/pages/issue.styl"]
				}
			}
		}

		# concat合并文件
		# concat: {
		#   options: {
		#       separator: ';'
		#   },
		#   css: {
		#       src: ["dist/css/dev.css", "dist/css/index.css"],
		#       dist: "dist/concat.css",
		#   }
		# }

		# copy 复制文件到指定的路径
		copy: {
			dev: {
				files: [
					# {expand: true, flatten: false, src: ["src/**/**"], dest: 'copy/'}
					# {expand: true, flatten: true, src: ["lib/css/*"], dest: 'dist/lib/css/'}
				]
			}
		}

		# cssmin 压缩css
		cssmin: {
			options: {
				shorthandCompacting: false,
				roundingPrecision: -1
			},
			target: {
				files: {
					'output.css': ['foo.css', 'bar.css']
				}
			}
		}

		# watch 监视文件的改动
		watch:
			compile:
				options:
					livereload: true    #true
				files: ['src/**/*.styl', 'src/**/*.coffee']
				tasks: ['stylus', 'browserify']



		# browserify 可以让你像nodejs那样使用require()函数 注：若需使用请参考教程(https://www.npmjs.com/package/grunt-browserify)，并且需要配置该文件
		# 这里有个例子：
		# 将指定文件的依赖项加载到文件中，可类似nodejs的做法

		# stringify = require 'stringify'
		# coffeeify = require 'coffeeify'

		# browserify:
		#     pages:
		#         options:
		#           preBundleCB: (b)->
		#             b.transform(coffeeify)
		#             b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
		#         expand: true
		#         flatten: true
		#         files: {
		#             'dist/js/index.js': ['src/index/*.coffee']
		#             'dist/js/itegral.js': ['src/itegral/*.coffee']
		#         }


	}


	# 加载任务的插件
	grunt.loadNpmTasks "grunt-browserify"
	grunt.loadNpmTasks "grunt-contrib-uglify"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-stylus"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-contrib-copy"
	grunt.loadNpmTasks "grunt-contrib-cssmin"
	grunt.loadNpmTasks "grunt-contrib-watch"


	# 默认被执行的任务列表
	grunt.registerTask "default","default tasks", ()->
		grunt.task.run [
			"clean",
			# "coffee:yiyuan",
			"stylus:usedmk",
			"browserify:dist",
			"watch"
		]
	grunt.registerTask "all", "all tasks", ()->
		grunt.task.run [
			"clean",
			"uglify",
			"coffee:example",
			"stylus",
			"watch"
		]