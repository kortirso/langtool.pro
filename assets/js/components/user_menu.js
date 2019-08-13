import ClickOutside from 'vue-click-outside'

if ($('#user_menu').length) {
  new Vue({
    el: '#user_menu',
    data: {
      opened: false
    },
    methods: {
      openMenu: function() {
        this.opened = !this.opened
      },
      hideMenu: function() {
        this.opened = false
      }
    },
    mounted: function() {
      this.popupItem = this.$el
    },
    directives: {
      ClickOutside
    }
  })
}
