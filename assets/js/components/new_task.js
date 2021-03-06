import VueResource from 'vue-resource'

const extensions = {'ruby_on_rails': '.yml', 'react_js': '.json', 'laravel': '.json'}
const locales = {'da': 'Danish', 'de': 'Deutsch', 'en': 'English', 'fr': 'French', 'ru': 'Russian', 'es': 'Spanish'}

Vue.use(VueResource)

if ($('#new_task').length) {
  new Vue({
    el: '#new_task',
    data: {
      framework: '',
      file: null,
      fileName: null,
      translationKey: null,
      from: '',
      to: '',
      error: null
    },
    computed: {
      extension: function() {
        return this.framework === '' ? '' : extensions[this.framework]
      },
      originalLanguage: function() {
        return this.from === '' ? 'Autodetection' : locales[this.from]
      },
      fileError: function() {
        return this.error !== null
      }
    },
    watch: {
      framework: function() {
        this.file = null
        this.fileName = null
        this.translationKey = null
        this.setError(null)
        $('#localization_file').val('')
      },
      file: function() {
        this.to = ''
      }
    },
    methods: {
      uploadFile: function(event) {
        // update file
        this.file = event.target.files[0]
        this.fileName = "Selected: " + event.target.files[0].name
        // send file for locale autodetection
        let data = new FormData()
        data.append('file', this.file)
        data.append('framework', this.framework)
        const config = { headers : { 'Content-Type' : 'multipart/form-data' } }
        this.$http.post('http://localhost:4000/api/v1/tasks/detection', data, config).then(function(data) {
          if (data.body.code !== undefined) {
            const locale = locales[data.body.code]
            if (locale !== undefined) {
              this.from = data.body.code
              this.error = null
            } else this.setError('Locale is not supported')
          } else this.setError(data.body.error)
        })
      },
      setError: function(error) {
        this.from = ''
        this.error = error
      },
      createTask: function() {
        let data = new FormData()
        data.append('task[translation_key_id]', this.translationKey)
        data.append('task[file]', this.file)
        data.append('task[from]', this.from)
        data.append('task[to]', this.to)
        data.append('task[status]', 'created')
        data.append('_csrf_token', $('#_csrf_token').val())
        data.append('framework', this.framework)
        const config = { headers : { 'Content-Type' : 'multipart/form-data' } }
        this.$http.post('http://localhost:4000/tasks', data, config).then(function(data) {
          window.location.href = 'http://localhost:4000/tasks'
        })
      }
    }
  })
}
