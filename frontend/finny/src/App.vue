<template>
  <v-app id="inspire">
      <v-navigation-drawer
        v-model="drawer"
        fixed
        clipped
        class="grey lighten-4"
        app
      >
        <v-list
          dense
          class="grey lighten-4"
        ><br>
          <template v-for="(item, i) in navItems">
            <v-layout
              v-if="item.heading"
              :key="i"
              row
              align-center
            >
              <v-flex xs6>
                <v-subheader v-if="item.heading">
                  {{ item.heading }}
                </v-subheader>
              </v-flex>
              <v-flex xs6 class="text-xs-right">
                <v-btn small flat>edit</v-btn>
              </v-flex>
            </v-layout>
            <v-divider
              v-else-if="item.divider"
              :key="i"
              dark
              class="my-3"
            >
            </v-divider>
            <v-list-tile
              v-else
              :key="i"
              :href="item.path"
            >
              <v-list-tile-action>
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-tile-action>
              <v-list-tile-content>
                <v-list-tile-title class="grey--text">
                  {{ item.name }}
                </v-list-tile-title>
              </v-list-tile-content>
            </v-list-tile>
          </template>
        </v-list>
      </v-navigation-drawer>
      <v-toolbar dark color="primary" app absolute clipped-left>
        <v-toolbar-side-icon @click.native="drawer = !drawer"></v-toolbar-side-icon>
        <span class="title m1-3 mr-5">Finny</span>
        <v-text-field
          solo-inverted
          flat
          hide-details
          label="Search"
          prepend-inner-icon="search"
        ></v-text-field>
        <v-spacer></v-spacer>
      </v-toolbar>
      <v-content>
        <router-view/>
    </v-content>
  </v-app>
</template>

<script>

  export default {
    name: 'App',
    data: () => ({
      drawer: null,
      navItems: [
        { name: 'Home', icon: 'home', path: '#/', disabled: false },
        { divider: true },
        { heading: 'Shortcuts'},
        { name: 'Add New Account', icon: 'add', path: '#/addAccount'},
        { name: 'Add New Account Type', icon: 'add', path: '#/addAccountType'},
        { name: 'Add New Transaction', icon: 'add'},
        { divider: true },
        { name: 'Dashboard', icon: 'dashboard', path: '#/dashboard', disabled: false },
        { name: 'Accounts', icon: 'account_balance', path: '#/accounts', disabled: true },
        { name: 'Spending', icon: 'money', path: '#/spending', disabled: false },
        { name: 'Transactions', icon: 'compare_arrows', path: '#/transactions', disabled: false },
      ]
    }),
    props: {
      source: String
    }
  }
</script>

