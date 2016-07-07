module.exports =
  jade: '/**/*.jade'
  sass: '/**/*.scss'
  browserify: [ '/**/*.bundle.+(coffee|js|es)' ]
  coffee: '/**/!(*.bundle).coffee'
  babel: '/**/!(*.bundle).es'
  static: '/**/*.+(html|css|js|jpg|png|svg|ico|mp3|json|yml|ttf|eot|woff|woff2)'
  test:
    unit: './test/unit/**/*.spec.+(coffee|js|es)'
    e2e: './test/e2e/**/*.spec.+(coffee|js|es)'
