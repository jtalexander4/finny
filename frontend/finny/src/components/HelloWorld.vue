<template>
  <v-container fluid>
    <v-slide-y-transition mode="out-in">
      <v-layout column align-center>
        <v-list>
          <v-list-tile v-for="item in items" :key="item.id" @click="showSubtitle(item)">
            <v-list-tile-content>
              <v-list-tile-title class="title">{{ item.title }}</v-list-tile-title>
              <v-list-tile-sub-title v-show="item.visible">{{ item.id }}</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>
        </v-list>
      </v-layout>
    </v-slide-y-transition>
  </v-container>
</template>

<script>
import _ from 'lodash'
import gql from 'graphql-tag'

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data () {
    return {
      items: []
    }
  },
  methods: {
    showSubtitle (item) {
      item.visible = !item.visible
    }
  },
  mounted () {
    this.$apollo.query({
      query: gql`{
        allAccountTypes {
          nodes {
            id
            name
          }
        }
      }`
    }).then(response => {
      let records = response.data.allAccountTypes.nodes
      _.forEach(records, record => {
        this.items.push({title: record.id, id: record.name, visible: false})
      })
    })
  }
}
</script>
