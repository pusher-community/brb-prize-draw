var gulp = require('gulp')
var concat = require('gulp-concat')
var uglify = require('gulp-uglify')

var sources = [
  'public/bower_components/sylvester/sylvester.js',
  'public/bower_components/hammerjs/hammer.min.js',
  'public/bower_components/es6-promise/es6-promise.js',
  'public/bower_components/fetch/fetch.js',
  'public/bower_components/pusher/dist/web/pusher.js',
  'public/script.js'
]

gulp.task('default', function() {
  return gulp.src(sources)
    .pipe(concat('build.js', {newLine: '\n\n;'}))
    .pipe(uglify())
    .pipe(gulp.dest('./public/'));
})
