<template>
  <v-app>
    <v-toolbar dark color="primary">
      <v-toolbar-side-icon>
        <v-btn icon @click.stop="leftDrawer = !leftDrawer">
          <v-icon>menu</v-icon>
        </v-btn>
      </v-toolbar-side-icon>
      <v-toolbar-title>{{ title }}</v-toolbar-title>
      <v-spacer></v-spacer>
    </v-toolbar>
    <v-content>
      <router-view/>
    </v-content>
    <v-navigation-drawer
      v-model="leftDrawer"
      absolute
      temporary
      :navItems="navItems"
      app
    >
      <v-list>
        <v-list-tile v-for="item in navItems" :key="item.name" :href="item.path">
          <v-list-tile-content>
            {{ item.name }}
          </v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-footer :fixed="fixed" app>
      <span>&copy; 2017</span>
    </v-footer>
  </v-app>
</template>

<script>

export default {
  name: 'App',
  data () {
    return {
      clipped: false,
      drawer: true,
      fixed: false,
      miniVariant: false,
      left: true,
      leftDrawer: false,
      title: 'Finny',
      navItems: [
        { name: 'Home', path: '#/', disabled: false },
        { name: 'Dashboard', path: '#/dashboard', disabled: false },
        { name: 'Accounts', path: '#/accounts', disabled: true },
      ]
    }
  },
}
</script>
